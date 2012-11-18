function [] = plotCorrelationCoeffs( corrMtx, time, color)
%PLOTCORRELATIONCOEFFS Summary of this function goes here
%   Detailed explanation goes here

% corrMtx - is a correlation matrix 3 x 3 x size(t)

C12 = corrMtx(1,2,:) ./ (sqrt(corrMtx(1,1,:)) .* sqrt(corrMtx(2,2,:)));
C13 = corrMtx(1,3,:) ./ (sqrt(corrMtx(1,1,:)) .* sqrt(corrMtx(3,3,:)));
C23 = corrMtx(2,3,:) ./ (sqrt(corrMtx(2,2,:)) .* sqrt(corrMtx(3,3,:)));

figure()
plot(time, C12(:), color)
grid on
legend('C12')

figure()
plot(time, C13(:), color)
grid on
legend('C13')

figure()
plot(time, C23(:), color)
grid on
legend('C23')


end

