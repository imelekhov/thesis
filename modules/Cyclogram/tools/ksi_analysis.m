function [ksi_rx, ksi_lost, time_rx, time_lost] = ksi_analysis(ksi_array, ksi_start, Time, Prob)

ksi = ksi_array(ksi_start:ksi_start + length(Time) - 1) ;
ksi_rx   = ones(1, length(ksi(ksi > Prob))) ;
ksi_lost = zeros(1, length(ksi(ksi <= Prob))) ;
time_rx = Time(ksi > Prob) ;
time_lost = Time(ksi <= Prob) ;
