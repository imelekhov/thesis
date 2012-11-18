function [ F, Q, H, R, P ] = initialisationDistanceFilter( sigma_D, Tk )
%INITIALISATIONDISTANCEFILTER Summary of this function goes here
%   Detailed explanation goes here

%% Description
% x = [D Vd ad] - state vector

%%
L = 10000 ;
F = [1 Tk 0.5*(Tk^2); 0 1 Tk; 0 0 1] ;
%F = [1 Tk ; 0 1] ;

Q = [(Tk^5)/20 (Tk^4)/8 (Tk^3)/6; (Tk^4)/8 (Tk^3)/3 (Tk^2)/2; (Tk^3)/6 (Tk^2)/2 Tk];
%Q = [(Tk^3)/3 (Tk^2)/2 ; (Tk^2)/2 Tk];
H = [1 0 0] ;
%H = [1 0 ] ;
R = sigma_D^2 ;
%P = diag(L .* ones(size(H,1), 1)) ;
P = L .* eye(size(F,1)) ;

end