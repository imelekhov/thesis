clc
clear all
close all

addpath( '../Common/mat-data',                     ...
         '../MeasureRelativeCoordinates/mat-data', ...
         '../GetNoise/mat-data',                   ...
         'mat-data', 'tools') ;
     
load coordLCSIdeal.mat ;
load noise_D.mat ;
load common.mat

%sigma_D = 25 ;
sigma_D = 9 ;

X = coordLCSIdeal(:,1) ;
Y = coordLCSIdeal(:,2) ;
Z = coordLCSIdeal(:,3) ;

Vx = coordLCSIdeal(:,4) ;
Vy = coordLCSIdeal(:,5) ;
Vz = coordLCSIdeal(:,6) ;
D_ideal = sqrt(X.^2 + Y.^2 + Z.^2) ;
Vd_ideal = (X .* Vx + Y .* Vy + Z .* Vz) ./ D_ideal;

start_idx = 160 ;

number_of_flights = 1 ;

D_noisy = zeros(size(D_ideal,1), 1, number_of_flights) ; % 3D array: 151x1x1000
for k = 1:number_of_flights
    step_on_loop_lower_bound = (k - 1) * size(D_ideal,1) ;
    step_on_loop_upper_bound = k * size(D_ideal,1) ;
    %nn(:,:,k) = sigma_D .* noise_D(start_idx + step_on_loop_lower_bound:start_idx + step_on_loop_upper_bound - 1) ;
    D_noisy(:,:,k) = D_ideal + sigma_D .* noise_D(start_idx + step_on_loop_lower_bound:start_idx + step_on_loop_upper_bound - 1) ;
end

savefile = 'mat-data/D_Vd_data.mat' ;
save(savefile, 'D_ideal', 'Vd_ideal', 'D_noisy', 'sigma_D') ;