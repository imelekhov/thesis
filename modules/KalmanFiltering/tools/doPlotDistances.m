function [ ] = doPlotDistances(estData, time)

distances = zeros(size(estData,3), size(estData,2)) ;
for k = 1:size(estData,3)
    distances(k,:) = sqrt(estData(1,:,k).^2 + estData(4,:,k).^2 + estData(7,:,k).^2) ; 
end
D = mean(distances) ;

Time = time(2:end);

figure()
plot(Time, D)
grid on
legend('D')
xlabel('t, sec')
ylabel('A, m')