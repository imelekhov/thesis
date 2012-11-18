function [output] = transformCoordFromGCCStoLCS(GCCScoordsFor2aircrafts)

% GCCScoordsFor2aircrafts = [H1 phi1 lambda1 Vnorth1 Veast1 Vvert1 H2 phi2 lambda2 Vnorth2 Veast2 Vvert2]
% GCCScoordsFor2aircrafts has [N x 12] size

a = 6378245;
eSq = 0.0066934;
numberOfAircrafts = 2; % always

numPhi = 0;
numH = 0;
R = zeros(size(GCCScoordsFor2aircrafts,1), numberOfAircrafts);
for k = 1:numberOfAircrafts
    R(:,k) = a * (1 - 0.5 * eSq .* sin(GCCScoordsFor2aircrafts(:,2+6*numPhi)).^2) + GCCScoordsFor2aircrafts(:,1+6*numH);
    numPhi = numPhi + 1;
    numH = numH + 1;
end

deltaAlpha = GCCScoordsFor2aircrafts(:,9) - GCCScoordsFor2aircrafts(:,3);
X = R(:,2) .* (sin(GCCScoordsFor2aircrafts(:,8)) .* cos(GCCScoordsFor2aircrafts(:,2)) - cos(GCCScoordsFor2aircrafts(:,8)) .* sin(GCCScoordsFor2aircrafts(:,2)) .* cos(deltaAlpha));
Y = R(:,2) .* (sin(GCCScoordsFor2aircrafts(:,8)) .* sin(GCCScoordsFor2aircrafts(:,2)) + cos(GCCScoordsFor2aircrafts(:,8)) .* cos(GCCScoordsFor2aircrafts(:,2)) .* cos(deltaAlpha)) - R(:,1);
Z = R(:,2) .* cos(GCCScoordsFor2aircrafts(:,8)) .* sin(deltaAlpha);

phi1 = GCCScoordsFor2aircrafts(:,2);
phi2 = GCCScoordsFor2aircrafts(:,8);
Vnorth1 = GCCScoordsFor2aircrafts(:,4);
Veast1  = GCCScoordsFor2aircrafts(:,5);
Vvert1  = GCCScoordsFor2aircrafts(:,6);
Vnorth2 = GCCScoordsFor2aircrafts(:,10);
Veast2  = GCCScoordsFor2aircrafts(:,11);
Vvert2  = GCCScoordsFor2aircrafts(:,12);

VxLoc = (Vnorth2 - Vnorth1 .* R(:,2) ./ R(:,1)) .* (cos(phi1) .* cos(phi2) + sin(phi1) .* sin(phi2) .* cos(deltaAlpha)) + (Veast2 - Veast1 .* R(:,2) .* cos(phi2) ./ (R(:,1) .* cos(phi1))) .* sin(phi1) .* sin(deltaAlpha) + Vvert2 .* (cos(phi1) .* sin(phi2) - cos(phi2) .* sin(phi1) .* cos(deltaAlpha));
VyLoc = Vnorth2 .* (sin(phi1) .* cos(phi2) - sin(phi2) .* cos(phi1) .* cos(deltaAlpha)) + Vnorth1 .* (sin(phi2) .* cos(phi1) - sin(phi1) .* cos(phi2) .* cos(deltaAlpha)) .* R(:,2) ./ R(:,1) - Veast2 .* cos(phi1) .* sin(deltaAlpha) + Veast1 .* cos(phi2) .* sin(deltaAlpha) .* R(:,2) ./ R(:,1) + Vvert2 .* (sin(phi1) .* sin(phi2) + cos(phi1) .* cos(phi2) .* cos(deltaAlpha)) - Vvert1;
VzLoc = Veast2 .* cos(deltaAlpha) - Vnorth2 .* sin(phi2) .* sin(deltaAlpha) + Vvert1 .* sin(deltaAlpha) .* cos(phi2) - Veast1 .* cos(deltaAlpha) .* R(:,2) .* cos(phi2) ./ (R(:,1) .* cos(phi1));

output = [X Y Z VxLoc VyLoc VzLoc];