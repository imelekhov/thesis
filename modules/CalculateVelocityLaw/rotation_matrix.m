function [ M ] = rotation_matrix( Theta )
%ROTATION_MATRIX Summary of this function goes here
%   Detailed explanation goes here

% Theta - angle between two vectors [rad]

M = [cos(Theta) -sin(Theta);
     sin(Theta)  cos(Theta)] ;


end

