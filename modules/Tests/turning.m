clc
clear all
close all

time = 0:200 ;
delta_t = time(end) - time(end - 1) ;
Vx_1 = 250 ; % m/s
Vx_2 = 20 ; % m/s
Vy_1 = 0 ;
Vy_2 = 0 ;

omega_1 = -0.16; % 1/s
R_turn = 1500 ; % m

% aircraft
x_ac = 0 ;
y_ac = 0 ;

% circle
%x_circle_0 = 0 ;
x_circle = zeros(1, length(time) + 1) ;
%y_circle_0 = 1500 ;
y_circle = R_turn .* ones(1, length(time) + 1) ;

x_traj = [] ;
y_traj = [] ;
Vxx_traj = [] ;
Vyy_traj = [] ;
V_traj = [] ;

x_traj_2 = [] ;
y_traj_2 = [] ;

angles = zeros(2, length(time)) ;
theta_container = zeros(2, length(time)) ;

alpha = 0 ;

theta = 0 ;
q1_theta = [Vx_1 Vy_1] / norm([Vx_1 Vy_1]);

for k = 1 : length(time)
    
    %x_circle =  x_circle_0 + Vx_2 * time(k) ;
    %x_circle(k + 1) = x_circle(k) + Vx_2 * delta_t ;
    %y_cirlce =  y_circle_0 ;
        
    %V = sqrt(Vx_1(end)^2 + Vy_1(end)^2) ;
    V = sqrt(Vx_1(end)^2 + Vy_1(end)^2) ;
    
    %phi = atan2((y_ac(end) - y_cirlce), (x_ac(end) - x_circle)) ;
    %phi = atan2((x_ac(end) - x_circle), (y_ac(end) - y_cirlce)) ;
    phi = atan2((0 - x_circle(k)), (0 - y_circle(k))) ;
    
    t0 = time(k) ;
    dt = 0.1 ;
    t1 = time(k) + 1 ;
    t = t0 + dt : dt : t1;
    %x = x_circle + R_turn * cos(omega_1 * (t - t0) + phi) ;
    %x = x_circle + R_turn * sin(omega_1 * (t - t0) + phi) ;
    x = x_circle(k) + R_turn * sin(omega_1 * (t - t0) + phi) ;
    %y = y_cirlce + R_turn * sin(omega_1 * (t - t0) + phi) ;
    %y = y_cirlce + R_turn * cos(omega_1 * (t - t0) + phi) ;
    y = y_circle(k) + R_turn * cos(omega_1 * (t - t0) + phi) ;
    %Vxx_1 = -V * sign(omega_1) * sin(omega_1 * (t - t0) + phi) ;
    Vxx_1 = V * sign(omega_1) * cos(omega_1 * (t - t0) + phi) ;
    %Vyy_1 = V * sign(omega_1) * cos(omega_1 * (t - t0) + phi) ;
    Vyy_1 = -V * sign(omega_1) * sin(omega_1 * (t - t0) + phi) ;
    
    Vx_1_angle = Vx_1(end) ;
    Vy_1_angle = Vy_1(end) ;
        
    x_ac = [x_ac x(end)] ;
    y_ac = [y_ac y(end)] ;
    
    x_traj = [x_traj x] ;
    y_traj = [y_traj y] ;
    Vx_1 = [Vx_1 Vxx_1] ;
    Vy_1 = [Vy_1 Vyy_1] ;
    V_traj = [V_traj V] ;
    
    x_traj_2 = [x_traj_2 x_circle] ;
    y_traj_2 = [y_traj_2 y_circle] ;
    
    Vx_2_angle = Vx_1(end) ;
    Vy_2_angle = Vy_1(end) ;
    
    x_circle(k + 1) = x_circle(k) + Vx_2 * cos(alpha) * delta_t ;
    
    %% alpha angle
    q1 = [Vx_1_angle Vy_1_angle] / V ;
    q2 = [Vx_2_angle Vy_2_angle] / norm([Vx_2_angle Vy_2_angle]) ;
    alpha = acos(q1 * q2') ;
%     if (det([[q1,0];[q2,0];[0,0,1]]) > 0)&&(omega_1 < 0)
%         alpha = 2 * pi - alpha; % rotation angle
%     end
    angles(1, k) = alpha ; % radians
    angles(2, k) = alpha * 180 / pi ; % degrees
    %% 
    M = rotation_matrix(alpha) ;
    turned_point = [x_circle(k+1) y_circle(k+1)] * M ;
    x_circle(k+1) = turned_point(1) ;
    y_circle(k+1) = turned_point(2) ;
    
    %% theta angle (between 1st and current position)
    q2_theta = q2 ;
    theta = acos(q1_theta * q2_theta') ;
    %     if (det([[q1_theta,0];[q2_theta,0];[0,0,1]]) > 0)&&(omega_1 < 0)
    %         theta = 2 * pi - theta; % rotation angle
    %     end
    theta_container(1, k) = theta ;
    theta_container(2, k) = theta * 180 / pi ;
end

figure()
plot(y_traj_2, x_traj_2, '.') ;
hold on
plot(y_traj, x_traj, 'r') ;
grid on










%%
% Psi_1 = 30 ; % degrees
% Psi_2 = 30 ;
% 
% Vx_1 = 250 ; % m/s
% Vx_2 = 255 ; % m/s
% Vy_1 = 0 ;
% Vy_2 = 0 ;
% 
% omega_1 = 0.16 ; % 1/s
% %omega_1 = 1.6 ; % 1/s
% 
% R_turn = 1500 ; % m
% 
% %x_circle = -Vy_1 / omega_1 ;
% x_circle = 0 ;
% %y_cirlce =  Vx_1 / omega_1 ;
% y_cirlce =  1500 ;
% 
% V = sqrt(Vx_1^2 + Vy_1^2) ;
% 
% phi = atan2((-y_cirlce),(-x_circle)) ;
% %phi = atan2((x_circle),(y_cirlce)) ;
% %phi = atan2((x_circle),(y_cirlce)) ;
% 
% t0 = 0 ;
% dt = 0.1 ;
% t1 = 1 ;
% t = t0 + dt : dt : t1;
% x = x_circle + R_turn * cos(omega_1 * (t - t0) + phi) ;
% y = y_cirlce + R_turn * sin(omega_1 * (t - t0) + phi) ;
% Vxx_1 = -V * sign(omega_1) * sin(omega_1 * (t - t0) + phi) ;
% Vyy_1 = V * sign(omega_1) * cos(omega_1 * (t - t0) + phi) ;


%%
% V_back = [Vx_1 Vy_1] / V ;
% V_crnt = [Vxx_1 Vyy_1] / norm([Vxx_1 Vyy_1]) ;
% rotation_angle = acos(V_back * V_crnt') ; % radians
% 
% M = rotation_matrix( rotation_angle ) ;
