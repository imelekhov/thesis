function [ output ] = addNoise( coordLCSIdeal, correlatedErrorXYZ, correlatedErrorV, num )
%ADDNOISE Summary of this function goes here
%   Detailed explanation goes here


rowDim = size(coordLCSIdeal,1);
output = zeros(rowDim, size(coordLCSIdeal,2), length(num));

for p = 1:length(num)
    
    noiseXYZ = reshape(correlatedErrorXYZ(:,num(p),:), [3 rowDim]).';
    noiseV = reshape(correlatedErrorV(:,num(p),:), [3 rowDim]).';
    
    measuredLCSI = coordLCSIdeal + [noiseXYZ noiseV];
    output(:,:,p) = measuredLCSI;
    
end



end

