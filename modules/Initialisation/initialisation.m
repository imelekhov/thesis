function [initCoord, Psi, Vhrz0, Vh, a0, tAccel, tStep, Vstep, Time] = initialisation()

%% main calculation
% initCoord = [2e4 0.0351268681215493 0;...
%              2e4 0.0355985806972927 0];
% initCoord = [2e4 0      0;...
%              2e4 0.0017 0]; % H phi lambda
% initCoord = [2e4 0.00007 0;...
initCoord = [2e4 0.00005 0;...
             2e4 0      0.00005]; % H phi lambda
%Psi = [0.44; 0.45]; % in radians
Psi = [0; 0]; % in radians
%Vhrz0 = [250; 285];
Vhrz0 = [250; 260];
%Vhrz0 = [265; 260];
Vh  = [0; 0];
%a0 = [5; 0];
a0 = [0; 0];

timeStart = 0;
timeStep = 1 ;
timeEnd = 150;
Time = timeStart:timeStep:timeEnd;

tAccelDuration = 10; %[s]
tAccelStart = timeEnd - 20;
tAccelEnd = tAccelStart + tAccelDuration;
tAccel_1 = [tAccelStart tAccelEnd];

tStepDuration = 10;
tStepStart = timeEnd - tStepDuration;
tStep_1 = [tStepStart timeEnd];
vStep = Vhrz0 + 20;

%tAccel = [50 60; 0 0];
tAccel = [0 0; 0 0];
tStep = [0 0; 0 0];
Vstep = [0; 0];