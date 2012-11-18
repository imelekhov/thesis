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

timeStart = 1 ;
measuredCoordLCS = measuredCoordLCS(6:end,:) ;
Time = timeStart:timeStep:timeEnd ;
time_c = timeStart:timeEnd ;
% Time = time_c ;
% idx_array = 1:5:size(measuredCoordLCS, 1) ;

ksi_start = 4000 ;
P_satell = -0.1 ;
[ksi_c_rx, ksi_c_lost, time_c_rx, time_c_lost] = ksi_analysis(ksi_c, ksi_start, time_c, P_satell) ;
orange = [0.6 0.2 0] ;
% visualize_ksi(ksi_c_rx, time_c_rx, ksi_c_lost, time_c_lost, orange, 'Distances data analysis') ;


gain_type = 'real' ;
coord_filter_type = 'common_accel' ;
% TODO: replace "magic" constants to variables
sigma_vec = [9 9 13 0.2 0.2 0.3] ;
GAIN = [] ;

% %% TEST (kf_c every 0.2)
% Tk_c = 0.2 ; %time interval between data receiving from Navigation Satellites 
% [ F_c, Q_c, H_c, R_c, P_c ] = initialisationKalmanFilter(coord_filter_type, sigma_vec, Tk_c) ;
% sigmaQ_kf_c = 10^(-8) ;
% Q_c = sigmaQ_kf_c .* Q_c ;
% 
% state_vector_c = [0; 0; 0; ...
%    0; 0; 0;    ...
%    0; 0; 0];
% 
% extrapolate_c = 0 ; % initialisation
% est_data_c = zeros(size(F_c,1), length(Time) - 1) ;
% 
% n_c = 1 ;
% 
% for k_c = 1:length(Time)
%     extrapolate_c = 0 ;
%     [ P_c, state_vector_c, K_c ] = kalman_filter( measuredCoordLCS(k_c,:)', state_vector_c, F_c, R_c, Q_c, H_c, P_c, extrapolate_c, gain_type, GAIN, n_c ) ;
%     est_data_c(:, k_c) = state_vector_c ;
%     %K_c_vec(:, k_c) = K_c ;
%     
%     n_c = n_c + 1 ;
% end
% D_est_c = sqrt(est_data_c(1,:).^2 + est_data_c(4,:).^2 + est_data_c(7,:).^2) ;
%%


Tk_c = 1 ; % time interval between data receiving from Navigation Satellites 
[ F_c, Q_c, H_c, R_c, P_c ] = initialisationKalmanFilter(coord_filter_type, sigma_vec, Tk_c) ;
sigmaQ_kf_c = 10^(-8) ;
Q_c = sigmaQ_kf_c .* Q_c ;

state_vector_c = [0; 0; 0; ...
   0; 0; 0;    ...
   0; 0; 0];

extrapolate_c = 0 ; % initialisation
est_data_c = zeros(size(F_c,1), length(Time) - 1) ;

est_data_lost = [] ;
est_data_filter = state_vector_c ;
n_c = 1 ;

for k_c = 1:length(Time)
    if any(Time(k_c) == time_c_lost)
        % extrapolation
        %Time(k_c)
        extrapolate_c = 1 ;
        Tk_c = 0.2 ;
        [ F_c, Q_c ] = re_init_kf_c( coord_filter_type, Tk_c ) ;
        sigmaQ_kf_c = 10^(-8) ;
        Q_c = sigmaQ_kf_c .* Q_c ;
        P_c = P_c_interp ;
        [ P_c, state_vector_c, K_c ] = kalman_filter( 0, state_vector_c, F_c, 0, Q_c, 0, P_c, extrapolate_c, gain_type, GAIN, n_c ) ;
        est_data_lost = state_vector_c ;
        est_data_c(:, k_c) = state_vector_c ;
       
    elseif any(Time(k_c) == time_c_rx)
        % filtering
        extrapolate_c = 0 ;
        Tk_c = 1 ;
        [ F_c, Q_c ] = re_init_kf_c( coord_filter_type, Tk_c ) ;
        sigmaQ_kf_c = 10^(-8) ;
        Q_c = sigmaQ_kf_c .* Q_c ;
        %idx = find(Time==Time(k_c)) ;
        if isempty(est_data_lost)
            state_vector_c = est_data_filter ; % state vector from last filterting stage
        else
            state_vector_c = est_data_lost ;
            est_data_lost = [] ;
        end
        [ P_c, state_vector_c, K_c ] = kalman_filter( measuredCoordLCS(k_c,:)', state_vector_c, F_c, R_c, Q_c, H_c, P_c, extrapolate_c, gain_type, GAIN, n_c ) ;
%         [ P_c, state_vector_c, K_c ] = kalman_filter( measuredCoordLCS(idx_array(k_c),:)', state_vector_c, F_c, R_c, Q_c, H_c, P_c, extrapolate_c, gain_type, GAIN, n_c ) ;
        est_data_filter = state_vector_c ; % state vector after filtering
        est_data_c(:, k_c) = state_vector_c ;
        P_c_interp = P_c ;
    else
        % intrapolation
        extrapolate_c = 1 ;
        Tk_c = 0.2 ;
        [ F_c, Q_c ] = re_init_kf_c( coord_filter_type, Tk_c ) ;
        sigmaQ_kf_c = 10^(-8) ;
        Q_c = sigmaQ_kf_c .* Q_c ;
        [ P_c_interp, state_vector_c, ~ ] = kalman_filter( 0, state_vector_c, F_c, 0, Q_c, 0, P_c_interp, extrapolate_c, gain_type, GAIN, n_c ) ;
        est_data_c(:, k_c) = state_vector_c ;
    end
    
    %K_c_vec(:, k_c) = K_c ;
    n_c = n_c + 1 ;
end
D_est_c = sqrt(est_data_c(1,:).^2 + est_data_c(4,:).^2 + est_data_c(7,:).^2) ;

figure(); 
plot(Time(2:end), D_est_c - D_ideal(2:end)', 'r'); 
hold on
%plot(time_d_lost+0.2, est_data_interp_mark, 'sq', 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize', 5); 
grid on

% figure(); 
% plot(Time(2:end), est_data_d(2,:) - Vd_ideal(2:end)', 'r'); 
% grid on

