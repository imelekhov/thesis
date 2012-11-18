function [ output ] = measuredCoordECEF( coordECEFideal, stdVec )
%MEASUREDCOORDECEF Summary of this function goes here
%   Detailed explanation goes here


N = 10000;

numOfIter = size(coordECEFideal, 1);
output = zeros(numOfIter, size(coordECEFideal, 2));

edge = 555;

for k = 1:numOfIter
    
    randX = stdVec(1) .* randn(1, N);
    randY = stdVec(2) .* randn(1, N);
    randZ = stdVec(3) .* randn(1, N);
    
    mesuredX = coordECEFideal(k,1) + randX(edge);
    mesuredY = coordECEFideal(k,2) + randY(edge);
    mesuredZ = coordECEFideal(k,3) + randZ(edge);
    
    output(k,:) = [mesuredX mesuredY mesuredZ];
    
    
end

end

