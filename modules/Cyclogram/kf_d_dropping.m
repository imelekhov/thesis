clear all
%close all
%clc

addpath('../MeasureRelativeCoordinates/mat-data', ...
'../MeasureDistances/mat-data',               ...
'../Common/mat-data',                         ...
'../KalmanFiltering/tools',                   ...
'tools') ;

load common.mat
load D_Vd_data.mat
load ksi_arrays.mat

Time = timeStart:timeStep:timeEnd ;
time_d = timeStart:timeStep:timeEnd ;

gain_type = 'real' ;
% idx_case = '175 252 670' ;
idx_case = '175 252 670' ;
switch idx_case
    case '175 252 670'
        load mat-data/gains/gain_175_252_670
    case '0'
        GAIN = [0.5; 0.1; 0.0] ;
end

package_error = 1 ;

if ~package_error
    ksi_start = 5000 ;
    %P_d = -0.1 ;
    [ksi_d_rx, ksi_d_lost, time_d_rx, time_d_lost] = ksi_analysis(ksi_d, ksi_start, time_d, P_d) ;
    orange = [0.6 0.2 0] ;
    visualize_ksi(ksi_d_rx, time_d_rx, ksi_d_lost, time_d_lost, orange, 'Distances data analysis') ;
else % package_error
    lost_sample_per_package = 30 ;
    pack_err = zeros(1, lost_sample_per_package) ;
    max_bound = length(time_d) - lost_sample_per_package ;
    %idx_pack_err_start = sort(randi([0 max_bound], 3, 1)) ;
    idx_pack_err_start = [175; 252; 670] ;
    idx = [] ;
    for n = 1:length(idx_pack_err_start)
        idx = [idx (0:lost_sample_per_package-1) + idx_pack_err_start(n)] ;
    end
    time_d_lost = Time(unique(idx)) ;
end


Tk_d = 0.2 ;

[ F_d, Q_d, H_d, R_d, P_d ] = initialisationDistanceFilter( sigma_D, Tk_d ) ;
sigmaQ_kf_d = 10^(-4) ;
Q_d = sigmaQ_kf_d .* Q_d ;

nn = 0 ;

state_vector_d = [0; 0; 0] ;

extrapolate_d = 0 ; % always

est_data_d = zeros(size(F_d,1), length(Time) - 1) ;
est_data_d_interp = zeros(size(F_d,1), length(time_d_lost)) ;
est_data_interp_mark = zeros(1, length(time_d_lost)) ;
if strcmp(gain_type, 'real') 
    K_d_vec = zeros(size(F_d,1), length(Time) - 1) ;
end

n_d = 1 ;
mark = 1 ;
num_of_lost = 0 ;
for k_d = 1:length(Time) - 1
    if any(Time(k_d) == time_d_lost)
        extrapolate_d = 1 ; 
        [ P_d, state_vector_d, ~ ] = kalman_filter( 0, state_vector_d, F_d, 0, Q_d, 0, P_d, extrapolate_d, gain_type, GAIN, n_d ) ;
        est_data_d(:, k_d) = state_vector_d ;
        if strcmp(gain_type, 'real') 
            K_d_vec(:, k_d) = K_d ;
        end
        num_of_lost = num_of_lost + 1 ;        
        est_data_interp_mark(mark) = state_vector_d(1) - D_ideal(k_d+1) ;
        %est_data_d_interp(:, k_d) = state_vector_d ;
        mark = mark + 1 ;
        if package_error
            if num_of_lost == lost_sample_per_package % 
                [ F_d, Q_d, H_d, R_d, P_d ] = initialisationDistanceFilter( sigma_D, Tk_d ) ;
                sigmaQ_kf_d = 10^(-4) ;
                Q_d = sigmaQ_kf_d .* Q_d ;
            end
        end
        continue ;
    end
    extrapolate_d = 0 ; 
    [ P_d, state_vector_d, K_d ] = kalman_filter( D_noisy(k_d+1,1), state_vector_d, F_d, R_d, Q_d, H_d, P_d, extrapolate_d, gain_type, GAIN, n_d ) ;
    est_data_d(:, k_d) = state_vector_d ;
    if strcmp(gain_type, 'real') 
        K_d_vec(:, k_d) = K_d ;
    end
    n_d = n_d + 1 ;
    num_of_lost = 0 ; % receive a measurement -> reset num_of_lost
end
figure(); 
plot(Time(2:end), est_data_d(1,:) - D_ideal(2:end)', 'r'); 
hold on
plot(time_d_lost+0.2, est_data_interp_mark, 'sq', 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize', 5); 
grid on
xlabel('t, s')
ylabel('\delta D, m')

figure(); 
plot(Time(2:end), est_data_d(2,:) - Vd_ideal(2:end)', 'r'); 
grid on
xlabel('t, s')
ylabel('\delta V_d, m/s')

diff_d = est_data_d(1,:) - D_ideal(2:end)' ;
mean_error_d = mean(diff_d) 
std_error_d = sqrt(mean(diff_d .^ 2) - (mean(diff_d)) .^ 2) 

diff_vd = est_data_d(2,:) - Vd_ideal(2:end)' ;
mean_error_vd = mean(diff_vd)  
std_error_vd = sqrt(mean(diff_vd .^ 2) - (mean(diff_vd)) .^ 2)  


green  = [0.17 0.51 0.34] ; % green color
orange = [0.87 0.49 0] ;    % orange color

