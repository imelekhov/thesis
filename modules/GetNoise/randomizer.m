clc
clear all
close all

addpath('mat-data') ;

samples = 10^(6) ;

noise_D = randn(samples, 1) ;

savefile_1 = 'mat-data/noise_D.mat';
save(savefile_1, 'noise_D');
