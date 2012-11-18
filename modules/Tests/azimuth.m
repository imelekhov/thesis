function [ phi_rad, phi_deg ] = azimuth( ecef_ref, ecef_ac, ellipsoid )
%AZIMUTH Summary of this function goes here
%   Detailed explanation goes here

a = ellipsoid.SemimajorAxis ;
b = ellipsoid.SemiminorAxis ;

n_r = [ecef_ref(:,1) ./ a^2 ecef_ref(:,2) ./ a^2 ecef_ref(:,3) ./ b^2] ;

q = [-ecef_ref(:,1) -ecef_ref(:,2) (b^2 ./ ecef_ref(:,3)) - ecef_ref(:,3)] ;
norm_q = sqrt(q(:,1) .^ 2 + q(:,2) .^ 2 + q(:,3) .^ 2) ;
q_0 = [q(:,1) ./ norm_q q(:,2) ./ norm_q q(:,3) ./ norm_q] ;

p = [ecef_ac(:,1) - ecef_ref(:,1) ecef_ac(:,2) - ecef_ref(:,2) ecef_ac(:,3) - ecef_ref(:,3)] ;

dim = 2 ;
s = cross(p, n_r, dim) ;
g = cross(s, n_r, dim) ;

norm_g = sqrt(g(:,1) .^ 2 + g(:,2) .^ 2 + g(:,3) .^ 2) ;

phi_rad = acos(q_0 * g' / norm_g) ;
phi_deg = phi_rad * 180 / pi ;

end

