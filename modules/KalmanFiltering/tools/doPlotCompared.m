function [ ] = doPlotCompared(data, estimation, time, color)
%DOPLOTCOMPARED Summary of this function goes here
%   Detailed explanation goes here

Time = time(2:end);
%Time = time;
Data = data(2:end,:);
%Data = data;

figure()
plot(Time, Data(:,1))
hold on
plot(Time, estimation(1,:).', color)
grid on
legend('X_{mesured}', 'X_{est}')
xlabel('t, sec')
ylabel('A, m')

figure()
plot(Time, Data(:,2))
hold on
plot(Time, estimation(4,:).', color)
grid on
legend('Y_{mesured}', 'Y_{est}')
xlabel('t, sec')
ylabel('A, m')

figure()
plot(Time, Data(:,3))
hold on
plot(Time, estimation(7,:).', color)
grid on
legend('Z_{mesured}', 'Z_{est}')
xlabel('t, sec')
ylabel('A, m')

figure()
plot(Time, Data(:,4))
hold on
plot(Time, estimation(2,:).', color)
grid on
legend('Vx_{mesured}', 'Vx_{est}')
xlabel('t, sec')
ylabel('A, m/s')

figure()
plot(Time, Data(:,5))
hold on
plot(Time, estimation(5,:).', color)
grid on
legend('Vy_{mesured}', 'Vy_{est}')
xlabel('t, sec')
ylabel('A, m/s')

figure()
plot(Time, Data(:,6))
hold on
plot(Time, estimation(8,:).', color)
grid on
legend('Vz_{mesured}', 'Vz_{est}')
xlabel('t, sec')
ylabel('A, m/s')


end

