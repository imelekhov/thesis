clc
clear all
close all

addpath('../Initialisation', '../CalculateAbsoluteCoordinates',...
    '../CalculateAbsoluteCoordinates/tools', '../CalculateVelocityLaw',...
    'mat-data', 'tools', '../Ephemeris/mat-data');


errorsMode = 'correlated0';


[initCoord, Psi, Vhrz0, Vh, a0, tAccel, tStep, vStep, Time] = initialisation();
numberOfAircrafts = size(initCoord,1);
%numberOfAircrafts = 1;

%calculateCorrelatedError();
calculateRandomError(numberOfAircrafts);

load calculatedCorrMtx.mat;
load correlatedError.mat;
load randomError.mat;

Vhrz = [];
Psi_res(1,:) = Psi(1) .* ones(1,length(Time)) ;
Psi_res(2,:) = Psi(2) .* ones(1,length(Time)) ;
%is_turn = [1 0] ;
is_turn = [0 0] ;
for k = 1:numberOfAircrafts
    [output] = calcVelocityLaw(Vhrz0(k), a0(k), tAccel(k,:), tStep(k,:), vStep(k), Time, is_turn(k), Psi(k));
    Vhrz = [Vhrz; output(1,:)];
    if (size(output,1) > 1)
        Psi_res(2,:) = output(2,:) ; % radians
    end
end
% [Vhrz1] = calcVelocityLaw(Vhrz0, a0, tAccel, tStep, vStep, Time);
% [output] = calcVelocityLaw(Vhrz0, a0, tAccel, tStep, vStep, Time);

%[coordinatesGCCS] = calcAbsoluteCoordinates(initCoord, Psi, Vh, Vhrz, Time);
[coordinatesGCCS] = calcAbsoluteCoordinates(initCoord, Psi_res, Vh, Vhrz, Time);


if (strcmp(errorsMode,'correlated'))
   [ errorsLCS ] = calculateErrorsCorrelated(corrMtx, randomError(1:length(Time),:));
else
   %[ errorsLCS ] = calculateErrors(correlatedError(1:length(Time),:), randomError(1:length(Time),:), numberOfAircrafts);
   shift_idx = 3800 ;
   [ errorsLCS ] = calculateErrors(correlatedError(1:length(Time),:), randomError(shift_idx:shift_idx+length(Time)-1,:), numberOfAircrafts);
end


[errorsGCCS] = transformErrorFromLCStoGCCS(errorsLCS, coordinatesGCCS, numberOfAircrafts);
[measuredCoordGCCS] = addErrorsToAbsoluteCoordinates(coordinatesGCCS, errorsGCCS, numberOfAircrafts);

savefile_1 = 'mat-data/measuredCoordGCCS.mat';
savefile_2 = 'mat-data/absoluteCoordinatesIdeal.mat';
save(savefile_1, 'measuredCoordGCCS');
save(savefile_2, 'coordinatesGCCS');
 
% figure(1)
% plot(Time.', coordinatesGCCS(:,3), 'r')
% hold on
% plot(Time.', measuredCoordGCCS(:,3), 'g')
% grid on