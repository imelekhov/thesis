function [output] = calculateErrors(correlatedError, randomError, numberOfAircrafts)


sigmaC_x_z = 9 ;
sigmaC_y = 13 ;

%sigmaR = 5 ;
%sigmaH = 7 ;
%sigmaV = 0.1 ;
sigmaV = 0.2 ;
%sigmaVy = 0.12 ;
sigmaVy = 0.3 ;

numOfRow = size(correlatedError,1);
deltaXerror  = zeros(numOfRow * numberOfAircrafts, 1);
deltaYerror  = zeros(numOfRow * numberOfAircrafts, 1);
deltaZerror  = zeros(numOfRow * numberOfAircrafts, 1);
deltaVXerror = zeros(numOfRow * numberOfAircrafts, 1);
deltaVYerror = zeros(numOfRow * numberOfAircrafts, 1);
deltaVZerror = zeros(numOfRow * numberOfAircrafts, 1);
m = 1;
n = 0;

for k = 1:numberOfAircrafts
    
    %deltaXerror(m:numOfRow*k) = sigmaC .* randomError(:,1 + n) + sigmaR .* correlatedError(:,1);
    deltaXerror(m:numOfRow*k) = sigmaC_x_z .* randomError(:,1 + n) ;
    %deltaYerror(m:numOfRow*k) = sigmaC .* randomError(:,2 + n) + sigmaR .* correlatedError(:,2);
    deltaYerror(m:numOfRow*k) = sigmaC_x_z .* randomError(:,2 + n) ;
    %deltaZerror(m:numOfRow*k) = sigmaC .* randomError(:,3 + n) + sigmaH .* correlatedError(:,3);
    deltaZerror(m:numOfRow*k) = sigmaC_y .* randomError(:,3 + n) ;
    
    deltaVXerror(m:numOfRow*k) = sigmaV .* randomError(:,4 + n);
    deltaVYerror(m:numOfRow*k) = sigmaV .* randomError(:,5 + n);
    deltaVZerror(m:numOfRow*k) = sigmaVy .* randomError(:,6 + n);
    
    m = m + numOfRow;
    n = n + 6; % 6 variables
      
end

output = [deltaXerror deltaYerror deltaZerror deltaVXerror deltaVYerror deltaVZerror];