function [P, stateVector, K] = kalmanFilter(Z, stateVector, F, R, Q, H, P, KalmanGainType, GAIN, n)

I = eye(size(F,1));
if 1 == n
    Pp = P;
else
    Pp = F * P * F.' + Q; % Predicted (a priori) estimate covariance
end

switch KalmanGainType
    case 'real'
        K = Pp*H.'/ (H * Pp * H.' + R); % Optimal Kalman gain
    case 'const'
%         if n == 1
%             addpath('mat-data')
%             load 'constK.mat'
%         end
        K = GAIN;
    otherwise
        warning('Unexpected Kalman gain type')
end
        
stateVector = F * stateVector + K * (Z - H * F * stateVector); % Updated (a posteriori) state estimate
P = (I - K * H) * Pp;

