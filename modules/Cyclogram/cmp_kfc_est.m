addpath('../MeasureRelativeCoordinates/mat-data', ...
'../MeasureDistances/mat-data',               ...
'../Common/mat-data',                         ...
'tools') ;

load common.mat
load D_Vd_data.mat
load mat-data/est/kfc/est_rnd.mat

est_data_rnd_tmp = est_data_c ;
est_data_rnd_interp_mark = est_data_interp_mark ;

load mat-data/est/kfc/est_pkg.mat
est_data_pkg_tmp = est_data_c ;
est_data_pkg_interp_mark = est_data_interp_mark ;

load mat-data/est/kfc/est_ideal.mat
est_data_ideal_tmp = est_data_c ;

est_data_ideal = sqrt(est_data_ideal_tmp(1,:).^2 + est_data_ideal_tmp(4,:).^2 + est_data_ideal_tmp(7,:).^2) ;
est_data_rnd   = sqrt(est_data_rnd_tmp(1,:).^2 + est_data_rnd_tmp(4,:).^2 + est_data_rnd_tmp(7,:).^2) ;
est_data_pkg   = sqrt(est_data_pkg_tmp(1,:).^2 + est_data_pkg_tmp(4,:).^2 + est_data_pkg_tmp(7,:).^2) ;

est_data_ideal_vd = (est_data_ideal_tmp(1,:) .* est_data_ideal_tmp(2,:) + est_data_ideal_tmp(4,:) .* est_data_ideal_tmp(5,:) + est_data_ideal_tmp(7,:) .* est_data_ideal_tmp(8,:)) ./ est_data_ideal ;
est_data_rnd_vd = (est_data_rnd_tmp(1,:) .* est_data_rnd_tmp(2,:) + est_data_rnd_tmp(4,:) .* est_data_rnd_tmp(5,:) + est_data_rnd_tmp(7,:) .* est_data_rnd_tmp(8,:)) ./ est_data_rnd ;
est_data_pkg_vd = (est_data_pkg_tmp(1,:) .* est_data_pkg_tmp(2,:) + est_data_pkg_tmp(4,:) .* est_data_pkg_tmp(5,:) + est_data_pkg_tmp(7,:) .* est_data_pkg_tmp(8,:)) ./ est_data_pkg ;


Time = timeStart:timeStep:timeEnd ;
time = Time(2:end) ;
green  = [0.17 0.51 0.34] ; % green color

rel_est_ideal = est_data_ideal - D_ideal(2:end)' ;
rel_est_rnd   = est_data_rnd   - D_ideal(2:end)' ;
rel_est_pkg   = est_data_pkg   - D_ideal(2:end)' ;

rel_est_ideal_v = est_data_ideal_vd - Vd_ideal(2:end)' ;
rel_est_rnd_v   = est_data_rnd_vd   - Vd_ideal(2:end)' ;
rel_est_pkg_v   = est_data_pkg_vd   - Vd_ideal(2:end)' ;


[delta_D_rnd, idx_rnd] = max(abs(rel_est_ideal - rel_est_rnd)) ;
[delta_D_pkg, idx_pkg] = max(abs(rel_est_ideal - rel_est_pkg)) ;

std_rnd_whole_intrvl = std(rel_est_rnd) ;

[ idxs_rnd ] = find_idxs( rel_est_rnd, est_data_rnd_interp_mark ) ;
[ idxs_pkg ] = find_idxs( rel_est_pkg, est_data_pkg_interp_mark ) ;

idxs_cmn = 1:Time(end) + 1 ;
idxs_diff_rnd = setdiff(idxs_cmn, idxs_rnd) ; % data samples (without droppings)
idxs_diff_pkg = setdiff(idxs_cmn, idxs_pkg) ; % data samples (without droppings)

idxs_extrem_pkg = find(diff(idxs_diff_pkg) ~= 1) ; % localization droppings
std_bw_drops_pkg(1) = std(rel_est_pkg(idxs_diff_pkg(1:idxs_extrem_pkg(1)))) ;
num_smpls_per_interval_pkg(1) = length(1:idxs_extrem_pkg(1)) ;
for k = 1:length(idxs_extrem_pkg) - 1
    std_bw_drops_pkg(k+1) = std(rel_est_pkg(idxs_diff_pkg(idxs_extrem_pkg(k)+1:idxs_extrem_pkg(k+1)))) ;
    num_smpls_per_interval_pkg(k+1) = length(idxs_extrem_pkg(k)+1:idxs_extrem_pkg(k+1)) ;
end

idxs_extrem_rnd = find(diff(idxs_diff_rnd) ~= 1) ;
std_bw_drops_rnd(1) = std(rel_est_rnd(idxs_diff_rnd(1:idxs_extrem_rnd(1)))) ;
num_smpls_per_interval_rnd(1) = length(1:idxs_extrem_rnd(1)) ;
for k = 1:length(idxs_extrem_rnd) - 1
    std_bw_drops_rnd(k+1) = std(rel_est_rnd(idxs_diff_rnd(idxs_extrem_rnd(k)+1:idxs_extrem_rnd(k+1)))) ;
    num_smpls_per_interval_rnd(k+1) = length(idxs_extrem_rnd(k)+1:idxs_extrem_rnd(k+1)) ;
end

%[ std_rnd ]  = std_bw_drops( rel_est_rnd, idxs_rnd ) ;

max_diff_D_rnd = max(abs(rel_est_ideal - rel_est_rnd)) ;
max_diff_D_pkg = max(abs(rel_est_ideal - rel_est_pkg)) ;

format_spec_title = 'Random droppings:\n' ;
format_spec_delta_D = 'max delta_D is %7.4f \n' ;
format_spec_std_interval_title = 'std on the intervals between droppings:\n' ;
format_spec_std_interval = '%2d | %7.4f | %3d \n' ;
fprintf(format_spec_title) ;
fprintf(format_spec_delta_D, max_diff_D_rnd) ;
fprintf(format_spec_std_interval_title) ;
fprintf(format_spec_std_interval, [1:length(std_bw_drops_rnd); std_bw_drops_rnd; num_smpls_per_interval_rnd]) ;

format_spec_title = 'Package droppings:\n' ;
format_spec_delta_D = 'max delta_D is %7.4f \n' ;
format_spec_std_interval_title = 'std on the intervals between droppings:\n' ;
format_spec_std_interval = '%2d | %7.4f | %3d \n' ;
fprintf('=============================================\n') ;
fprintf(format_spec_title) ;
fprintf(format_spec_delta_D, max_diff_D_pkg) ;
fprintf(format_spec_std_interval_title) ;
fprintf(format_spec_std_interval, [1:length(std_bw_drops_pkg); std_bw_drops_pkg; num_smpls_per_interval_pkg]) ;


figure()
plot(time, rel_est_ideal)
hold on
plot(time, rel_est_rnd, 'r')
plot(time, rel_est_pkg, 'Color', green)
plot(time(idxs_rnd), rel_est_rnd(idxs_rnd), 'sq', 'MarkerEdgeColor','k', 'MarkerFaceColor','c', 'MarkerSize', 5)
plot(time(idxs_pkg), rel_est_pkg(idxs_pkg), 'sq', 'MarkerEdgeColor','k', 'MarkerFaceColor','r', 'MarkerSize', 5)
grid on
xlabel('t, s')
ylabel('\delta D, m')
legend('without droppings', 'rnd droppings', 'pkg droppings')

figure()
plot(time, rel_est_ideal_v)
hold on
plot(time, rel_est_rnd_v, 'r')
plot(time, rel_est_pkg_v, 'Color', green)
plot(time(idxs_rnd), rel_est_rnd_v(idxs_rnd), 'sq', 'MarkerEdgeColor','k', 'MarkerFaceColor','c', 'MarkerSize', 5)
plot(time(idxs_pkg), rel_est_pkg_v(idxs_pkg), 'sq', 'MarkerEdgeColor','k', 'MarkerFaceColor','r', 'MarkerSize', 5)
grid on
xlabel('t, s')
ylabel('\delta Vd, m/s')
legend('without droppings', 'rnd droppings', 'pkg droppings')