function [output] = calcVelocityLaw(Vhrz0, a0, tAccel, tStep, vStep, Time, is_turn, psi_in)

%% main calculation
% 
% numberOfAircrafts = size(Vhrz0, 1);
% 
% output = zeros(numberOfAircrafts, length(Time));
% for k = 1:numberOfAircrafts
%     output(k,:) = Vhrz0(k).*ones(1,length(Time));
% end

if (1 && all(tAccel == 0) && all(tStep == 0) && ~is_turn)
    output = Vhrz0 .* ones(1, length(Time)); % V(0) exists
elseif (1 && all(tAccel == 0) && all(tStep ~= 0))
    uniformInterval = Vhrz0 .* ones(1, length(Time) - length(tStep));
    stepInterval = vStep .* ones(1, length(tStep));
    output = [uniformInterval stepInterval];
elseif (is_turn)
    omega = 1.6  ;
%     R_turn = 1500 ; % in m
%     [ output ] = standard_turn([Vhrz0 250], [0 0], omega, R_turn, Time) ;
    %[x, y, t, vvx, vvy, N, xc, yc, psi_out] = standartTurnFromUniformPlane(t0, t1, dt, vx_plane, vy_plane, x0, y0, vx, vy, w, psi_in)
    dt = abs(Time(1) - Time(2)) ;
    [x, y, t, vvx, vvy, N, xc, yc, psi_out] = standartTurnFromUniformPlane(Time(1), Time(end), dt, 250, 0, 0.0005*180*111.1/pi, -0.0005*180*111.1/pi, Vhrz0, 0, omega, psi_in*180/pi) ;
    output = [[Vhrz0 sqrt(vvx.^2 + vvy.^2)]; psi_out*pi/180] ;
else
    %accelDuration = tAccel(2) - tAccel(1);
    if (tAccel(1) == Time(2) && tAccel(end) == Time(end)) % cause Time(1) = 0
        accelInterval = Vhrz0 + a0 .* (tAccel(1):tAccel(2));
        output = [Vhrz0 accelInterval];
    elseif (tAccel(1) == Time(2) && tAccel(end) ~= Time(end))
        uniformDuration = Time(end) - tAccel(end);
        accelInterval = Vhrz0 + a0 .* (tAccel(1):tAccel(end));
        uniformInterval = accelInterval(end) .* ones(1, uniformDuration);
        output = [Vhrz0 accelInterval uniformInterval];
    elseif (tAccel(1) ~= Time(2) && tAccel(end) == Time(end))
        uniformDuration = length(Time(2):tAccel(1));
        uniformInterval = Vhrz0 .* ones(1, uniformDuration);
        accelInterval = uniformInterval(end) + a0 .* (tAccel(1):tAccel(end));
        output = [Vhrz0 uniformInterval accelInterval];
    else
        accStart = tAccel(1);
        accEnd = tAccel(end);
        accelDuration = accEnd - accStart;
        accInterval = 0:accelDuration;
        uniformDuration_1 = length(Time(2):(accStart - 1));
        uniformDuration_2 = length((accEnd + 1):Time(end)); % !!! "-1" is needed
        VhrzUniform_1 = Vhrz0 .* ones(1, uniformDuration_1);
        VhrzAccel = VhrzUniform_1(end) + a0 .* accInterval; %(tAccel(2):tAccel(end));
        VhrzUniform_2 = VhrzAccel(end) .* ones(1, uniformDuration_2);
        output = [Vhrz0 VhrzUniform_1 VhrzAccel VhrzUniform_2];
    end
    %uniformInterval = Vhrz0 .* ones(1, length(Time) - accelDuration);
end
%output = Vhrz0.*ones(numberOfAircrafts, length(Time));