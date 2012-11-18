function [P, state_vector, K] = kf_distance(Z, state_vector, F, R, Q, H, P, n)

I = eye(size(F,1)) ;
if 1 == n
    Pp = P ;
else
    Pp = F * P * F.' + Q ; % Predicted (a priori) estimate covariance
end

K = Pp * H.' / (H *Pp * H.' + R) ; % Optimal Kalman gain
state_vector = F * state_vector + K * (Z - H * F * state_vector); % Updated (a posteriori) state estimate
P = (I - K * H)*Pp;
