function [output] = addErrorsToAbsoluteCoordinates(coordinatesGCCS, errorsGCCS, numberOfAircrafts)

numOfRow = size(coordinatesGCCS,1);
output = zeros(size(coordinatesGCCS));
% measuredH = zeros()
% measuredPhi
% measuredLambda

m = 0;
n = 1;
for k = 1:numberOfAircrafts
    
    output(:,1+m) = coordinatesGCCS(:,1+m) + errorsGCCS(n:numOfRow*k,3); % H
    output(:,2+m) = coordinatesGCCS(:,2+m) + errorsGCCS(n:numOfRow*k,1); % phi
    output(:,3+m) = coordinatesGCCS(:,3+m) + errorsGCCS(n:numOfRow*k,2); % lambda
    output(:,4+m) = coordinatesGCCS(:,4+m) + errorsGCCS(n:numOfRow*k,4); % Vnorth
    output(:,5+m) = coordinatesGCCS(:,5+m) + errorsGCCS(n:numOfRow*k,5); % Veast
    output(:,6+m) = coordinatesGCCS(:,6+m) + errorsGCCS(n:numOfRow*k,6); % Vvert
    
    m = m + 6;
    n = n + numOfRow;
    
    
end