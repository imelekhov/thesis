function [ corrMtx ] = calcCorrelMtxECEF( directionCosine )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for k = 1:size(directionCosine, 4)
    
    for m = 1:size(directionCosine, 3)
        
        corrMtx(:,:,m,k) = inv(directionCosine(:,:,m,k).' * directionCosine(:,:,m,k));
        
    end

    %corrMtx(:,:,k) = inv(directionCosine(:,:,k).' * directionCosine(:,:,k));
    
end


