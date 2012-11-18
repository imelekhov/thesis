clc
clear all
close all

samples = 10^(5) ;

ksi_c = rand(samples, 1) ;
ksi_d = rand(samples, 1) ;

savefile_1 = 'mat-data/ksi_arrays.mat' ;
save(savefile_1, 'ksi_c', 'ksi_d') ;
