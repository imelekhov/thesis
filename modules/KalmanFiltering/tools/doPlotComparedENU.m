function [ ] = doPlotComparedENU( data, estimation, time )
%DOPLOTCOMPAREDENU Summary of this function goes here
%   Detailed explanation goes here

%Time = time(2:end);
Time = time;
%Data = data(2:end,:);
Data = data;

figure()
plot(Time, Data(1,:))
hold on
plot(Time, estimation(1,:), 'g')
grid on
legend('X_{mesured}', 'X_{est}')
xlabel('t, sec')
ylabel('A, m')

figure()
plot(Time, Data(2,:))
hold on
plot(Time, estimation(4,:), 'g')
grid on
legend('Y_{mesured}', 'Y_{est}')
xlabel('t, sec')
ylabel('A, m')

figure()
plot(Time, Data(3,:))
hold on
plot(Time, estimation(7,:), 'g')
grid on
legend('Z_{mesured}', 'Z_{est}')
xlabel('t, sec')
ylabel('A, m')


end

