function [ V_res ] = standard_turn(Vx0, Vy0, omega, R_turn, time)

%% definitions :
% inputs :
% Vx -
% Vy -
% omega -
% R_turn -
% outputs :
% V -

%%
delta_t = time(end) - time(end - 1) ;

% aircraft
x_ac = 0 ;
y_ac = 0 ;

x_circle = zeros(1, length(time) + 1) ;
y_circle = R_turn .* ones(1, length(time) + 1) ;

Vx_1 = [Vx0(1) zeros(1, length(time) - 1)] ;
Vy_1 = [Vy0(1) zeros(1, length(time) - 1)] ;
V_res = zeros(1, length(time)) ;

angles = zeros(2, length(time)) ;
theta_container = zeros(2, length(time)) ;

alpha = 0 ;

q1_theta = [Vx0(1) Vy0(1)] / norm([Vx0(1) Vy0(1)]);

for k = 1 : length(time)
    
    if (imag(x_circle(k)) ~= 0 || imag(y_circle(k)) ~= 0)
        x_circle(k)
        y_circle(k)
    end
    %V = sqrt(Vx_1(end)^2 + Vy_1(end)^2) ;
    V = sqrt(Vx_1(k)^2 + Vy_1(k)^2) ;
    phi = atan2((x_ac - x_circle(k)), (y_ac - y_circle(k))) ;
    
    t0 = time(k) ;
    dt = 0.1 ;
    t1 = time(k) + 1 ;
    t = t0 + dt : dt : t1;
    
    x = x_circle(k) + R_turn * sin(omega * (t - t0) + phi) ;
    y = y_circle(k) + R_turn * cos(omega * (t - t0) + phi) ;
    Vxx_1 = V * sign(omega) * cos(omega * (t - t0) + phi) ;
    Vyy_1 = -V * sign(omega) * sin(omega * (t - t0) + phi) ;
    %Vxx_1 = -V * sign(omega) * sin(omega * (t - t0) + phi) ;
    %Vyy_1 = V * sign(omega) *  cos(omega * (t - t0) + phi) ;
        
    Vx_1(k+1) = Vxx_1(end) ;
    Vy_1(k+1) = Vyy_1(end) ;
    V_res(k) = V ;
    
    Vx_1_angle = Vx_1(k) ;
    Vx_2_angle = Vx_1(k+1) ;
    Vy_1_angle = Vy_1(k) ;
    Vy_2_angle = Vy_1(k+1) ;
    
    x_circle(k + 1) = x_circle(k) + Vx0(2) * cos(alpha) * delta_t ;
    
    %% alpha angle
    q1 = [Vx_1_angle Vy_1_angle] / V ; % ???????????? ?????? ???????? ?????
    q2 = [Vx_2_angle Vy_2_angle] / norm([Vx_2_angle Vy_2_angle]) ; % ???????????? ?????? ??????? ?????
    alpha = acos(q1 * q2') ;
    if (imag(alpha) ~= 0)
        alpha = 0 ;
    end
    %if (det([[q1,0];[q2,0];[0,0,1]]) > 0)&&(omega < 0)
    if (det([[q1,0];[q2,0];[0,0,1]]) < 0)&&(omega < 0)
        alpha = 2 * pi - alpha; % rotation angle
    end
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
    if (imag(theta) ~= 0)
        theta = 0 ;
    end
%     if (det([[q1_theta,0];[q2_theta,0];[0,0,1]]) > 0)&&(omega < 0)
%         theta = 2 * pi - theta; % rotation angle
%     end
    theta_container(1, k) = theta ;
    theta_container(2, k) = theta * 180 / pi ;
end

V_res = V_res .* cos(theta_container(1,:)) ;

end