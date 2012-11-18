function [ idxs ] = find_idxs( data_container, target)
%FIND_IDXS Summary of this function goes here
%   Detailed explanation goes here

idxs = zeros(1, size(target,1)) ;
for k = 1:length(target)
    idxs(k) = find(data_container == target(k)) ;
end
end

