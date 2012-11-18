function [ std_container ] = std_bw_drops( data_container, indxs )
%STD_BW_DROPS Summary of this function goes here
%   Detailed explanation goes here

%std_container = zeros(1, size(indxs,2) - 1) ;

for k = 1:size(indxs,2) - 1
    idx_start = indxs(k) + 1 ; % next sample after first dropping
    idx_stop  = indxs(k+1) - 1 ; % previous sample
    if idx_start > idx_stop
        continue ;
    end
    idx_range = idx_start:idx_stop ;
    std_container(k) = std(data_container(idx_range)) ;
end

end

