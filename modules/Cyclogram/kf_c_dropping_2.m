clear all
%close all
%clc

addpath('../MeasureRelativeCoordinates/mat-data', ...
'../MeasureDistances/mat-data',               ...
'../Common/mat-data',                         ...
'../KalmanFiltering/tools',                   ...
'tools') ;

load common.mat
load measuredCoordLCS.mat
load coordLCSIdeal.mat
load D_Vd_data.mat
load mat-data/ksi_arrays.mat

Time = timeStart:timeStep:timeEnd ;
time_c = timeStart:timeStep:timeEnd ;

gain_type = 'real' ;
% idx_case = '175 252 670' ;
idx_case = '175 252 670' ;
switch idx_case
    case '175 252 670'
        load mat-data/gains/gain_175_252_670
    case '0'
        break ;
end

package_error = 0 ;

if ~package_error
    ksi_start = 5000 ;
    P_satell = -0.1 ;
    %P_satell = 0.1 ;
    [ksi_c_rx, ksi_c_lost, time_c_rx, time_c_lost] = ksi_analysis(ksi_c, ksi_start, time_c, P_satell) ;
    orange = [0.6 0.2 0] ;
    visualize_ksi(ksi_c_rx, time_c_rx, ksi_c_lost, time_c_lost, orange, 'Distances data analysis') ;
else % package_error
    lost_sample_per_package = 5 ;
    pack_err = zeros(1, lost_sample_per_package) ;
    max_bound = length(time_c) - lost_sample_per_package ;
%     idx_pack_err_start = sort(randi([0 max_bound], 3, 1)) ;
    idx_pack_err_start = [40; 132] ;
    idx = [] ;
    for n = 1:length(idx_pack_err_start)
        idx = [idx (0:lost_sample_per_package-1) + idx_pack_err_start(n)] ;
    end
    time_c_lost = Time(unique(idx)) ;
end


Tk_c = 1 ;
coord_filter_type = 'common_accel' ;
% TODO: replace "magic" constants to variables
%sigma_vec = [9 9 13 0.2 0.2 0.3] ;
sigma_vec = [9 13 9 0.2 0.3 0.2] ;

[ F_c, Q_c, H_c, R_c, P_c ] = initialisationKalmanFilter(coord_filter_type, sigma_vec, Tk_c) ;
sigmaQ_kf_c = 10^(-8) ;
Q_c = sigmaQ_kf_c .* Q_c ;

nn = 0 ;

state_vector_c = [measuredCoordLCS(1,1); measuredCoordLCS(1,4); 0; ...
   measuredCoordLCS(1,2); measuredCoordLCS(1,5); 0;    ...
   measuredCoordLCS(1,3); measuredCoordLCS(1,6); 0] ;

extrapolate_c = 0 ; 

est_data_c = zeros(size(F_c,1), length(Time) - 1) ;
extrapolation_data_c = zeros(size(F_c,1), length(Time) - 1) ;
est_data_c_interp = zeros(size(F_c,1), length(time_c_lost)) ;
est_data_interp_mark = zeros(1, length(time_c_lost)) ;
if strcmp(gain_type, 'real')
    K_c_vec = [] ;
    %K_c_vec = zeros(size(F_c,1), length(Time) - 1) ;
end

n_c = 1 ;
mark = 1 ;
num_of_lost = 0 ;
flag_end_package_lost = 0 ;

for k_c = 1:length(Time) - 1
    if any(Time(k_c) == time_c_lost)
        extrapolate_c = 1 ; 
        [ P_c, state_vector_c, extrapolation, ~ ] = kalman_filter( 0, state_vector_c, F_c, 0, Q_c, 0, P_c, extrapolate_c, gain_type, GAIN, n_c ) ;
        est_data_c(:, k_c) = state_vector_c ;
        extrapolation_data_c(:, k_c) = extrapolation ;
        if strcmp(gain_type, 'real')
            %K_c_vec(:, k_d) = K_c ;
        end
        num_of_lost = num_of_lost + 1 ;        
        est_data_interp_mark(mark) = sqrt(state_vector_c(1)^2 + state_vector_c(4)^2 + state_vector_c(7)^2) - D_ideal(k_c+1) ;
        %est_data_d_interp(:, k_d) = state_vector_d ;
        mark = mark + 1 ;
        if package_error
            if num_of_lost == lost_sample_per_package % 
                [ F_c, Q_c, H_c, R_c, P_c ] = initialisationKalmanFilter(coord_filter_type, sigma_vec, Tk_c) ;
                sigmaQ_kf_c = 10^(-8) ;
                Q_c = sigmaQ_kf_c .* Q_c ;
                n_c = 1 ;
                flag_end_package_lost = 1 ;
            end
        end
        continue ;
    end
    if (flag_end_package_lost > 0)
        %est_data_d(:, k_d) = [D_noisy(k_d+1,1); est_data_d(2, k_d-1); 0] ;
        est_data_c(:, k_c) = [measuredCoordLCS(k_c+1,1); measuredCoordLCS(k_c+1,4); 0; ...
                              measuredCoordLCS(k_c+1,2); measuredCoordLCS(k_c+1,5); 0;    ...
                              measuredCoordLCS(k_c+1,3); measuredCoordLCS(k_c+1,6); 0] ;
        state_vector_c = est_data_c(:, k_c) ;
        K_c_vec = [K_c_vec K_c] ;
        flag_end_package_lost = flag_end_package_lost - 1 ;
        continue ;
    end
    
    extrapolate_c = 0 ; 
    [ P_c, state_vector_c, extrapolation, K_c ] = kalman_filter( measuredCoordLCS(k_c+1,:)', state_vector_c, F_c, R_c, Q_c, H_c, P_c, extrapolate_c, gain_type, GAIN, n_c ) ;
    est_data_c(:, k_c) = state_vector_c ;
    extrapolation_data_c(:, k_c) = extrapolation ;
    if strcmp(gain_type, 'real') 
        K_c_vec = [K_c_vec K_c] ;
    end
    n_c = n_c + 1 ;
    num_of_lost = 0 ; % receive a measurement -> reset num_of_lost
end

D_est = sqrt(est_data_c(1,:).^2 + est_data_c(4,:).^2 + est_data_c(7,:).^2) ;
D_est_extrapolation = sqrt(extrapolation_data_c(1,:).^2 + extrapolation_data_c(4,:).^2 + extrapolation_data_c(7,:).^2) ;
Vd_est = (est_data_c(1,:) .* est_data_c(2,:) + est_data_c(4,:) .* est_data_c(5,:) + est_data_c(7,:) .* est_data_c(8,:)) ./ D_est ;
Vd_est_extrapolation = (extrapolation_data_c(1,:) .* extrapolation_data_c(2,:) + extrapolation_data_c(4,:) .* extrapolation_data_c(5,:) + extrapolation_data_c(7,:) .* extrapolation_data_c(8,:)) ./ D_est_extrapolation ;

green  = [0.17 0.51 0.34] ; % green color
orange = [0.87 0.49 0] ;    % orange color

figure(); 
plot(Time(2:end), D_est - D_ideal(2:end)', 'Color', green); 
hold on
plot(time_c_lost+Tk_c, est_data_interp_mark, 'sq', 'MarkerEdgeColor','k', 'MarkerFaceColor','c', 'MarkerSize', 5); 
plot(Time(2:end), D_est_extrapolation - D_ideal(2:end)', 'Color', orange) ;
grid on
xlabel('t, s')
ylabel('\delta D, m')

figure(); 
plot(Time(2:end), Vd_est - Vd_ideal(2:end)', 'r'); 
grid on
xlabel('t, s')
ylabel('\delta V_d, m/s')




