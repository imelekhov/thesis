function [ F, Q, H, R, P ] = initialisationKalmanFilter(filterType, sigmaVec, Tk)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% structure of measurements: [X Y Z VxLoc VyLoc VzLoc];
% structure of measurements3: [X VxLoc] [Y VyLoc] [Z VzLoc];
% structure of stateVector1: [X Vx ax Y Vy ay Z Vz az];
% structure of stateVector2: [X Vx Y Vy Z Vz];
% structure of stateVector3: [X Vx ax] [Y Vy ay] [Z Vz az];
% sigmaVec = [sigmaX sigmaY sigmaZ sigmaVx sigmaVy sigmaVz]

L = 10000;
switch filterType
    case 'common_accel'
        Felem = [1 Tk 0.5*Tk^2; 0 1 Tk; 0 0 1];
        Qelem = [(Tk^5)/20 (Tk^4)/8 (Tk^3)/6; (Tk^4)/8 (Tk^3)/3 (Tk^2)/2; (Tk^3)/6 (Tk^2)/2 Tk];
        F = [Felem zeros(3,6); zeros(3) Felem zeros(3); zeros(3,6) Felem];
        Q = [Qelem zeros(3,6); zeros(3) Qelem zeros(3); zeros(3,6) Qelem];
        H = [1 zeros(1,8); zeros(1,3) 1 zeros(1,5); zeros(1,6) 1 0 0; 0 1 zeros(1,7); zeros(1,4) 1 zeros(1,4); zeros(1,7) 1 0];
        R = diag([sigmaVec(1)^2 sigmaVec(2)^2 sigmaVec(3)^2 sigmaVec(4)^2 sigmaVec(5)^2 sigmaVec(6)^2]);
        P = L .* eye(9);
    case 'common_zero_accel'
        Felem = [1 Tk ; 0 1];
        Qelem = [];
        F = [Felem zeros(2,4); zeros(2) Felem zeros(2); zeros(2,4) Felem];
        Q = [Qelem zeros(2,4); zeros(2) Qelem zeros(2); zeros(2,4) Qelem];
        H = [1 zeros(1,5); zeros(1,2) 1 zeros(1,3); zeros(1,4) 1 0; 0 1 zeros(1,4); zeros(1,3) 1 zeros(1,2); zeros(1,5) 1];
        R = diag([sigmaVec(1)^2 sigmaVec(2)^2 sigmaVec(3)^2 sigmaVec(4)^2 sigmaVec(5)^2 sigmaVec(6)^2]);
        P = L .* eye(6);
    case 'three_separate_accel'
        F = [1 Tk 0.5*Tk^2; 0 1 Tk; 0 0 1];
        Q = [(Tk^5)/20 (Tk^4)/8 (Tk^3)/6; (Tk^4)/8 (Tk^3)/3 (Tk^2)/2; (Tk^3)/6 (Tk^2)/2 Tk];
        H = [1 0 0; 0 1 0];
        R1 = diag([sigmaVec(1)^2 sigmaVec(4)^2]);
        R2 = diag([sigmaVec(2)^2 sigmaVec(5)^2]);
        R3 = diag([sigmaVec(3)^2 sigmaVec(6)^2]);
        R = [R1; R2; R3];
        P = L .* eye(3);
    case 'correlated_error'
        Felem = [1 Tk 0.5*Tk^2; 0 1 Tk; 0 0 1];
        Qelem = [(Tk^5)/20 (Tk^4)/8 (Tk^3)/6; (Tk^4)/8 (Tk^3)/3 (Tk^2)/2; (Tk^3)/6 (Tk^2)/2 Tk];
        %F = [Felem zeros(3,6); zeros(3) Felem zeros(3); zeros(3,6) Felem];
        F = blkdiag(Felem,Felem,Felem);
        %Q = [Qelem zeros(3,6); zeros(3) Qelem zeros(3); zeros(3,6) Qelem];
        Q = blkdiag(Qelem,Qelem,Qelem);
        H = [1 zeros(1,8); zeros(1,3) 1 zeros(1,5); zeros(1,6) 1 0 0; 0 1 zeros(1,7); zeros(1,4) 1 zeros(1,4); zeros(1,7) 1 0];
        R = 0;
        P = L .* eye(9);
    case 'correlated_test'
        Felem = [1 Tk 0.5*Tk^2; 0 1 Tk; 0 0 1];
        Qelem = [(Tk^5)/20 (Tk^4)/8 (Tk^3)/6; (Tk^4)/8 (Tk^3)/3 (Tk^2)/2; (Tk^3)/6 (Tk^2)/2 Tk];
        F = blkdiag(Felem,Felem,Felem);
        Q = blkdiag(Qelem,Qelem,Qelem);
        H = [1 zeros(1,8); zeros(1,3) 1 zeros(1,5); zeros(1,6) 1 0 0];
        R = 0;
        P = L .* eye(9);
    otherwise
            warning('WarnTEST:initialisationKalmanFilter', 'Unexpected Kalman filter type')
end

end

