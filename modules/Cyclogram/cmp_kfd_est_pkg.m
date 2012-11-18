addpath('../MeasureRelativeCoordinates/mat-data', ...
'../MeasureDistances/mat-data',               ...
'../Common/mat-data',                         ...
'tools') ;

load common.mat
load D_Vd_data.mat

load mat-data/est/kfd/est_ideal.mat
est_data_ideal = est_data_d ;

load mat-data/est/kfd/est_pkg.mat
load mat-data/gains/kfd/gain_pkg.mat
est_data_pkg = est_data_d ;
est_data_pkg_interp_mark = est_data_interp_mark ;
K_d_vec_pkg  = K_d_vec ; 

load mat-data/est/const/kfd/pkg/est_18_132_0.mat
est_data_pkg_18_132_0 = est_data_d ;
est_data_pkg_interp_mark_18_132_0 = est_data_interp_mark ;

load mat-data/est/const/kfd/pkg/est_15_132_0.mat
est_data_pkg_15_132_0 = est_data_d ;
est_data_pkg_interp_mark_15_132_0 = est_data_interp_mark ;

load mat-data/est/const/kfd/pkg/est_15_18_0.mat
est_data_pkg_15_18_0 = est_data_d ;
est_data_pkg_interp_mark_15_18_0 = est_data_interp_mark ;

load mat-data/est/const/kfd/pkg/est_14_132_0.mat
est_data_pkg_14_132_0 = est_data_d ;
est_data_pkg_interp_mark_14_132_0 = est_data_interp_mark ;

load mat-data/est/const/kfd/pkg/est_12_132_0.mat
est_data_pkg_12_132_0 = est_data_d ;
est_data_pkg_interp_mark_12_132_0 = est_data_interp_mark ;

load mat-data/est/const/kfd/pkg/est_12_18_0.mat
est_data_pkg_12_18_0 = est_data_d ;
est_data_pkg_interp_mark_12_18_0 = est_data_interp_mark ;


Time = timeStart:timeStep:timeEnd ;
time = Time(2:end) ;
green  = [0.17 0.51 0.34] ; % green color



rel_est_ideal        = est_data_ideal(1,:)        - D_ideal(2:end)' ;
rel_est_pkg          = est_data_pkg(1,:)          - D_ideal(2:end)' ;
rel_est_pkg_18_132_0 = est_data_pkg_18_132_0(1,:) - D_ideal(2:end)' ;
rel_est_pkg_15_132_0 = est_data_pkg_15_132_0(1,:) - D_ideal(2:end)' ;
rel_est_pkg_15_18_0  = est_data_pkg_15_18_0(1,:)  - D_ideal(2:end)' ;
rel_est_pkg_14_132_0 = est_data_pkg_14_132_0(1,:) - D_ideal(2:end)' ;
rel_est_pkg_12_132_0 = est_data_pkg_12_132_0(1,:) - D_ideal(2:end)' ;
rel_est_pkg_12_18_0  = est_data_pkg_12_18_0(1,:)  - D_ideal(2:end)' ;

rel_est_pkg_v_ideal    = est_data_ideal(2,:)        - Vd_ideal(2:end)' ;
rel_est_pkg_v          = est_data_pkg(2,:)          - Vd_ideal(2:end)' ;
rel_est_pkg_v_18_132_0 = est_data_pkg_18_132_0(2,:) - Vd_ideal(2:end)' ;
rel_est_pkg_v_15_132_0 = est_data_pkg_15_132_0(2,:) - Vd_ideal(2:end)' ;
rel_est_pkg_v_15_18_0  = est_data_pkg_15_18_0(2,:)  - Vd_ideal(2:end)' ;
rel_est_pkg_v_14_132_0 = est_data_pkg_14_132_0(2,:) - Vd_ideal(2:end)' ;
rel_est_pkg_v_12_132_0 = est_data_pkg_12_132_0(2,:) - Vd_ideal(2:end)' ;
rel_est_pkg_v_12_18_0  = est_data_pkg_12_18_0(2,:)  - Vd_ideal(2:end)' ;

[delta_D_pkg, idx_pkg]                   = max(abs(rel_est_ideal - rel_est_pkg)) ;
[delta_D_pkg_18_132_0, idx_pkg_18_132_0] = max(abs(rel_est_ideal - rel_est_pkg_18_132_0)) ;
[delta_D_pkg_15_132_0, idx_pkg_15_132_0] = max(abs(rel_est_ideal - rel_est_pkg_15_132_0)) ;
[delta_D_pkg_15_18_0, idx_pkg_15_18_0]   = max(abs(rel_est_ideal - rel_est_pkg_15_18_0)) ;
[delta_D_pkg_14_132_0, idx_pkg_14_132_0] = max(abs(rel_est_ideal - rel_est_pkg_14_132_0)) ;
[delta_D_pkg_12_132_0, idx_pkg_12_132_0] = max(abs(rel_est_ideal - rel_est_pkg_12_132_0)) ;
[delta_D_pkg_12_18_0, idx_pkg_12_18_0]   = max(abs(rel_est_ideal - rel_est_pkg_12_18_0)) ;

[ idxs_pkg ] = find_idxs( rel_est_pkg, est_data_pkg_interp_mark ) ;

idxs_cmn = 1:Time(end) + 1 ;
idxs_diff_pkg = setdiff(idxs_cmn, idxs_pkg) ; % data samples (without droppings)

idxs_extrem_pkg = find(diff(idxs_diff_pkg) ~= 1) ; % localization droppings
std_bw_drops_pkg(1) = std(rel_est_pkg(idxs_diff_pkg(1:idxs_extrem_pkg(1)))) ;
std_bw_drops_pkg_18_132_0(1) = std(rel_est_pkg_18_132_0(idxs_diff_pkg(1:idxs_extrem_pkg(1)))) ;
std_bw_drops_pkg_15_132_0(1) = std(rel_est_pkg_15_132_0(idxs_diff_pkg(1:idxs_extrem_pkg(1)))) ;
std_bw_drops_pkg_15_18_0(1) = std(rel_est_pkg_15_18_0(idxs_diff_pkg(1:idxs_extrem_pkg(1)))) ;
std_bw_drops_pkg_14_132_0(1) = std(rel_est_pkg_14_132_0(idxs_diff_pkg(1:idxs_extrem_pkg(1)))) ;
std_bw_drops_pkg_12_132_0(1) = std(rel_est_pkg_12_132_0(idxs_diff_pkg(1:idxs_extrem_pkg(1)))) ;
std_bw_drops_pkg_12_18_0(1) = std(rel_est_pkg_12_18_0(idxs_diff_pkg(1:idxs_extrem_pkg(1)))) ;

num_smpls_per_interval_pkg(1) = length(1:idxs_extrem_pkg(1)) ;
for k = 1:length(idxs_extrem_pkg) - 1
    std_bw_drops_pkg(k+1)          = std(rel_est_pkg(idxs_diff_pkg(idxs_extrem_pkg(k)+1:idxs_extrem_pkg(k+1)))) ;
    std_bw_drops_pkg_18_132_0(k+1) = std(rel_est_pkg_18_132_0(idxs_diff_pkg(idxs_extrem_pkg(k)+1:idxs_extrem_pkg(k+1)))) ;
    std_bw_drops_pkg_15_132_0(k+1) = std(rel_est_pkg_15_132_0(idxs_diff_pkg(idxs_extrem_pkg(k)+1:idxs_extrem_pkg(k+1)))) ;
    std_bw_drops_pkg_15_18_0(k+1)  = std(rel_est_pkg_15_18_0(idxs_diff_pkg(idxs_extrem_pkg(k)+1:idxs_extrem_pkg(k+1)))) ;
    std_bw_drops_pkg_14_132_0(k+1) = std(rel_est_pkg_14_132_0(idxs_diff_pkg(idxs_extrem_pkg(k)+1:idxs_extrem_pkg(k+1)))) ;
    std_bw_drops_pkg_12_132_0(k+1) = std(rel_est_pkg_12_132_0(idxs_diff_pkg(idxs_extrem_pkg(k)+1:idxs_extrem_pkg(k+1)))) ;
    std_bw_drops_pkg_12_18_0(k+1)  = std(rel_est_pkg_12_18_0(idxs_diff_pkg(idxs_extrem_pkg(k)+1:idxs_extrem_pkg(k+1)))) ;
    
    num_smpls_per_interval_pkg(k+1) = length(idxs_extrem_pkg(k)+1:idxs_extrem_pkg(k+1)) ;
end



filters = strvcat('not const', '[1/8 1/32 0]', '[1/5 1/32 0]', '[1/5 1/8 0]', '[1/4 1/32 0]', '[1/2 1/32 0]', '[1/2 1/8 0]') ;

format_result = '%7.4f | %7.4f | %7.4f | %7.4f | %7.4f | %7.4f | %7.4f | \n' ;
fprintf(format_result, delta_D_pkg, delta_D_pkg_18_132_0, delta_D_pkg_15_132_0, delta_D_pkg_15_18_0, delta_D_pkg_14_132_0, delta_D_pkg_12_132_0, delta_D_pkg_12_18_0) ;
fprintf('=============================================\n') ;
format_spec_std_interval_title = 'std on the intervals between droppings:\n' ;
fprintf(format_spec_std_interval_title) ;
format_result_std = '%7.4f | %7.4f | %7.4f | %s \n' ;
fprintf(format_result_std, [std_bw_drops_pkg filters(1,:)], [std_bw_drops_pkg_18_132_0 filters(2,:)], [std_bw_drops_pkg_15_132_0 filters(3,:)], [std_bw_drops_pkg_15_18_0 filters(4,:)], [std_bw_drops_pkg_14_132_0 filters(5,:)], [std_bw_drops_pkg_12_132_0 filters(6,:)], [std_bw_drops_pkg_12_18_0 filters(7,:)]) ;


figure()
plot(time, rel_est_pkg)
hold on
plot(time, rel_est_pkg_18_132_0, 'r')
plot(time, rel_est_pkg_15_132_0, 'Color', green)
plot(time, rel_est_pkg_15_18_0, 'k')
plot(time, rel_est_pkg_14_132_0, 'c')
plot(time, rel_est_pkg_12_132_0, 'y')
plot(time, rel_est_pkg_12_18_0, 'm')
grid on
xlabel('t, s')
ylabel('\delta D, m')
legend('not const', '[1/8 1/32 0]', '[1/5 1/32 0]', '[1/5 1/8 0]', '[1/4 1/32 0]', '[1/2 1/32 0]', '[1/2 1/8 0]')

figure()
plot(time, rel_est_pkg_v)
hold on
plot(time, rel_est_pkg_v_18_132_0, 'r')
plot(time, rel_est_pkg_v_15_132_0, 'Color', green)
plot(time, rel_est_pkg_v_15_18_0, 'k')
plot(time, rel_est_pkg_v_14_132_0, 'c')
plot(time, rel_est_pkg_v_12_132_0, 'y')
plot(time, rel_est_pkg_v_12_18_0, 'm')
grid on
xlabel('t, s')
ylabel('\delta Vd, m/s')
legend('not const', '[1/8 1/32 0]', '[1/5 1/32 0]', '[1/5 1/8 0]', '[1/4 1/32 0]', '[1/2 1/32 0]', '[1/2 1/8 0]')