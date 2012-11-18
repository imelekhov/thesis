clear all
close all
clc

addpath('tools', '../MeasureAbsoluteCoordintes/mat-data', ...
        '../Ephemeris/mat-data');
    
load absoluteCoordinatesIdeal.mat
load calcCorrMtxECEF.mat

coordGCCSsecond = coordinatesGCCS(:,7:end);

[ coordECEFsecond ] = geoToECEF(coordGCCSsecond);


stdVec = [9 9 15];
[ measuredCoordECEF ] = measuredCoordECEF( coordECEFsecond, stdVec );

refGCCS = coordinatesGCCS(:,1:6);
corrMtxECEF = diag(stdVec.^2);
[ measENU, corrMtxENU ] = transformMeasECEFtoENU( refGCCS, measuredCoordECEF, corrMtxECEF );

measENU = measENU;
savefile_1 = 'mat-data/measENU.mat';
savefile_2 = 'mat-data/corrMtxENU.mat';
save(savefile_1, 'measENU');
save(savefile_2, 'corrMtxENU');