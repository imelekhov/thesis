function [ output ] = calculateCorrelatedError(corrMtxUVWxyz, corrMtxUVWv, coordLCSIdeal )
%CALCULATECORRELATEDERROR Summary of this function goes here
%   Detailed explanation goes here



N = 100000;
% a = 6378245;
% eSq = 0.0066934;
numberOfAircrafts = 2; % always

% numPhi = 0;
% numH = 0;
% R = zeros(size(GCCScoordsFor2aircrafts,1), numberOfAircrafts);

numberOfIteration = size(corrMtxUVWxyz,3);

deltaXerror  = zeros(numberOfIteration, 1);
deltaYerror  = zeros(numberOfIteration, 1);
deltaZerror  = zeros(numberOfIteration, 1);
deltaVXerror  = zeros(numberOfIteration, 1);
deltaVYerror  = zeros(numberOfIteration, 1);
deltaVZerror  = zeros(numberOfIteration, 1);



% sigmaV = 0.09;
% rrandVmtx = randn(3, 10000);
% rrandVmtxSigma = sigmaV .* rrandVmtx;

   
for k = 1:numberOfIteration
    
    genRandXYZ = randn(size(corrMtxUVWxyz,1), N);
    genRandV = randn(size(corrMtxUVWv,1), N);
    
    CcholXYZ = chol(corrMtxUVWxyz(:,:,k));
    CcholV = chol(corrMtxUVWv(:,:,k));
    correlatedErrorTmpXYZ = CcholXYZ.' * genRandXYZ; % it is a matrix which has 3xN dimension
    %correlatedErrorTmpXYZ = CcholXYZ * genRandXYZ; % it is a matrix which has 3xN dimension
    correlatedErrorTmpV = CcholV.' * genRandV; % it is a matrix which has 3xN dimension
    %correlatedErrorTmpV = CcholV * genRandV; % it is a matrix which has 3xN dimension
    corrErrorXYZ = correlatedErrorTmpXYZ(:,555);
    corrErrorV = correlatedErrorTmpV(:,555);
    
    deltaXerror(k,:) = corrErrorXYZ(1);
    deltaYerror(k,:) = corrErrorXYZ(2);
    deltaZerror(k,:) = corrErrorXYZ(3);
    
    deltaVXerror(k,:) = corrErrorV(1);
    deltaVYerror(k,:) = corrErrorV(2);
    deltaVZerror(k,:) = corrErrorV(3);
%     
%     deltaVXerror(k,:) = rrandVmtxSigma(1, k + 1000);
%     deltaVYerror(k,:) = rrandVmtxSigma(2, k + 1000);
%     deltaVZerror(k,:) = rrandVmtxSigma(3, k + 1000);

    %rrandVmtxSigma
    
end

deltaCoordErrors = [deltaXerror deltaYerror deltaZerror deltaVXerror deltaVYerror deltaVZerror];
measuredLCSI = coordLCSIdeal + deltaCoordErrors;
output = measuredLCSI;

% for k = 1:numberOfAircrafts
%     R(:,k) = a * (1 - 0.5 * eSq .* sin(GCCScoordsFor2aircrafts(:,2+6*numPhi)).^2) + GCCScoordsFor2aircrafts(:,1+6*numH);
%     numPhi = numPhi + 1;
%     numH = numH + 1;
% end
% 
% deltaAlpha = GCCScoordsFor2aircrafts(:,9) - GCCScoordsFor2aircrafts(:,3);
% 
% phi1 = GCCScoordsFor2aircrafts(:,2);
% phi2 = GCCScoordsFor2aircrafts(:,8);
% Vnorth1 = GCCScoordsFor2aircrafts(:,4);
% Veast1  = GCCScoordsFor2aircrafts(:,5);
% Vvert1  = GCCScoordsFor2aircrafts(:,6);
% Vnorth2 = GCCScoordsFor2aircrafts(:,10);
% Veast2  = GCCScoordsFor2aircrafts(:,11);
% Vvert2  = GCCScoordsFor2aircrafts(:,12);
% 
% VxLoc = (Vnorth2 - Vnorth1 .* R(:,2) ./ R(:,1)) .* (cos(phi1) .* cos(phi2) + sin(phi1) .* sin(phi2) .* cos(deltaAlpha)) + (Veast2 - Veast1 .* R(:,2) .* cos(phi2) ./ (R(:,1) .* cos(phi1))) .* sin(phi1) .* sin(deltaAlpha) + Vvert2 .* (cos(phi1) .* sin(phi2) - cos(phi2) .* sin(phi1) .* cos(deltaAlpha));
% VyLoc = Vnorth2 .* (sin(phi1) .* cos(phi2) - sin(phi2) .* cos(phi1) .* cos(deltaAlpha)) + Vnorth1 .* (sin(phi2) .* cos(phi1) - sin(phi1) .* cos(phi2) .* cos(deltaAlpha)) .* R(:,2) ./ R(:,1) - Veast2 .* cos(phi1) .* sin(deltaAlpha) + Veast1 .* cos(phi2) .* sin(deltaAlpha) .* R(:,2) ./ R(:,1) + Vvert2 .* (sin(phi1) .* sin(phi2) + cos(phi1) .* cos(phi2) .* cos(deltaAlpha)) - Vvert1;
% VzLoc = Veast2 .* cos(deltaAlpha) - Vnorth2 .* sin(phi2) .* sin(deltaAlpha) + Vvert1 .* sin(deltaAlpha) .* cos(phi2) - Veast1 .* cos(deltaAlpha) .* R(:,2) .* cos(phi2) ./ (R(:,1) .* cos(phi1));
% 
% 
% output = [measuredLCSIcoords VxLoc VyLoc VzLoc];
% 
% 
% 

end

