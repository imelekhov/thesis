function [ ] = plot_std_kf_d( std_vec, time, color, std_inform, filter_type )
%PLOT_STD_KF_D Summary of this function goes here
%   Detailed explanation goes here

time_to_plot = time(2:end) ;

figure()
plot(time_to_plot, std_vec, color, 'LineWidth', 2)
grid on
legend('std(D)')
switch filter_type
    case 'from_kf_c'
        title(['Coordinate filters: \sigma_{D_{pseudo}} = ', num2str(std_inform(1)), ' \sigma_V = ', num2str(std_inform(2))])
    case 'from_kf_d'
        title(['Distance filter: \sigma_D = ', num2str(std_inform)])
    otherwise
        warning('WarnTests:plot_std_kf_d', 'Unexpected kind of filter ')
end

xlabel('t, sec')
ylabel('A, m')

end

