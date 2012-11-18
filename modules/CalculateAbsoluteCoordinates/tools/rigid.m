function dy = rigid(t, y, Psi, Vh, Vhrz, ft)

% ODEs describing of an aircraft trajectory in GCS


a = 6378245 ;
eSq = 0.0066934 ;

VhrzI = interp1(ft, Vhrz, t, 'pchip') ;

R = a * (1 - 0.5 * eSq * sin(y(2))^2) + y(1) ;

dy = zeros(3, 1) ;

dy(1) = Vh ;
dy(2) = VhrzI .* cos(Psi) ./ (R) ;
dy(3) = VhrzI .* sin(Psi) ./ (R * cos(y(2))) ;
