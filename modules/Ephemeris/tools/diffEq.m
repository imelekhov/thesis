function dy = diffEq(t, y, a)

%% constants:
mu = 3.9860044*10^14;
a_e = 6378136;
C_20 = -1082.63*10^(-6);
omega = 7292115*10^(-11);
% ax = 0.465661287308*10^(-5);
% ay = 0.931322574615*10^(-6);
% az = 0.931322574615*10^(-6);

%% ODEs
dy = zeros(6,1);
dy(1) = y(4);
dy(2) = y(5);
dy(3) = y(6);

dy(4) = -mu*y(1)/((sqrt(y(1)^2+y(2)^2+y(3)^2))^3)+1.5*C_20*mu*a_e^2*y(1)*(1-5*y(3)^2/(y(1)^2+y(2)^2+y(3)^2))/((sqrt(y(1)^2+y(2)^2+y(3)^2))^5)+omega^2*y(1)+2*omega*y(5)+a(1);
%dy(4) = -mu*y(1)/((sqrt(y(1)^2+y(2)^2+y(3)^2))^3)+1.5*C_20*mu*a_e^2*y(1)*(1-5*y(3)^2/(y(1)^2+y(2)^2+y(3)^2))/((sqrt(y(1)^2+y(2)^2+y(3)^2))^5);
dy(5) = -mu*y(2)/((sqrt(y(1)^2+y(2)^2+y(3)^2))^3)+1.5*C_20*mu*a_e^2*y(2)*(1-5*y(3)^2/(y(1)^2+y(2)^2+y(3)^2))/((sqrt(y(1)^2+y(2)^2+y(3)^2))^5)+omega^2*y(2)-2*omega*y(4)+a(2);
%dy(5) = -mu*y(2)/((sqrt(y(1)^2+y(2)^2+y(3)^2))^3)+1.5*C_20*mu*a_e^2*y(2)*(1-5*y(3)^2/(y(1)^2+y(2)^2+y(3)^2))/((sqrt(y(1)^2+y(2)^2+y(3)^2))^5);
dy(6) = -mu*y(3)/((sqrt(y(1)^2+y(2)^2+y(3)^2))^3)+1.5*C_20*mu*a_e^2*y(3)*(3-5*y(3)^2/(y(1)^2+y(2)^2+y(3)^2))/((sqrt(y(1)^2+y(2)^2+y(3)^2))^5)+a(3);