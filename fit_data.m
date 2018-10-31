switch 900
    case 700
        A = load('700.mat');
    case 800
        A = load('800.mat');
    case 900
        A = load('900.mat');
end

t_pores = A.C(:,1)*1e-9; %s
num_pores = A.C(:,2);
t_pressure = A.P(:,1)*1e-9; %s
pressure = A.P(:,2)*1e9; %pa
temp = A.P(:,3); %K

clear A
%dn/dt = A*exp(-(E-v*P(t))/kT),  needs to find A E and v
kb = 1.38*1e-23; %m^2*kg*s^-2*K-1
dndt = gradient(num_pores,t_pores);

figure();
subplot(3,1,1)
plot(t_pores, num_pores);
subplot(3,1,2)
plot(t_pressure, pressure);
subplot(3,1,3)
plot(t_pressure, temp);

[~,i_t] = max(num_pores);
t_max = t_pores(i_t);
t_P =t_pressure(t_pressure<t_max);
P =pressure(t_pressure<t_max);
Temp = temp(t_pressure<t_max);

figure();
subplot(3,1,1)
plot(t_pores(1:i_t), num_pores(1:i_t));
subplot(3,1,2)
plot(t_P, P);
subplot(3,1,3)
plot(t_P, Temp);

A = 1e25;
E = 275*kb*700;
v = 1e-18;
dn_dt_calc = A*exp(-(E-v*pressure)./(kb*Temp));
figure();
subplot(2,1,1)
plot(t_pressure, dn_dt_calc);
subplot(2,1,2); hold on;
plot(t_pressure, cumtrapz(t_pressure,dn_dt_calc));
plot(t_pores, num_pores);