clc
clear all
close all

number_of_flights = 1000 ;

timeStart = 0 ;
timeStep = 1 ;
timeEnd = 150 ;

P_satell = 0.05 ;
P_d = 0.1 ;


savefile_1 = 'mat-data/common.mat';
save(savefile_1, 'number_of_flights', 'timeStart', 'timeStep', ...
                 'timeEnd', 'P_satell', 'P_d');
