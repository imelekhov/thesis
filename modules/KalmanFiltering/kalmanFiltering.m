clear all
%close all
%clc

addpath('../MeasureRelativeCoordinates/mat-data', ...
        '../Ephemeris/mat-data',                  ...
        '../CorrNoiseExper/mat-data',             ...
        '../MeasureDistances/mat-data',           ...
        '../Common/mat-data',                     ...
        'mat-data', 'tools');

load 'calculatedCorrMtx.mat'    
load 'measuredCoordLCS.mat'
load 'coordLCSIdeal.mat'
load 'sigmaDV.mat'
load 'D_Vd_data.mat'
load 'common.mat'

load 'corrMtxENU.mat'
load 'measENU.mat'
load 'constK.mat'

% load 'numberOfFlights.mat'

time = 0:size(measuredCoordLCS,1) - 1;

Tk = 1;
%filterType = 'correlated_test';
filterType = 'correlated_error';
%filterType = 'common_accel';
sigmaX = 9;
sigmaY = sigmaX;
sigmaZ = sigmaX;
sigmaVx = 0.1;
sigmaVy = 0.12;
sigmaVz = 0.1;
sigmaVec = [sigmaX sigmaY sigmaZ sigmaVx sigmaVy sigmaVz];

is_distance_filter = 1 ;

[ F, Q, H, R, P ] = initialisationKalmanFilter(filterType, sigmaVec, Tk) ;
[ Fd, Qd, Hd, Rd, Pd ] = initialisationDistanceFilter(sigma_D, Tk) ;
sigmaQ = 10^(-8);
Q = sigmaQ .* Q ;


% structure of measurements for coordinate filter: [X Y Z VxLoc VyLoc VzLoc] ;
% structure of state_vector for coordinate filter: [X Vx ax Y Vy ay Z Vz az] ;
%stateVector = zeros(9,1);
% structure of measurements for distance filter: [D] ;
% structure of state_vector for distance filter: [D Vd ad] ;
stateVector = [measuredCoordLCS(1,1); measuredCoordLCS(1,4); 0; ...
               measuredCoordLCS(1,2); measuredCoordLCS(1,5); 0; ...
               measuredCoordLCS(1,3); measuredCoordLCS(1,6); 0];

KalmanGainType = 'real';
%KalmanGainType = 'const';

switch filterType
    case 'common_accel'
        for k = 1:length(time) - 1
           [P, stateVector, K] = kalmanFilter(measuredCoordLCS(k+1,:).', stateVector, F, R, Q, H, P, KalmanGainType, k);
           estData = [estData stateVector];
           gainK = [gainK K];
        end
        
        doPlot(coordLCSIdeal, estData, time);
        doPlotCompared(measuredCoordLCS, estData, time)
        
    case 'three_separate_accel'
        R1 = R(1:2,:);
        R2 = R(3:4,:);
        R3 = R(5:6,:);
        P1 = P;
        P2 = P;
        P3 = P;
        stateVector1 = zeros(3,1);
        stateVector2 = zeros(3,1);
        stateVector3 = zeros(3,1);
        estData1 = [];
        estData2 = [];
        estData3 = [];
        for k = 1:length(time) - 1
            [P1, stateVector1, K1] = kalmanFilter([measuredCoordLCS(k+1,1) measuredCoordLCS(k+1,4)].', stateVector1, F, R1, Q, H, P1, KalmanGainType, k);
            [P2, stateVector2, K2] = kalmanFilter([measuredCoordLCS(k+1,2) measuredCoordLCS(k+1,5)].', stateVector2, F, R2, Q, H, P2, KalmanGainType, k);
            [P3, stateVector3, K3] = kalmanFilter([measuredCoordLCS(k+1,3) measuredCoordLCS(k+1,6)].', stateVector3, F, R3, Q, H, P3, KalmanGainType, k);
            estData1 = [estData1 stateVector1];
            estData2 = [estData2 stateVector2];
            estData3 = [estData3 stateVector3];
        end
        
    case 'correlated_error'
        %sigmaVec = [sigmaX sigmaY sigmaZ sigmaVx sigmaVy sigmaVz];
        %R = diag([sigmaX^2 sigmaY^2 sigmaZ^2 sigmaVx^2 sigmaVy^2 sigmaVz^2]);
        %Rx = diag([mean(corrMtxUVWxyz(1,1,:)) mean(corrMtxUVWxyz(2,2,:)) mean(corrMtxUVWxyz(3,3,:))]);
        %Rv = diag([mean(corrMtxUVWv(1,1,:)) mean(corrMtxUVWv(2,2,:)) mean(corrMtxUVWv(3,3,:))]);
        %            Rv = diag([corrMtxUVWv(1,1,1) corrMtxUVWv(2,2,1) corrMtxUVWv(3,3,1)]);
        %            Rx = diag([corrMtxUVWxyz(1,1,1) corrMtxUVWxyz(2,2,1) corrMtxUVWxyz(3,3,1)]);
        %R = blkdiag(Rx,Rv);
        
        %for k = 1:length(time) - 1
        estData = zeros(size(F,1),length(time) - 1, number_of_flights);
        gainK = zeros(size(GAIN,1), size(GAIN,2), length(time) - 1, number_of_flights);
        
        % distance filter
        est_data_kf_d = zeros(size(Fd,1), length(time) - 1, number_of_flights) ;
        for p = 1:number_of_flights
        
            [ F, Q, H, ~, P ] = initialisationKalmanFilter(filterType, sigmaVec, Tk);
            sigmaQ = 10^(-6);
            Q = sigmaQ.*Q;
            %Rx = diag([mean(corrMtxUVWxyz(1,1,:)) mean(corrMtxUVWxyz(2,2,:)) mean(corrMtxUVWxyz(3,3,:))]);
            %Rv = diag([mean(corrMtxUVWv(1,1,:)) mean(corrMtxUVWv(2,2,:)) mean(corrMtxUVWv(3,3,:))]);
            %R = blkdiag(Rx,Rv);
         
            stateVector = [measuredCoordLCS(1,1,p); measuredCoordLCS(1,4,p); 0; ...
                           measuredCoordLCS(1,2,p); measuredCoordLCS(1,5,p); 0; ...
                           measuredCoordLCS(1,3,p); measuredCoordLCS(1,6,p); 0] ;
            
            if (is_distance_filter)
                [ Fd, Qd, Hd, Rd, Pd ] = initialisationDistanceFilter(sigma_D, Tk) ;
                sigmaQ_kf_d = 10^(-6) ;
                Qd = sigmaQ_kf_d .* Qd ;
                state_vector_D = [D_noisy(1,1,p); 0; 0] ;
            end
            
           
            for k = 1:length(time) - 1
            
                Rx = corrMtxUVWxyz(:,:,k);
                Rv = corrMtxUVWv(:,:,k);
                %Rx = diag([corrMtxUVWxyz(1,1,k) corrMtxUVWxyz(2,2,k) corrMtxUVWxyz(3,3,k)]);
                %Rv = diag([corrMtxUVWv(1,1,k) corrMtxUVWv(2,2,k) corrMtxUVWv(3,3,k)]);
                
                R = blkdiag(Rx,Rv);
             
                %[P, stateVector, K] = kalmanFilter(measuredCoordLCS(k+1,:).', stateVector, F, R, Q, H, P, KalmanGainType, k);
                [P, stateVector, K] = kalmanFilter(measuredCoordLCS(k+1,:,p).', stateVector, F, R, Q, H, P, KalmanGainType, GAIN, k);
                estData(:,k,p) = stateVector;
                gainK(:,:,k,p) = K;
                
                if (is_distance_filter)
                    [Pd, state_vector_D, Kd] = kf_distance(D_noisy(k+1,:,p), state_vector_D, Fd, Rd, Qd, Hd, Pd, k) ;
                    est_data_kf_d(:,k,p) = state_vector_D ;
                end
            end
        end
        
        %doPlot(coordLCSIdeal, estData, time);
        cutOff = 1;
        %errorCalculationEUROCONTROL( coordLCSIdeal, estData, cutOff );
        %doPlotDiffer(coordLCSIdeal, mean(estData,3), time, 'r', sigmaD, sigmaV);
        %savefigs('../../Png/CorrelatedNoise_KF_results/sigX_6_sigV_009/')
        %[meanVal, stdVal] = errorCalculationCorrelated( coordLCSIdeal, mean(estData,3), 'notmean' );
        [mean_kf_c, std_kf_c] = errorCalculationCorrelated( coordLCSIdeal, estData, 'mean' ) ;
        plot_std_kf_c(std_kf_c, time, 'r', [sigmaD sigmaV]) ;
        [mean_kf_d_from_c, std_kf_d_from_c] = error_calculation_kf_d( coordLCSIdeal, estData, 'from_kf_c' ) ;
        doPlotDistances(estData, time) ;
        plot_std_kf_d(std_kf_d_from_c, time, 'r', [sigmaD sigmaV], 'from_kf_c' )
                
        if (is_distance_filter)
            [mean_kf_d, std_kf_d] = error_calculation_kf_d( D_ideal, est_data_kf_d, 'from_kf_d' );
            plot_std_kf_d(std_kf_d, time, 'b', sigma_D, 'from_kf_d');
            distances = est_data_kf_d(1,:,:) ;
            D_est = mean(distances,3) ;
            Time = time(2:end);
            figure()
            %plot(Time, D_ideal(2:end).')
            plot(Time, D_est)
            grid on
            legend('D')
            xlabel('t, sec')
            ylabel('A, m')
        end
        
    case 'correlated_test' 
        
        stdVec = [9 9 15];
        
        R = diag(stdVec.^2);
        for k = 1:length(time)
            %R = corrMtxENU(:,:,k);
            [P, stateVector, K] = kalmanFilter(measENU(:,k), stateVector, F, R, Q, H, P, KalmanGainType, k);
            estData = [estData stateVector];
            gainK = [gainK K];
        end
        
        
        doPlotComparedENU(measENU, estData, time)
        
end


