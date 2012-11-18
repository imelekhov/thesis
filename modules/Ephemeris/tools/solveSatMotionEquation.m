function [ satellitesData, Time ] = solveSatMotionEquation( dataSatellite, time )
%SOLVESATMOTIONEQUATION Summary of this function goes here
%   Detailed explanation goes here

for k = 1:size(dataSatellite,3)
    
    [satTime,satTraj] = ode45(@(t,y) diffEq(t,y,dataSatellite(end-2:end, 1, k)), time, dataSatellite(1:end-3, 1, k).');
    satellitesData(:,:,k) = satTraj;
    Time = satTime;
    
end



% [TsatTmp_1,YsatTmp_1] = ode45(@(t,y) diffEq(t,y,dataSatellite(end-2:end,1)), time, dataSatellite(1:end-3,1).');
% [TsatTmp_2,YsatTmp_2] = ode45(@(t,y) diffEq(t,y,dataSatellite(end-2:end,2)), time, dataSatellite(1:end-3,2).');
% [TsatTmp_3,YsatTmp_3] = ode45(@(t,y) diffEq(t,y,dataSatellite(end-2:end,3)), time, dataSatellite(1:end-3,3).');
% [TsatTmp_4,YsatTmp_4] = ode45(@(t,y) diffEq(t,y,dataSatellite(end-2:end,4)), time, dataSatellite(1:end-3,4).');
% 
% % one satellite is [length(time) x 6] => [X Y Z Vx Vy Vz]
% satellitesData = [YsatTmp_1 YsatTmp_2 YsatTmp_3 YsatTmp_4];
% Time = TsatTmp_1;





end

