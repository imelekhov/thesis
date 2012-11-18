function [ mean_vec, std_vec ] = error_calculation_kf_d( ideal_data_in, est_data, kind_of_filter_data_received )
%ERROR_CALCULATION_KF_D Summary of this function goes here
%   Detailed explanation goes here

% Description:
% ideal_data_in is a matrix [N x m], where m is a parameter depends on type
% of filter (for coordinates filter it equals 3)
%           (for distance filter    it equals 1) 

switch kind_of_filter_data_received
    case 'from_kf_c'
        est_data_prep = sqrt(est_data(1,:,:).^2 + est_data(4,:,:).^2 + est_data(7,:,:).^2) ;
        ideal_data = sqrt(ideal_data_in(:,1).^2 + ideal_data_in(:,2).^2 + ideal_data_in(:,3).^2) ;
    case 'from_kf_d'
        est_data_prep = est_data(1,:,:) ;
        ideal_data = ideal_data_in ;
    otherwise
        warning('WarnTests:error_calculation_kf_d', 'Unexpected kind of filter ')
end

differ_data = zeros(size(est_data_prep)) ;
for k = 1:size(est_data, 3)
    differ_data(:,:,k) = est_data_prep(:,:,k) - ideal_data(2:end).' ;
end

mean_vec = mean(differ_data, 3) ;
std_vec = sqrt(mean(differ_data.^2, 3) - mean_vec.^2) ;

end

