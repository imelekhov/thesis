function [ V_res ] = standard_turn_m(Vx0, Vy0, Psi_in, omega, R_turn, time)

delta_t = time(end) - time(end - 1) ;

% aircraft
x_ac = 0 ;
y_ac = 0 ;

x_circle = zeros(1, length(time) + 1) ;
y_circle = R_turn .* ones(1, length(time) + 1) ;

Vx_1 = [Vx0(1) zeros(1, length(time) - 1)] ;
Vy_1 = [Vy0(1) zeros(1, length(time) - 1)] ;
V_res = zeros(1, length(time)) ;
Psi_out = [Psi_in zeros(1, length(time) - 1)] ;

alpha = zeros(2,1) ;

for k = 1 : length(time)
    
    V = sqrt(Vx_1(k)^2 + Vy_1(k)^2) ;
    phi = atan2((x_ac - x_circle(k)), (y_ac - y_circle(k))) ;
    
    x = x_circle(k) + R_turn * sin(omega * delta_t + phi) ;
    y = y_circle(k) + R_turn * cos(omega * delta_t + phi) ;
    
    Vxx = V * sign(omega) * cos(omega * delta_t + phi) ;
    Vyy = -V * sign(omega) * sin(omega * delta_t + phi) ;
    
    Vx_1(k+1) = Vxx ;
    Vy_1(k+1) = Vyy ;
    V_res(k) = V ;
    
    Psi_out(k + 1) = Psi_out(k) + omega * delta_t ;
    
    x_circle(k + 1) = x_circle(k) + Vx0(2) * cos(alpha(1)) * delta_t ;
    
    %alpha
    Vec(:,:,1) = [0 Vx_1(k); 0 Vy_1(k)];
    Vec(:,:,2) = [x x+Vxx; y y+Vyy];
    [ alpha ] = angle_between_vectors_points(Vec) ;
end