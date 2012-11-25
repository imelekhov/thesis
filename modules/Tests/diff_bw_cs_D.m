clear all
%close all
%clc

addpath('../CalculateAbsoluteCoordinates/tools/');

num_of_aircrafts = 2 ;
% phi_start    = [0.005 ; 0] ; % degrees
% lambda_start = [0 ; 0.002] ; % degrees
% phi_start    = [0.005 ; 0] ; % degrees
% lambda_start = [0 ; -0.002] ; % degrees
type_position = 'equator' ;

phi_start    = [60.005 ; 60] ; % degrees
%lambda_start = [30 ; 30.002] ; % degrees
lambda_start = [30 ; 29.998] ; % degrees when heading is 90
type_position = 'not equator' ;

h_start      = [2e4; 2e4] ;  % m

phi_lambda_rad = deg2rad([phi_start; lambda_start]) ;
init_coord = [h_start phi_lambda_rad(1:2) phi_lambda_rad(3:4)] ; % h phi lambda

ellipsoid = referenceEllipsoid('krasovsky') ;

[x_0_1, y_0_1, z_0_1] = geodetic2ecef(phi_lambda_rad(1), phi_lambda_rad(3), h_start(1), ellipsoid) ;
[x_0_2, y_0_2, z_0_2] = geodetic2ecef(phi_lambda_rad(2), phi_lambda_rad(4), h_start(2), ellipsoid) ;

time_start = 0 ;
dt         = 1 ;
time_end   = 150 ;
time       = time_start:dt:time_end ;

V_1 = 250 ;
V_2 = 260 ;
%V_hrz_res = sqrt(V_array(:,1).^2 + V_array(:,2).^2) ;
V_hrz_res_array = [repmat(V_1, 1, size(time,2)) ; repmat(V_2, 1, size(time,2)) ] ;
Vh = 0 ;
psi_deg_vec = [90; 90] ; % degrees
psi_rad_vec = deg2rad(psi_deg_vec) ; % radians

geo_coord_by_ode = zeros(size(time,2), size(psi_deg_vec,1) * 3) ;
n = 1 ;
for k = 1:num_of_aircrafts
    [~, output] = ode45(@(t,y) rigid(t, y, psi_rad_vec(k), Vh, V_hrz_res_array(k,:), time), time, init_coord(k,:)) ;
    geo_coord_by_ode(:, n:3*k) = output ;
    n = n + 3 ;
end

[x_ecef_1, y_ecef_1, z_ecef_1] = geodetic2ecef(geo_coord_by_ode(:,2), geo_coord_by_ode(:,3), geo_coord_by_ode(:,1), ellipsoid) ; % phi lambda h
[x_ecef_2, y_ecef_2, z_ecef_2] = geodetic2ecef(geo_coord_by_ode(:,5), geo_coord_by_ode(:,6), geo_coord_by_ode(:,4), ellipsoid) ; % phi lambda h

ecef_ref = [x_ecef_1 y_ecef_1 z_ecef_1] ;
ecef_ac  = [x_ecef_2 y_ecef_2 z_ecef_2] ;
phi = zeros(2, size(ecef_ref,1)) ;
for k = 1:size(ecef_ref, 1)
    [ phi_rad, phi_deg ] = azimuth( ecef_ref(k,:), ecef_ac(k,:), ellipsoid, type_position ) ;
    phi(1,k) = phi_rad ;
    phi(2,k) = phi_deg ;
end

if psi_deg_vec(1) ~= psi_deg_vec(2)
    disp('Headings have to be equal')
    break ;
end

switch psi_deg_vec(1)
    case 0
        x_ecef_plain_1 = repmat(x_0_1, 1, size(time,2)) ; 
        x_ecef_plain_2 = repmat(x_0_2, 1, size(time,2)) ; 
        y_ecef_plain_1 = repmat(y_0_1, 1, size(time,2)) ; 
        y_ecef_plain_2 = repmat(y_0_2, 1, size(time,2)) ; 
        z_ecef_plain_1 = z_0_1 + V_1 .* time ; 
        z_ecef_plain_2 = z_0_2 + V_2 .* time ; 
    case 45
        x_ecef_plain_1 = repmat(x_0_1, 1, size(time,2)) ; 
        x_ecef_plain_2 = repmat(x_0_2, 1, size(time,2)) ; 
        y_ecef_plain_1 = y_0_1 + V_1 / sqrt(2) .* time ; 
        y_ecef_plain_2 = y_0_2 + V_2 / sqrt(2) .* time ;  
        z_ecef_plain_1 = z_0_1 + V_1 / sqrt(2) .* time ; 
        z_ecef_plain_2 = z_0_2 + V_2 / sqrt(2) .* time ; 
    case 90
        x_ecef_plain_1 = repmat(x_0_1, 1, size(time,2)) ; 
        x_ecef_plain_2 = repmat(x_0_2, 1, size(time,2)) ; 
        y_ecef_plain_1 = y_0_1 + V_1 .* time ; 
        y_ecef_plain_2 = y_0_2 + V_2 .* time ;  
        z_ecef_plain_1 = repmat(z_0_1, 1, size(time,2)) ; 
        z_ecef_plain_2 = repmat(z_0_2, 1, size(time,2)) ; 
end
       

% psi = 0
% x_ecef_plain_1 = repmat(x_0_1, 1, size(time,2)) ; 
% x_ecef_plain_2 = repmat(x_0_2, 1, size(time,2)) ; 
% y_ecef_plain_1 = repmat(y_0_1, 1, size(time,2)) ; 
% y_ecef_plain_2 = repmat(y_0_2, 1, size(time,2)) ; 
% z_ecef_plain_1 = z_0_1 + V_1 .* time ; 
% z_ecef_plain_2 = z_0_2 + V_2 .* time ; 
% 
% % psi = 90
% x_ecef_plain_1 = repmat(x_0_1, 1, size(time,2)) ; 
% x_ecef_plain_2 = repmat(x_0_2, 1, size(time,2)) ; 
% % y_ecef_plain_1 = y_0_1 - V_1 .* time ; 
% % y_ecef_plain_2 = y_0_2 - V_2 .* time ;  
% y_ecef_plain_1 = y_0_1 + V_1 .* time ; 
% y_ecef_plain_2 = y_0_2 + V_2 .* time ;  
% z_ecef_plain_1 = repmat(z_0_1, 1, size(time,2)) ; 
% z_ecef_plain_2 = repmat(z_0_2, 1, size(time,2)) ; 

% psi = 45
% x_ecef_plain_1 = repmat(x_0_1, 1, size(time,2)) ; 
% x_ecef_plain_2 = repmat(x_0_2, 1, size(time,2)) ; 
% % y_ecef_plain_1 = y_0_1 - V_1 / sqrt(2) .* time ; 
% % y_ecef_plain_2 = y_0_2 - V_2 / sqrt(2) .* time ;  
% y_ecef_plain_1 = y_0_1 + V_1 / sqrt(2) .* time ; 
% y_ecef_plain_2 = y_0_2 + V_2 / sqrt(2) .* time ;  
% z_ecef_plain_1 = z_0_1 + V_1 / sqrt(2) .* time ; 
% z_ecef_plain_2 = z_0_2 + V_2 / sqrt(2) .* time ; 

D_ode   = sqrt((x_ecef_1 - x_ecef_2).^2 + (y_ecef_1 - y_ecef_2).^2 + (z_ecef_1 - z_ecef_2).^2) ;
D_plain = sqrt((x_ecef_plain_1 - x_ecef_plain_2).^2 + (y_ecef_plain_1 - y_ecef_plain_2).^2 + (z_ecef_plain_1 - z_ecef_plain_2).^2) ;


figure()
plot(time, abs(D_ode - D_plain'), 'r', 'LineWidth', 2) ;
grid on
xlabel('t, s') ;
ylabel('D, m') ;
title({['Comparison between two ways of obtaining ECEF coordinates.'], ...
      ['First AC starting point: lat = ', num2str(phi_start(1)),', lon = ', num2str(lambda_start(1))], ...
      ['V1 = ', num2str(V_1), ' m/s; V2 = ', num2str(V_2), ' m/s'], ...
      ['\Psi = ', num2str(psi_deg_vec(1))]}) ;

figure()
plot(time, phi(2,:), 'LineWidth', 2) ;
grid on
xlabel('t, s') ;
ylabel('\Psi, \circ') ;
title({['Azimuth.'], ...
      ['First AC starting point: lat = ', num2str(phi_start(1)),', lon = ', num2str(lambda_start(1))], ...
      ['V1 = ', num2str(V_1), ' m/s; V2 = ', num2str(V_2), ' m/s'], ...
      ['\Psi = ', num2str(psi_deg_vec(1))]}) ;
