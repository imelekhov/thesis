function [output] = transformErrorFromLCStoGCCS(errorsLCS, coordsGCCS, numberOfAircrafts)

a = 6378245;
eSq = 0.0066934;

numOfRow     = size(errorsLCS, 1) / numberOfAircrafts;
deltaPhi     = zeros(size(errorsLCS, 1), 1);
deltaLambda  = zeros(size(deltaPhi));
R            = zeros(size(deltaPhi));
deltaH       = zeros(size(deltaPhi));
deltaVnorth  = zeros(size(deltaPhi));
deltaVeast   = zeros(size(deltaPhi));
deltaVh      = zeros(size(deltaPhi));

m = 1;

numPhi = 0;
numH = numPhi;

for k = 1:numberOfAircrafts
    
    R(m:numOfRow*k) = a * (1 - 0.5 * eSq .* sin(coordsGCCS(:,2+6*numPhi)).^2) + coordsGCCS(:,1+6*numH);
    deltaPhi(m:numOfRow*k) = errorsLCS(m:numOfRow*k,1) ./ R(m:numOfRow*k);
    deltaLambda(m:numOfRow*k) = errorsLCS(m:numOfRow*k,2) ./ (R(m:numOfRow*k) .* cos(coordsGCCS(:,2+6*numPhi)));
    deltaH(m:numOfRow*k) = errorsLCS(m:numOfRow*k,3);
    
    deltaVnorth(m:numOfRow*k) = errorsLCS(m:numOfRow*k,4);
    deltaVeast(m:numOfRow*k) = errorsLCS(m:numOfRow*k,5);
    deltaVh(m:numOfRow*k) = errorsLCS(m:numOfRow*k,6);
    
    m = m + numOfRow;
    numPhi = numPhi + 1;
    numH = numPhi;
end

output = [deltaPhi deltaLambda deltaH deltaVnorth deltaVeast deltaVh R];






