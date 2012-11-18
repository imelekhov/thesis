function [ measENU, corrMtxENU ] = transformMeasECEFtoENU( refGCCS, measECEF, corrMtxECEF )
%TRANSFORMMEASECEFTOENU Summary of this function goes here
%   Detailed explanation goes here


numOfIter = size(refGCCS, 1);

measENU = zeros(3,numOfIter);
corrMtxENU = zeros(3,3,numOfIter);

for k = 1:numOfIter
    
    Jenu = [-sin(refGCCS(k,3))                   cos(refGCCS(k,3))                    0; ...
            -sin(refGCCS(k,2))*cos(refGCCS(k,3)) -sin(refGCCS(k,2))*sin(refGCCS(k,2)) cos(refGCCS(k,2)); ...
            cos(refGCCS(k,2))*cos(refGCCS(k,3))  cos(refGCCS(k,2))*sin(refGCCS(k,3))  sin(refGCCS(k,2))];
        
    measENU(:,k) = Jenu * measECEF(k,:).';
    corrMtxENU(:,:,k) = Jenu * corrMtxECEF * Jenu.';
   
end


end

