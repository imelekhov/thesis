function [ corrMtxXYZ, corrMtxV ] = calcCorrelMtxUVW( directionCosine, phiLambdaRefAircraft, sigmaD, sigmaV)
%CALCCORRELMTX Summary of this function goes here
%   Detailed explanation goes here

% phiLambdaRefAircraft is a matrix [size(time) x 2]


corrMtxXYZ = zeros(size(directionCosine,2), size(directionCosine,2), size(phiLambdaRefAircraft,1));
corrMtxV = zeros(size(directionCosine,2), size(directionCosine,2), size(phiLambdaRefAircraft,1));
for m = 1:size(directionCosine, 3)
    
    Juvw = [-sin(phiLambdaRefAircraft(m,2)) cos(phiLambdaRefAircraft(m,2)) 0;...
        -sin(phiLambdaRefAircraft(m,1)) * cos(phiLambdaRefAircraft(m,2)) -sin(phiLambdaRefAircraft(m,1)) * sin(phiLambdaRefAircraft(m,2)) cos(phiLambdaRefAircraft(m,1)); ...
        cos(phiLambdaRefAircraft(m,1)) * cos(phiLambdaRefAircraft(m,2)) cos(phiLambdaRefAircraft(m,1)) * sin(phiLambdaRefAircraft(m,2)) sin(phiLambdaRefAircraft(m,1))];
    
    R1XYZ = inv(directionCosine(:,:,m,1).' * directionCosine(:,:,m,1));
    R2XYZ = inv(directionCosine(:,:,m,2).' * directionCosine(:,:,m,2));
    
    R1V = inv((-directionCosine(:,:,m,1)).' * (-directionCosine(:,:,m,1)));
    %R1V = inv((directionCosine(:,:,m,1)).' * (directionCosine(:,:,m,1)));
    R2V = inv((-directionCosine(:,:,m,2)).' * (-directionCosine(:,:,m,2)));
    %R2V = inv((directionCosine(:,:,m,2)).' * (directionCosine(:,:,m,2)));
    
    corrMtxXYZ(:,:,m) = Juvw * sigmaD^2 * (R1XYZ + R2XYZ) * Juvw.';
    %corrMtxXYZ(:,:,m) = Juvw * sigmaD * (R1XYZ + R2XYZ) * Juvw.';
        
    corrMtxV(:,:,m) = Juvw * sigmaV^2 * (R1V + R2V) * Juvw.';
    %corrMtxV(:,:,m) = Juvw * sigmaV * (R1V + R2V) * Juvw.';
    
end



% for k = 1:size(directionCosine, 3)
%     
%     Juvw = [-sin(phiLambdaRefAircraft(k,2)) cos(phiLambdaRefAircraft(k,2)) 0;...
%         -sin(phiLambdaRefAircraft(k,1)) * cos(phiLambdaRefAircraft(k,2)) -sin(phiLambdaRefAircraft(k,1)) * sin(phiLambdaRefAircraft(k,2)) cos(phiLambdaRefAircraft(k,1)); ...
%         cos(phiLambdaRefAircraft(k,1)) * cos(phiLambdaRefAircraft(k,2)) cos(phiLambdaRefAircraft(k,1)) * sin(phiLambdaRefAircraft(k,2)) sin(phiLambdaRefAircraft(k,1))];
%     
%     corrMtx(:,:,k) = Juvw * sigmaD^2 * inv(directionCosine(:,:,k).' * directionCosine(:,:,k)) * Juvw.';
%     %corrMtx(:,:,k) = Juvw * inv(directionCosine(:,:,k).' * directionCosine(:,:,k)) * Juvw.';
%     
% end
% 
% 

end

