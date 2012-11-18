clc
clear all
close all

addpath('../MeasureAbsoluteCoordintes/mat-data', '../CalculateAbsoluteCoordinates',...
    '../CalculateAbsoluteCoordinates/tools', '../CalculateVelocityLaw', 'tools', 'mat-data');

load absoluteCoordinatesIdeal.mat;

sigmaD = 6;
sigmaV = 0.09;

[ coordECEF ] = geodeticToECEF( coordinatesGCCS );

%axis square

time = 0:size(coordECEF,1) - 1;

[ dataSatellite ] = initSatellites();

[ satellitesTrajectory, timeSat ] = solveSatMotionEquation( dataSatellite, time );


% figure();
% plot3(coordECEF(:,1,1), coordECEF(:,2,1), coordECEF(:,3,1), '*');
% hold on
% plot3(coordECEF(:,1,2), coordECEF(:,2,2), coordECEF(:,3,2), 'y*');
% plot3(satellitesTrajectory(:,1,1), satellitesTrajectory(:,2,1), satellitesTrajectory(:,3,1), 'r*'); grid on
% plot3(satellitesTrajectory(:,1,2), satellitesTrajectory(:,2,2), satellitesTrajectory(:,3,2), 'g*'); grid on
% plot3(satellitesTrajectory(:,1,3), satellitesTrajectory(:,2,3), satellitesTrajectory(:,3,3), 'c*'); grid on
% plot3(satellitesTrajectory(:,1,4), satellitesTrajectory(:,2,4), satellitesTrajectory(:,3,4), 'k*'); grid on
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% legend('Aircraft', 'Satellite #3', 'Satellite #6', 'Satellite #12', 'Satellite #19')
% title('Satellites position on 5 May 2011 at 12:15')
% grid on


[ pseudoDistances ] = calcPseudoDistances( satellitesTrajectory, coordECEF );

[ directionCosine ] = calcDirectionCosines( satellitesTrajectory, pseudoDistances, coordECEF );

% checkH = directionCosine(1,1,:) .^ 2 + directionCosine(1,2,:) .^ 2 + directionCosine(1,3,:) .^ 2;
% figure();
% plot(checkH(:))
% grid on

[ corrMtxECEF ] = calcCorrelMtxECEF( directionCosine );
phiLambdaRefAircraft = coordinatesGCCS(:, 2:3); % first aircraft
%[ corrMtxUVW ] = calcCorrelMtxUVW( directionCosine, phiLambdaRefAircraft, sigmaD );
[ corrMtxUVWxyz, corrMtxUVWv ] = calcCorrelMtxUVW( directionCosine, phiLambdaRefAircraft, sigmaD, sigmaV);

R11_1 = corrMtxECEF(1,1,:,1);
R22_1 = corrMtxECEF(2,2,:,1);
R33_1 = corrMtxECEF(3,3,:,1);

R11_2 = corrMtxECEF(1,1,:,2);
R22_2 = corrMtxECEF(2,2,:,2);
R33_2 = corrMtxECEF(3,3,:,2);

figure(7)
subplot(3,1,1)
plot(time, sqrt(R11_1(:) + R22_1(:)), '-b.') % HDOP
grid on
xlabel('t, sec')
legend('HDOP')

subplot(3,1,2)
plot(time, sqrt(R33_1(:)), '-r.') % VDOP
grid on
xlabel('t, sec')
legend('VDOP')

subplot(3,1,3)
plot(time, sqrt(R11_1(:) + R22_1(:) + R33_1(:)), '-k.') % PDOP
grid on
xlabel('t, sec')
legend('PDOP')

figure(8)
subplot(3,1,1)
plot(time, sqrt(R11_2(:) + R22_2(:)), '-b.') % HDOP
grid on
xlabel('t, sec')
legend('HDOP')

subplot(3,1,2)
plot(time, sqrt(R33_2(:)), '-r.') % VDOP
grid on
xlabel('t, sec')
legend('VDOP')

subplot(3,1,3)
plot(time, sqrt(R11_2(:) + R22_2(:) + R33_2(:)), '-k.') % PDOP
grid on
xlabel('t, sec')
legend('PDOP')

savefile_1 = 'mat-data/calculatedCorrMtx.mat';
savefile_2 = 'mat-data/calcCorrMtxECEF.mat';
savefile_3 = 'mat-data/sigmaDV.mat';
save(savefile_1, 'corrMtxUVWxyz', 'corrMtxUVWv');
save(savefile_2, 'corrMtxECEF');
save(savefile_3, 'sigmaD', 'sigmaV');

plotCorrelationCoeffs( corrMtxUVWxyz, time, 'r')
plotCorrelationCoeffs( corrMtxUVWv, time, 'b')