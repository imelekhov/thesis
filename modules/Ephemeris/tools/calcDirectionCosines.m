function [ output ] = calcDirectionCosines( satellitesTrajectory, pseudoDistances, coordECEF )
%CALCDIRECTIONCOSINES Summary of this function goes here
%   Detailed explanation goes here

% for k = 1:size(coordECEF,2)
%     for m = 1:size(satellitesTrajectory,3)
%         
%         H1 = (satellitesTrajectory(:,1,m) - coordECEF(:,1,k)) ./ pseudoDistances(:,m,k);
%         H2 = (satellitesTrajectory(:,2,m) - coordECEF(:,2,k)) ./ pseudoDistances(:,m,k);
%         H3 = (satellitesTrajectory(:,3,m) - coordECEF(:,3,k)) ./ pseudoDistances(:,m,k);
%         
%         matrixH(m,:,:) = [H1 H2 H3];
% 
%     end
% end

output = zeros(size(satellitesTrajectory,3), size(coordECEF,2),  size(coordECEF,1), size(coordECEF,3));
for k = 1:size(coordECEF,3) 
    
    H11 = (satellitesTrajectory(:,1,1) - coordECEF(:,1,k)) ./ pseudoDistances(:,1,k);
    tmpH(1,1,:) = H11;
    H12 = (satellitesTrajectory(:,2,1) - coordECEF(:,2,k)) ./ pseudoDistances(:,1,k);
    tmpH(1,2,:) = H12;
    H13 = (satellitesTrajectory(:,3,1) - coordECEF(:,3,k)) ./ pseudoDistances(:,1,k);
    tmpH(1,3,:) = H13;
    
    H21 = (satellitesTrajectory(:,1,2) - coordECEF(:,1,k)) ./ pseudoDistances(:,2,k);
    tmpH(2,1,:) = H21;
    H22 = (satellitesTrajectory(:,2,2) - coordECEF(:,2,k)) ./ pseudoDistances(:,2,k);
    tmpH(2,2,:) = H22;
    H23 = (satellitesTrajectory(:,3,2) - coordECEF(:,3,k)) ./ pseudoDistances(:,2,k);
    tmpH(2,3,:) = H23;
    
    H31 = (satellitesTrajectory(:,1,3) - coordECEF(:,1,k)) ./ pseudoDistances(:,3,k);
    tmpH(3,1,:) = H31;
    H32 = (satellitesTrajectory(:,2,3) - coordECEF(:,2,k)) ./ pseudoDistances(:,3,k);
    tmpH(3,2,:) = H32;
    H33 = (satellitesTrajectory(:,3,3) - coordECEF(:,3,k)) ./ pseudoDistances(:,3,k);
    tmpH(3,3,:) = H33;
    
    H41 = (satellitesTrajectory(:,1,4) - coordECEF(:,1,k)) ./ pseudoDistances(:,4,k);
    tmpH(4,1,:) = H41;
    H42 = (satellitesTrajectory(:,2,4) - coordECEF(:,2,k)) ./ pseudoDistances(:,4,k);
    tmpH(4,2,:) = H42;
    H43 = (satellitesTrajectory(:,3,4) - coordECEF(:,3,k)) ./ pseudoDistances(:,4,k);
    tmpH(4,3,:) = H43;
    
    output(:,:,:,k) = tmpH;

end


% H11 = (satellitesTrajectory(:,1) - coordECEF(:,1)) ./ pseudoDistances(:,1);
% H12 = (satellitesTrajectory(:,2) - coordECEF(:,2)) ./ pseudoDistances(:,1);
% H13 = (satellitesTrajectory(:,3) - coordECEF(:,3)) ./ pseudoDistances(:,1);
% H21 = (satellitesTrajectory(:,7) - coordECEF(:,1)) ./ pseudoDistances(:,2);
% H22 = (satellitesTrajectory(:,8) - coordECEF(:,2)) ./ pseudoDistances(:,2);
% H23 = (satellitesTrajectory(:,9) - coordECEF(:,3)) ./ pseudoDistances(:,2);
% H31 = (satellitesTrajectory(:,13) - coordECEF(:,1)) ./ pseudoDistances(:,3);
% H32 = (satellitesTrajectory(:,14) - coordECEF(:,2)) ./ pseudoDistances(:,3);
% H33 = (satellitesTrajectory(:,15) - coordECEF(:,3)) ./ pseudoDistances(:,3);
% H41 = (satellitesTrajectory(:,19) - coordECEF(:,1)) ./ pseudoDistances(:,4);
% H42 = (satellitesTrajectory(:,20) - coordECEF(:,2)) ./ pseudoDistances(:,4);
% H43 = (satellitesTrajectory(:,21) - coordECEF(:,3)) ./ pseudoDistances(:,4);
% 
% for k = 1:size(H11,1)
%     
%     output(:,:,k) = [H11(k) H12(k) H13(k); ...
%                      H21(k) H22(k) H23(k); ...
%                      H31(k) H32(k) H33(k); ...
%                      H41(k) H42(k) H43(k)];
% end

end

