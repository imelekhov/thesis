function [ ] = doPlotDiffer( idealCoordLCS, estData, time, color, stdD, stdV )
%DOPLOTDIFFER Summary of this function goes here
%   Detailed explanation goes here

estDataToPlot = estData.';
idealCoordToPlot = idealCoordLCS(2:end,:);
timeToPlot = time(2:end);


figure();
plot(timeToPlot, estDataToPlot(:,1) - idealCoordToPlot(:,1), color)
grid on
legend('X_{est} - X')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m')

figure()
plot(timeToPlot, estDataToPlot(:,4) - idealCoordToPlot(:,2), color)
grid on
legend('Y_{est} - Y')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m')

figure()
plot(timeToPlot, estDataToPlot(:,7) - idealCoordToPlot(:,3), color)
grid on
legend('Z_{est} - Z')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m')

figure()
plot(timeToPlot, estDataToPlot(:,2) - idealCoordToPlot(:,4), color)
grid on
legend('Vx_{est} - Vx')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m/s')

figure()
plot(timeToPlot, estDataToPlot(:,5) - idealCoordToPlot(:,5), color)
grid on
legend('Vy_{est} - V_y')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m/s')

figure()
plot(timeToPlot, estDataToPlot(:,8) - idealCoordToPlot(:,6), color)
grid on
legend('Vz_{est} - Vz')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m/s')





end


