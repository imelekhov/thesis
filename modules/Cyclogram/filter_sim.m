clear all
%close all
clc

addpath('../MeasureRelativeCoordinates/mat-data', ...
'../MeasureDistances/mat-data',               ...
'../Common/mat-data',                         ...
'../KalmanFiltering/tools',                   ...
'tools') ;

load common.mat
load measuredCoordLCS.mat
load coordLCSIdeal.mat
load D_Vd_data.mat

Time = timeStart:timeStep:timeEnd ;

Tk_d = 0.2 ;

[ F_d, Q_d, H_d, R_d, P_d ] = initialisationDistanceFilter( sigma_D, Tk_d ) ;
sigmaQ_kf_d = 10^(-4) ;
Q_d = sigmaQ_kf_d .* Q_d ;

nn = 0 ;

state_vector_d = [D_noisy(1,1); 0; 0] ;

extrapolate_d = 0 ; % always

est_data_d = zeros(size(F_d,1), length(Time) - 1) ;
K_d_vec = zeros(size(F_d,1), length(Time) - 1) ;

n_d = 1 ;

for k_d = 1:length(Time) - 1
    [ P_d, state_vector_d, K_d ] = kalman_filter( D_noisy(k_d+1,1), state_vector_d, F_d, R_d, Q_d, H_d, P_d, extrapolate_d, n_d ) ;
    est_data_d(:, k_d) = state_vector_d ;
    K_d_vec(:, k_d) = K_d ;
    n_d = n_d + 1 ;
end

coord_filter_type = 'common_accel' ;
% TODO: replace "magic" constants to variables
sigma_vec = [9 9 13 0.1 0.1 0.12] ;

%% TEST (kf_c every 0.2)
% Tk_c = 0.2 ; time interval between data receiving from Navigation Satellites 
% [ F_c, Q_c, H_c, R_c, P_c ] = initialisationKalmanFilter(coord_filter_type, sigma_vec, Tk_c) ;
% sigmaQ_kf_c = 10^(-8) ;
% Q_c = sigmaQ_kf_c .* Q_c ;
% 
% state_vector_c = [measuredCoordLCS(1,1); measuredCoordLCS(1,4); 0; ...
%    measuredCoordLCS(1,2); measuredCoordLCS(1,5); 0;    ...
%    measuredCoordLCS(1,3); measuredCoordLCS(1,6); 0];

% extrapolate_c = 0 ; % initialisation
% est_data_c = zeros(size(F_c,1), length(Time) - 1) ;
% 
% n_c = 1 ;
% 
% for k_c = 1:length(Time) - 1
%     extrapolate_c = 0 ;
%     [ P_c, state_vector_c, K_c ] = kalman_filter( measuredCoordLCS(k_c+1,:)', state_vector_c, F_c, R_c, Q_c, H_c, P_c, extrapolate_c, n_c ) ;
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

state_vector_c = [measuredCoordLCS(1,1); measuredCoordLCS(1,4); 0; ...
   measuredCoordLCS(1,2); measuredCoordLCS(1,5); 0;    ...
   measuredCoordLCS(1,3); measuredCoordLCS(1,6); 0];

state_vector_c_interp = state_vector_c ;
P_c_interp = P_c ;

n_c = 1 ;
est_data_c_i = zeros(size(F_c,1), length(Time) - 1) ;
for k_c_slot_1 = 1:Tk_c/Tk_d - 1
    do_extrapolation_c = 1 ;
    Tk_c_interp = 0.2 ;
    [ F_c_interp, Q_c_interp] = re_init_kf_c( coord_filter_type, Tk_c_interp ) ;
    Q_c_interp = sigmaQ_kf_c .* Q_c_interp ;
    [ P_c_interp, state_vector_c_interp, K_c ] = kalman_filter( 0, state_vector_c_interp, F_c_interp, 0, Q_c_interp, 0, P_c_interp, do_extrapolation_c, n_c ) ;
    est_data_c_i(:, k_c_slot_1) = state_vector_c_interp ;
    n_c = n_c + 1 ;
end

n_c = 1 ;
for k_c_cmn = 1:Tk_c/Tk_d:length(Time)-1
    do_extrapolation_c = 0 ;
    [ F_c, Q_c] = re_init_kf_c( coord_filter_type, Tk_c ) ;
    Q_c = sigmaQ_kf_c .* Q_c;
    [ P_c, state_vector_c, K_c ] = kalman_filter( measuredCoordLCS(k_c_cmn + Tk_c/Tk_d,:)', state_vector_c, F_c, R_c, Q_c, H_c, P_c, do_extrapolation_c, n_c ) ;
    est_data_c_i(:, k_c_cmn+k_c_slot_1) = state_vector_c ;
    n_c = n_c + 1 ;
    
    state_vector_c_interp = state_vector_c ;
    P_c_interp = P_c ;
    for k_c_interp = 1:Tk_c/Tk_d - 1
        do_extrapolation_c = 1 ;
        Tk_c_interp = 0.2 ;
        [ F_c_interp, Q_c_interp] = re_init_kf_c( coord_filter_type, Tk_c_interp ) ;
        Q_c_interp = sigmaQ_kf_c .* Q_c_interp ;
        [ P_c_interp, state_vector_c_interp, K_c ] = kalman_filter( 0, state_vector_c_interp, F_c_interp, 0, Q_c_interp, 0, P_c_interp, do_extrapolation_c, n_c ) ;
        est_data_c_i(:, k_c_cmn+k_c_slot_1+k_c_interp) = state_vector_c_interp ;
        n_c = n_c + 1 ;
    end

end
D_est_c_i = sqrt(est_data_c_i(1,1:end-4).^2 + est_data_c_i(4,1:end-4).^2 + est_data_c_i(7,1:end-4).^2) ;
Vd_from_c_i = (est_data_c_i(1,1:end-4) .* est_data_c_i(2,1:end-4) + est_data_c_i(4,1:end-4) .* est_data_c_i(5,1:end-4) + est_data_c_i(7,1:end-4) .* est_data_c_i(8,1:end-4)) ./ D_est_c_i ;

green = [0.17 0.51 0.34] ; % green color
orange = [0.87 0.49 0] ;   % orange color
figure() ;
subplot(2,1,1)
plot(Time(2:end), D_ideal(2:end) - D_est_c_i(1,:)', 'r') ; 
hold on ; 
plot(Time(2:end), D_ideal(2:end) - est_data_d(1,:)', 'Color', green) ;
grid on ;
title({'Comparison between filters (distance and coordinates):'; '\bf{Radial distance} estimation'})
legend('CKF', 'DKF')
xlabel('t, s')
ylabel('D, m')
subplot(2,1,2)
plot(Time(2:end), D_ideal(2:end), 'k') ;
grid on
title('Modelled distances')
xlabel('t, s')
ylabel('D, m')

figure() ;
subplot(2,1,1)
plot(Time(2:end), Vd_ideal(2:end) - Vd_from_c_i', 'r') ; 
hold on ; 
plot(Time(2:end), Vd_ideal(2:end) - est_data_d(2,:)', 'Color', green) ;
grid on ;
title({'Comparison between filters (distance and coordinates):'; '\bf{Radial velocity} estimation'})
legend('CKF', 'DKF')
xlabel('t, s')
ylabel('Vd, m/s')
subplot(2,1,2)
plot(Time(2:end), Vd_ideal(2:end), 'k') ;
grid on
title('Modelled radial velocity')
xlabel('t, s')
ylabel('Vd, m/s')

