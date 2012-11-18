function [] = calculateRandomError(numberOfAircrafts)


N = 10000;
randomError = randn(N,6 * numberOfAircrafts);
savefile = 'mat-data/randomError.mat';
save(savefile, 'randomError');