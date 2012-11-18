function [ P, state_vector, K ] = kalman_filter( Z, state_vector, F, R, Q, H, P, extrapolate, gain_type, GAIN, n )
%KF_DISTANCES_ Summary of this function goes here
%   Detailed explanation goes here

I = eye(size(F,1)) ;
if n == 1
    Pp = P ;
else
    Pp = F * P * F.' + Q ; % Predicted (a priori) estimate covariance
end

if extrapolate == 1
    state_vector = F * state_vector ;
    P = Pp ;
    K = [] ;
else
    switch gain_type
        case 'real'
            K = Pp *H.' / (H * Pp * H.' + R); % Optimal Kalman gain
        case 'const'
            K = GAIN;
        otherwise
            warning('Unexpected Kalman gain type')
    end
    state_vector = F * state_vector + K * (Z - H * F * state_vector); % Updated (a posteriori) state estimate
    P = (I - K * H) * Pp;
end


end

