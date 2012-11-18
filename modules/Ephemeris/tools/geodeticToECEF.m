function [ output ] = geodeticToECEF( coordinatesGeodetic )
%GEODETICTOECEF Summary of this function goes here
%   Detailed explanation goes here

% coordinatesGeodetic is a matrix [size(t) x 6]; => [H phi lambda Vnorth Veast Vvert]




a = 6378245;
e_sq = 0.0066934;

hIndx = [1,7];
phiIndx = [2,8];

for k = 1:size(coordinatesGeodetic, 2) / 6

    H = coordinatesGeodetic(:,hIndx(k));
    R = a * sqrt(1 - e_sq) ./ sqrt(1 - e_sq .* cos(coordinatesGeodetic(:,phiIndx(k))) .^ 2) + H;
    X = (R + H) .* cos(coordinatesGeodetic(:,phiIndx(k))) .* cos(coordinatesGeodetic(:,phiIndx(k)));
    Y = (R + H) .* cos(coordinatesGeodetic(:,phiIndx(k))) .* sin(coordinatesGeodetic(:,phiIndx(k)));
    Z = (R + H) .* sin(coordinatesGeodetic(:,phiIndx(k)));
    
    output(:,:,k) = [X Y Z];

end


%output = [X Y Z];





end

