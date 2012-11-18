clear all
close all
clc

addpath('../MeasureAbsoluteCoordintes/mat-data', ...
        '../Ephemeris/mat-data',                 ...
        '../GenerateNoiseByCorrMtx/mat-data',    ...
        '../Common/mat-data',                    ...
        'tools');


load 'measuredCoordGCCS.mat'
load 'absoluteCoordinatesIdeal.mat'
load 'calculatedCorrMtx.mat'
load 'correlatedNoiseMtxXYZ.mat'
load 'correlatedNoiseMtxV.mat'
load 'common.mat'

errorsMode = 'not_correlated';

GCCScoordsFor2aircrafts = measuredCoordGCCS(:,1:12);
%GCCScoordsFor2aircrafts = measuredCoordGCCS(:,13:end);
GCCScoordsFor2aircraftsIdeal = coordinatesGCCS(:,1:12);
%GCCScoordsFor2aircraftsIdeal = coordinatesGCCS(:,13:end);

[ coordLCSIdeal ] = transformCoordFromGCCStoLCS(GCCScoordsFor2aircraftsIdeal);

if (strcmp(errorsMode,'correlated'))
   starting_idx = 5000 ;
   numberOfColumn = starting_idx:starting_idx + number_of_flights - 1 ; % number of flights equals to 1000
   [ measuredCoordLCS ] = addNoise( coordLCSIdeal, correlatedErrorXYZ, correlatedErrorV, numberOfColumn );
else  
   [ measuredCoordLCS ] = transformCoordFromGCCStoLCS(GCCScoordsFor2aircrafts);
end


savefile_1 = 'mat-data/measuredCoordLCS.mat';
savefile_2 = 'mat-data/coordLCSIdeal.mat';
savefile_3 = 'mat-data/numberOfFlights.mat';
save(savefile_1, 'measuredCoordLCS');
save(savefile_2, 'coordLCSIdeal');
%save(savefile_3, 'numberOfColumn');