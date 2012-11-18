function [ ] = plot_std_kf_c( stdVec, time, color, std_inform )
%PLOTSTD Summary of this function goes here
%   Detailed explanation goes here

% stdVec is a matrix [150 x 6]


estDataToPlot = stdVec.';
timeToPlot = time(2:end);
stdD = std_inform(1) ;
stdV = std_inform(2) ;

figure();
subplot(1,2,1);
plot(timeToPlot, estDataToPlot(1,:), color, 'LineWidth', 2)
grid on
legend('std(X)')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m')
subplot(1,2,2);
plot(timeToPlot, estDataToPlot(1,:), color, 'LineWidth', 2)
grid on
legend('std(X)')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m')


figure()
subplot(1,2,1)
plot(timeToPlot, estDataToPlot(2,:), color, 'LineWidth', 2)
grid on
legend('std(Y)')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m')
subplot(1,2,2)
plot(timeToPlot, estDataToPlot(2,:), color, 'LineWidth', 2)
grid on
legend('std(Y)')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m')

figure()
subplot(1,2,1)
plot(timeToPlot, estDataToPlot(3,:), color, 'LineWidth', 2)
grid on
legend('std(Z)')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m')
subplot(1,2,2)
plot(timeToPlot, estDataToPlot(3,:), color, 'LineWidth', 2)
grid on
legend('std(Z)')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m')

figure()
subplot(1,2,1)
plot(timeToPlot, estDataToPlot(4,:), color, 'LineWidth', 2)
grid on
legend('std(V_x)')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m/s')
subplot(1,2,2)
plot(timeToPlot, estDataToPlot(4,:), color, 'LineWidth', 2)
grid on
legend('std(V_x)')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m/s')

figure()
subplot(1,2,1)
plot(timeToPlot, estDataToPlot(5,:), color, 'LineWidth', 2)
grid on
legend('std(V_y)')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m/s')
subplot(1,2,2)
plot(timeToPlot, estDataToPlot(5,:), color, 'LineWidth', 2)
grid on
legend('std(V_y)')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m/s')

figure()
subplot(1,2,1)
plot(timeToPlot, estDataToPlot(6,:), color, 'LineWidth', 2)
grid on
legend('std(V_z)')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m/s')
subplot(1,2,2)
plot(timeToPlot, estDataToPlot(6,:), color, 'LineWidth', 2)
grid on
legend('std(V_z)')
title(['\sigma_D = ', num2str(stdD), ' m, \sigma_V = ', num2str(stdV), ' m/s'])
xlabel('t, sec')
ylabel('A, m/s')


end

