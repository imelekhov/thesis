function [ ] = doPlot(data, estimation, time)

Time = time(2:end);
Data = data(2:end,:);

figure()
plot(Time, Data(:,1) - estimation(1,:).') % deltaX
grid on
legend('X_{mod} - X_{est}')
xlabel('t, sec')
ylabel('A, m')

figure()
plot(Time, Data(:,2) - estimation(4,:).') % deltaY
grid on
legend('Y_{mod} - Y_{est}')
xlabel('t, sec')
ylabel('A, m')

figure()
plot(Time, Data(:,3) - estimation(7,:).') % deltaZ
grid on
legend('Z_{mod} - Z_{est}')
xlabel('t, sec')
ylabel('A, m')

figure()
plot(Time, Data(:,4) - estimation(2,:).') % deltaVx
grid on
legend('Vx_{mod} - Vx_{est}')
xlabel('t, sec')
ylabel('A, m/s')

figure()
plot(Time, Data(:,5) - estimation(5,:).') % deltaVy
grid on
legend('Vy_{mod} - Vy_{est}')
xlabel('t, sec')
ylabel('A, m/s')

figure()
plot(Time, Data(:,6) - estimation(8,:).') % deltaVz
grid on
legend('Vz_{mod} - Vz_{est}')
xlabel('t, sec')
ylabel('A, m/s')


end

