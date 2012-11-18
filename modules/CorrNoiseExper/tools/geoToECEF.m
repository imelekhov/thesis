function [ output ] = geoToECEF( input )

%GEOTOECEF Summary of this function goes here
%   Detailed explanation goes here

% input - is a matrix N x 3: [H phi lambda]

% WGS84
e_sq = 6.69437999014e-3;
a = 6378137; % m

N = a ./ sqrt(1 - e_sq .* sin(input(:,2)).^2);

X = (N + input(:,1)) .* cos(input(:,1)) .* cos(input(:,3));
Y = (N + input(:,1)) .* cos(input(:,1)) .* sin(input(:,3));
Z = (N .* (1 - e_sq) + input(:,1)) .* sin(input(:,3));

output = [X Y Z];

end

