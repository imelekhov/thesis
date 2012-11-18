function [ output ] = calculateErrorsCorrelated(corrMtx, randomErrorSpeed)
%CALCULATEERRORSCORRELATED Summary of this function goes here
%   Detailed explanation goes here

N = 100000;
% sigmaC = 9;
% sigmaR = 5;
% sigmaH = 7;
sigmaV = 0.1;
sigmaVy = 0.12;

numberOfIteration = size(corrMtx,3);

deltaXerror  = zeros(numberOfIteration, 1);
deltaYerror  = zeros(numberOfIteration, 1);
deltaZerror  = zeros(numberOfIteration, 1);
% deltaVXerror = zeros(numberOfIteration, 1);
% deltaVYerror = zeros(numberOfIteration, 1);
% deltaVZerror = zeros(numberOfIteration, 1);


genRand = randn(size(corrMtx,1), N);
for k = 1:numberOfIteration
    Cchol = corrMtx(:,:,k);
    correlatedErrorTmp = Cchol.' * genRand; % it is a matrix which has 3xN dimension
    corrErrorXYZ = correlatedErrorTmp(:,5);
    
    deltaXerror(k,:) = corrErrorXYZ(1);
    deltaYerror(k,:) = corrErrorXYZ(2);
    deltaZerror(k,:) = corrErrorXYZ(3);
    
end
deltaVXerror = sigmaV .* randomErrorSpeed(:,4);
deltaVYerror = sigmaV .* randomErrorSpeed(:,5);
deltaVZerror = sigmaVy .* randomErrorSpeed(:,6);

output = [deltaXerror deltaYerror deltaZerror deltaVXerror deltaVYerror deltaVZerror];


end


