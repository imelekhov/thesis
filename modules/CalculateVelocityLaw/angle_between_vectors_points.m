function [ alpha ] = angle_between_vectors_points(Vec)

% Vec is 3D matrix
ABxCDx = abs(Vec(1,1,1) - Vec(1,2,1)) * abs(Vec(1,1,2) - Vec(1,2,2)) ;
AByCDy = abs(Vec(2,1,1) - Vec(2,2,1)) * abs(Vec(2,1,2) - Vec(2,2,2)) ;

norm_AB = sqrt(abs(Vec(1,1,1) - Vec(1,2,1))^2 + abs(Vec(2,1,1) - Vec(2,2,1))^2) ;
norm_CD = sqrt(abs(Vec(1,1,2) - Vec(1,2,2))^2 + abs(Vec(2,1,2) - Vec(2,2,2))^2) ;

dot_product = ABxCDx + AByCDy ;

alpha(:,1) = acos(dot_product / (norm_AB * norm_CD)) ; % radians
alpha(:,2) = acos(dot_product / (norm_AB * norm_CD)) * 180 / pi ; % degrees