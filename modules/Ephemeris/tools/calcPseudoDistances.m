function [ output ] = calcPseudoDistances( satellitesTrajectory, coordECEF )
%CALCPSEUDODISTANCES Summary of this function goes here
%   Detailed explanation goes here

% satellitesTrajectory is 3d matrix: 901x6x4. The 3rd dimension is an satellites number
% 2nd dimension: [X Y Z Vx Vy Vz]
% coordECEF is 3d matrix: 901x3x2. The 3rd dimension is an aircrafts number

output = zeros(size(satellitesTrajectory,1), size(satellitesTrajectory,3), size(coordECEF,3));
for k = 1:size(coordECEF, 3)
    
    
    Dik1_1 = sqrt((satellitesTrajectory(:,1,1) - coordECEF(:,1,k)).^2 + (satellitesTrajectory(:,2,1) - coordECEF(:,2,k)).^2 + (satellitesTrajectory(:,3,1) - coordECEF(:,3,k)).^2);
    Dik1_2 = sqrt((satellitesTrajectory(:,1,2) - coordECEF(:,1,k)).^2 + (satellitesTrajectory(:,2,2) - coordECEF(:,2,k)).^2 + (satellitesTrajectory(:,3,2) - coordECEF(:,3,k)).^2);
    Dik1_3 = sqrt((satellitesTrajectory(:,1,3) - coordECEF(:,1,k)).^2 + (satellitesTrajectory(:,2,3) - coordECEF(:,2,k)).^2 + (satellitesTrajectory(:,3,3) - coordECEF(:,3,k)).^2);
    Dik1_4 = sqrt((satellitesTrajectory(:,1,4) - coordECEF(:,1,k)).^2 + (satellitesTrajectory(:,2,4) - coordECEF(:,2,k)).^2 + (satellitesTrajectory(:,3,4) - coordECEF(:,3,k)).^2);
    
    output(:,:,k) = [Dik1_1 Dik1_2 Dik1_3 Dik1_4];
    
end


end

