function [out] = calcAbsoluteCoordinates(initCoord, Psi, Vh, Vhrz, Time)

%% descriptions
% initCoord is a matrix Nx3 
% Psi is a column vector Nx1
% Vh is a column vector Nx1
% Vhrz is a matrix NxM
% Time is a row vector 1xM

%% main calculation

%addpath('tools')

numberOfAircrafts = size(initCoord,1);
%output = zeros(length(Time) - 1, 3 * numberOfAircrafts);
output = zeros(length(Time), 3 * numberOfAircrafts);

if (size(Vhrz,2) ~= size(Time,2))
    Time = Time.';
end

out = [];
n = 1;
for k = 1:numberOfAircrafts
    %[~, output(:, n:3*k)] = ode45(@(t,y) rigid(t, y, Psi(k), Vh(k), Vhrz(k,:), Time), Time(2:end), initCoord(k,:));
    [~, output(:, n:3*k)] = ode45(@(t,y) rigid(t, y, Psi(k), Vh(k), Vhrz(k,:), Time), Time, initCoord(k,:));
    Vnorth = Vhrz(k,:).' .* cos(Psi(k,:).');
    Veast = Vhrz(k,:).' .* sin(Psi(k,:).');
    Vvert = Vh(k) .* ones(size(output,1),1);
    out = [out output(:, n:3*k) Vnorth Veast Vvert];
    n = n + 3; % 3 because we calculate three parameters: H, phi and lambda
end