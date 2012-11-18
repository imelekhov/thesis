clear all
close all
clc

addpath('../MeasureRelativeCoordinates/mat-data', ...
'../MeasureDistances/mat-data',                   ...
'../Common/mat-data',                             ...
'../KalmanFiltering/tools',                       ...
'mat-data',                                       ...
'tools') ;

load common.mat
load measuredCoordLCS.mat
load coordLCSIdeal.mat
load D_Vd_data.mat
load ksi_arrays.mat

Time = timeStart:timeStep:timeEnd ;
time_d = timeStart:timeStep:timeEnd ;
time_c = timeStart:timeEnd ;

ksi_start = 5000 ;
[ksi_c_rx, ksi_c_lost, time_c_rx, time_c_lost] = ksi_analysis(ksi_c, ksi_start, time_c, P_satell) ;
[ksi_d_rx, ksi_d_lost, time_d_rx, time_d_lost] = ksi_analysis(ksi_d, ksi_start, time_d, P_d) ;

orange = [0.6 0.2 0] ;
visualize_ksi(ksi_c_rx, time_c_rx, ksi_c_lost, time_c_lost, orange, 'Coordinates data analysis') ;
visualize_ksi(ksi_d_rx, time_d_rx, ksi_d_lost, time_d_lost, orange, 'Distances data analysis') ;


ID = zeros(1, length(Time)) ;         % information sources flag ("0" - kf_d; "1" - kf_c)
ready_kf_d = zeros(1, length(Time)) ; % kf_d ready flag
ready_kf_c = zeros(1, length(Time)) ; % kf_c ready flag

Tk_d = 0.2 ;
[ F_d, Q_d, H_d, R_d, P_d ] = initialisationDistanceFilter( sigma_D, Tk_d ) ;
sigmaQ_kf_d = 10^(-4) ;
Q_d = sigmaQ_kf_d .* Q_d ;
state_vector_d = [D_noisy(1,1); 0; 0] ;
est_data_d = zeros(size(F_d,1), length(Time) - 1) ;
K_d_vec    = zeros(size(F_d,1), length(Time) - 1) ;
n_d = 1 ;

Tk_c = 1 ; % time interval between data receiving from Navigation Satellites 
coord_filter_type = 'common_accel' ;
% TODO: replace "magic" constants to variables
sigma_vec = [9 9 13 0.1 0.1 0.12] ;
[ F_c, Q_c, H_c, R_c, P_c ] = initialisationKalmanFilter(coord_filter_type, sigma_vec, Tk_c) ;
sigmaQ_kf_c = 10^(-8) ;
Q_c = sigmaQ_kf_c .* Q_c ;
state_vector_c = [measuredCoordLCS(1,1); measuredCoordLCS(1,4); 0; ...
                  measuredCoordLCS(1,2); measuredCoordLCS(1,5); 0; ...
                  measuredCoordLCS(1,3); measuredCoordLCS(1,6); 0] ;
est_data_c = zeros(size(F_c,1), length(Time) - 1) ;
K_c_vec    = zeros(size(F_c,1), length(Time) - 1) ;
n_c = 1 ;

for t = 1:length(Time) - 1
    % kf_d
    if any(Time(t+1) ~= time_d_lost) % check if at that time we've received a measurement
        ready_kf_d(t) = 1 ; % set ready flag for kf_d
        extrapolate_d = 0 ;
        [ P_d, state_vector_d, K_d ] = kalman_filter( D_noisy(t+1,1), state_vector_d, F_d, R_d, Q_d, H_d, P_d, extrapolate_d, n_d ) ;
        est_data_d(:, t) = state_vector_d ;
        K_d_vec(:, t)    = K_d ;
        n_d = n_d + 1 ;
    else
        extrapolate_d = 1 ;
        [ P_d, state_vector_d, K_d ] = kalman_filter( 0, state_vector_d, F_d, 0, Q_d, 0, P_d, extrapolate_d, n_d ) ;
        est_data_d(:, t) = state_vector_d ;
        K_d_vec(:, t)    = K_d ;
        n_d = n_d + 1 ;
    end
    
    % kf_c
    if any(Time(t+1) ~= time_c_rx)
        do_extrapolation_c = 1 ;
        Tk_c_interp = 0.2 ;
        [ F_c_interp, Q_c_interp] = re_init_kf_c( coord_filter_type, Tk_c_interp ) ;
        Q_c_interp = sigmaQ_kf_c .* Q_c_interp ;
        [ P_c_interp, state_vector_c, K_c ] = kalman_filter( 0, state_vector_c, F_c_interp, 0, Q_c_interp, 0, P_c_interp, do_extrapolation_c, n_c ) ;
        est_data_c(:, t) = state_vector_c ;
        n_c = n_c + 1 ;
    elseif any(Time(t+1) == time_c_lost)
        do_extrapolation_c = 1 ;
        Tk_c_interp = 0.2 ;
        [ F_c_interp, Q_c_interp] = re_init_kf_c( coord_filter_type, Tk_c_interp ) ;
        Q_c_interp = sigmaQ_kf_c .* Q_c_interp ;
        [ P_c_interp, state_vector_c, K_c ] = kalman_filter( 0, state_vector_c, F_c_interp, 0, Q_c_interp, 0, P_c_interp, do_extrapolation_c, n_c ) ;
        est_data_c(:, t) = state_vector_c ;
        n_c = n_c + 1 ;
    else % received mesurement
        ready_kf_c(t) = 1 ; % set ready flag for kf_c
        do_extrapolation_c = 0 ;
        [ F_c, Q_c] = re_init_kf_c( coord_filter_type, Tk_c ) ;
        Q_c = sigmaQ_kf_c .* Q_c;
        idx = find(Time == Time(t+1)) ;
        [ P_c, state_vector_c, K_c ] = kalman_filter( measuredCoordLCS(idx,:)', state_vector_c, F_c, R_c, Q_c, H_c, P_c, do_extrapolation_c, n_c ) ;
        est_data_c(:, t+Tk_c/Tk_c_interp) = state_vector_c ;
        n_c = n_c + 1 ;
    end
    
    
    


    
    
end




