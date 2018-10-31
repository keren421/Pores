switch 800
    case 700
        A = load('700.mat');
    case 800
        A = load('800.mat');
    case 900
        A = load('900.mat');
end

t_pores = A.C(:,1); %ps
num_pores = A.C(:,2);
t_pressure = A.P(:,1); %ps
pressure = A.P(:,2); %Gpa
Temp = A.P(:,3); %K

clear A
%dn/dt = A*exp(-(E-v*P(t))/kT),  needs to find A E and v
dndt = gradient(num_pores,t_pores);

figure();
subplot(2,1,1)
plot(t_pores, num_pores);
subplot(2,1,2)
plot(t_pressure, pressure);