function [ F, Q ] = re_init_kf_c( filterType, Tk )

% structure of measurements: [X Y Z VxLoc VyLoc VzLoc];
% structure of measurements3: [X VxLoc] [Y VyLoc] [Z VzLoc];
% structure of stateVector1: [X Vx ax Y Vy ay Z Vz az];
% structure of stateVector2: [X Vx Y Vy Z Vz];
% structure of stateVector3: [X Vx ax] [Y Vy ay] [Z Vz az];
% sigmaVec = [sigmaX sigmaY sigmaZ sigmaVx sigmaVy sigmaVz]

switch filterType
    case 'common_accel'
        Felem = [1 Tk 0.5*Tk^2; 0 1 Tk; 0 0 1];
        Qelem = [(Tk^5)/20 (Tk^4)/8 (Tk^3)/6; (Tk^4)/8 (Tk^3)/3 (Tk^2)/2; (Tk^3)/6 (Tk^2)/2 Tk];
        F = [Felem zeros(3,6); zeros(3) Felem zeros(3); zeros(3,6) Felem];
        Q = [Qelem zeros(3,6); zeros(3) Qelem zeros(3); zeros(3,6) Qelem];
    case 'common_zero_accel'
        Felem = [1 Tk ; 0 1];
        Qelem = [];
        F = [Felem zeros(2,4); zeros(2) Felem zeros(2); zeros(2,4) Felem];
        Q = [Qelem zeros(2,4); zeros(2) Qelem zeros(2); zeros(2,4) Qelem];
    case 'three_separate_accel'
        F = [1 Tk 0.5*Tk^2; 0 1 Tk; 0 0 1];
        Q = [(Tk^5)/20 (Tk^4)/8 (Tk^3)/6; (Tk^4)/8 (Tk^3)/3 (Tk^2)/2; (Tk^3)/6 (Tk^2)/2 Tk];
    case 'correlated_error'
        Felem = [1 Tk 0.5*Tk^2; 0 1 Tk; 0 0 1];
        Qelem = [(Tk^5)/20 (Tk^4)/8 (Tk^3)/6; (Tk^4)/8 (Tk^3)/3 (Tk^2)/2; (Tk^3)/6 (Tk^2)/2 Tk];
        F = blkdiag(Felem,Felem,Felem);
        Q = blkdiag(Qelem,Qelem,Qelem);
    case 'correlated_test'
        Felem = [1 Tk 0.5*Tk^2; 0 1 Tk; 0 0 1];
        Qelem = [(Tk^5)/20 (Tk^4)/8 (Tk^3)/6; (Tk^4)/8 (Tk^3)/3 (Tk^2)/2; (Tk^3)/6 (Tk^2)/2 Tk];
        F = blkdiag(Felem,Felem,Felem);
        Q = blkdiag(Qelem,Qelem,Qelem);
    otherwise
            warning('WarnTEST:initialisationKalmanFilter', 'Unexpected Kalman filter type')
end

end
