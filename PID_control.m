%SIMULATION OF A CYCLIC PITCH INPUT THETA_C=1 DEG GIVEN FROM HOVER 
%0.5 SEC<T<1 SEC. Now from the 15th second a PD controller becomes active 
clear all
close all
clc

% induced_velocity;
% Trim_calculation;
%INITIAL DATA HELICOPTER
g=9.81;	
cla = 5.73 ;%rad
sigma  = 0.082; %solidity of main rotor
lok=7.8829; %checked but not sure
gamma = lok;
CDS=1.5; %checked
mass=9979; %MTOW in kg
W = mass * g;
massa = W/g;
h = 1.86549073; %height of rotor above CG
rho=1.225; %checked
vtip=220.98; %checked
R = 8.18;
diam=2*R; %checked
iy=94475.21158; %from own calculations
mast=1; %weet niet wat het is
omega=vtip/(diam/2);
area=pi/4*diam^2;
tau=0.1;		%time constant in dynamiCs inflow!!!


% %gain values;
% k1 = 0.9;
% k2 = 0.6;
% k3 = 0.07;
% 
% k4 = -0.0006;
% k5 = 0.017;
% k6 = 0.15;

%gain values;
k1 = 0.5;
k2 = 0.0;
k3 = 0.0;

k4 = 0;
k5 = 0;
k6 = 0;

%initial values;
V_90 = 46.3; %m/s
t0=0; %starts at 0 seconds
% index_90 = 26; % index at which 46.3 m/s is best approximated in V_h, D_fus_h
D_fus_90 = CDS*0.5*rho*V_90^2;
theta_f_90 = atan(-D_fus_90/W);
Iyy = iy;
u0 = V_90 * cos(theta_f_90);
w0 = V_90 * sin(theta_f_90);
q0 = 0; % trimmed initial condition
pitch0=theta_f_90; % [rad]
x0=0; %vgm onbelangrijk
lambda_i0=sqrt(mass*g/(area*2*rho))/vtip; % weet niet wat het is.
theta_0(1)=0.0662; %read from trim graph at 90kts [rad]
theta_c(1)=0.01485; %read from trim graph at 90kts [rad]

%initial conditions at 90kts (46.3 m/s)
t(1)=t0;
u(1)=u0;
w(1)=w0;
q(1)=q0;
pitch(1)=pitch0;
x(1)=x0;
% lambda_i(1)=lambda_i0;
lambda_i(1) = lambda_i0;
z(1)=100;
z_dot(1) = 0;
D_fus(1) = D_fus_90;

%desired conditions
pitch_desired = theta_f_90;
z_desired = 100;

%INTEGRATION parameters
n_steps = 100;
t_end=80;
step=(t_end-t0)/n_steps;

alpha_c = zeros(1, n_steps);
for i=1:n_steps
    %current state
%     theta_c(i) = k1*(pitch(i) - pitch_desired) + k2*q(i) + k3 * (pitch(i) - pitch_desired)*t(i);
    
    theta_c(i) = k1*(pitch(i) - pitch_desired) + k2*q(i) + k3 * (pitch(i) - pitch_desired)*t(i);
    
  
%     theta_0(i) = k4*(z(i) - z_desired) + k5 * z_dot(i) + k6 * (z(i) - z_desired)*t(i);
    c(i)=u(i)*sin(pitch(i))-w(i)*cos(pitch(i));
    v(i) = sqrt(u(i)^2 + w(i)^2);
    v_des = 90;
    c_des = k4*(z_desired - z(i));
    theta_0(i) = 5/180*pi + k5*(c_des-c(i));
    
    V(i) = sqrt(u(i)^2 + w(i)^2);
    alpha_c(i) = -atan(w(i)/u(i)) + theta_c(i);
    mu(i) = V(i)/(omega * diam/2)*cos(alpha_c(i));
    lambda_c(i) = V(i)/(omega * R)*sin(alpha_c(i));
    D_fus(i) = CDS*0.5*rho*V(i)^2;
    a_1(i) = (8/3*mu(i)*theta_0(i) - 2*mu(i)*(lambda_c(i)+lambda_i(i)) - 16*q(i)/(gamma*omega))/(1-0.5*mu(i)^2);
    %thrust coefficients
    CT_BEM(i) = 1/4 * cla*sigma * (2/3*theta_0(i)*(1+1.5*mu(i)*mu(i)) - (lambda_c(i) + lambda_i(i))); %BEM theory 
    A(i) = (V(i)*cos(alpha_c(i)-a_1(i))/(omega*R))^2;
    B(i) = (V(i)*sin(alpha_c(i)-a_1(i))/(omega*R)+lambda_i(i))^2;
    CT_GLAU(i) = 2*lambda_i(i)*sqrt(A(i)+B(i));
    T(i) = pi*CT_BEM(i)*rho*omega^2*R^4;
    
    %EoM
    u_dot(i) = -g*sin(pitch(i)) - D_fus(i)/mass * u(i)/V(i) + T(i)/massa * sin(theta_c(i) - a_1(i)) - q(i) * w(i);
    w_dot(i) = g*cos(pitch(i)) - D_fus(i)/massa * w(i)/V(i) - T(i)/massa * cos(theta_c(i) - a_1(i)) + q(i) * u(i);
    
%     display(-T(i)/Iyy * h * sin(theta_c(i)-a_1(i)))
%     display(-T(i)/Iyy)
    
    q_dot(i) = -T(i)/Iyy * h * sin(theta_c(i)-a_1(i));
    pitch_dot(i) = q(i);
%     x_dot(i) = u(i)*cos(pitch(i)) + w(i)*sin(pitch(i));
    z_dot(i) = u(i)*sin(pitch(i)) + w(i)*cos(pitch(i));
    lambda_i_dot(i) = (CT_BEM(i)-CT_GLAU(i))/tau;
    
    %integration
    
    t(i+1) = t(i) + step;
    u(i+1) = u(i) + u_dot(i) * step;
    w(i+1) = w(i) + w_dot(i) * step;
    q(i+1) = q(i) + q_dot(i) * step;
    lambda_i(i+1) = lambda_i(i) + lambda_i_dot(i)*step;
    pitch(i+1) = pitch(i) + pitch_dot(i) * step;
    z(i+1) = z(i) * step * z_dot(i);
    
    
%     theta_c(i) = k1*(pitch(i) - pitch_desired) + k2*q(i) + k3 * (pitch(i) - pitch_desired)*t(i);
%     theta_0(i) = k4*(pitch(i) - pitch_desired) + k5*q(i) + k6 * (pitch(i) - pitch_desired)*t(i);
    display(i)
end


figure
plot(t,u),xlabel('t (s)'),ylabel('u-velocity(m)'),grid;
figure
plot(t,z),xlabel('t (s)'),ylabel('height(m)'),grid;



























% for i=1:n_steps 
%     
%    
% %NO LAW FOR COLLECTIVE
% 
% c(i)=u(i)*sin(pitch(i))-w(i)*cos(pitch(i));
% h(i)=-z(i);
% collect(i)=collect(1);
% 
% %Defining the differential equations
% 
% %defining the nondimensional notations
% qdiml(i)=q(i)/omega;
% vdiml(i)=sqrt(u(i)^2+w(i)^2)/vtip;
% if u(i)==0 	if w(i)>0 	phi(i)=pi/2;
%         else phi(i)=-pi/2;end
% else
% phi(i)=atan(w(i)/u(i));
% end
% if u(i)<0
% phi(i)=phi(i)+pi;
% end
% alfc(i)=longit(i)-phi(i);
% 
% mu(i)=vdiml(i)*cos(alfc(i));
% labc(i)=vdiml(i)*sin(alfc(i));
% 
% %a1 Flapping calculi
% teller(i)=-16/lok*qdiml(i)+8/3*mu(i)*collect(i)-2*mu(i)*(labc(i)+labi(i));
% a1(i)=teller(i)/(1-.5*mu(i)^2);
% 
% %the thrust coefficient
% ctelem(i)=cla*sigma/4*(2/3*collect(i)*(1+1.5*mu(i)^2)-(labc(i)+labi(i)));
% %Thrust coefficient from Glauert
% alfd(i)=alfc(i)-a1(i);
% ctglau(i)=2*labi(i)*sqrt((vdiml(i)*cos(alfd(i)))^2+(vdiml(i)*...
% sin(alfd(i))+labi(i))^2);
% 
% %Equations of motion
% labidot(i)=ctelem(i); 
% thrust(i)=labidot(i)*rho*vtip^2*area;
% helling(i)=longit(i)-a1(i);
% vv(i)=vdiml(i)*vtip; 		%it is 1/sqrt(u^2+w^2)
% 
% udot(i)=-g*sin(pitch(i))-cds/mass*.5*rho*u(i)*vv(i)+...
% thrust(i)/mass*sin(helling(i))-q(i)*w(i);
% 
% wdot(i)=g*cos(pitch(i))-cds/mass*.5*rho*w(i)*vv(i)-...
% thrust(i)/mass*cos(helling(i))+q(i)*u(i);
% 
% qdot(i)=-thrust(i)*mast/iy*sin(helling(i));
% 
% pitchdot(i)=q(i);
% 
% xdot(i)=u(i)*cos(pitch(i))+w(i)*sin(pitch(i));
% 
% zdot(i)=-c(i);
% 
% labidot(i)=(ctelem(i)-ctglau(i))/tau;
% %corrdot(i)=uwens-u(i);
% %corrcdot(i)=cwens(i)-c(i);
% 
% u(i+1)=u(i)+stap*udot(i);
% w(i+1)=w(i)+stap*wdot(i);
% q(i+1)=q(i)+stap*qdot(i);
% pitch(i+1)=pitch(i)+stap*pitchdot(i);
% x(i+1)=x(i)+stap*xdot(i);
% labi(i+1)=labi(i)+stap*labidot(i);
% z(i+1)=z(i)+stap*zdot(i);
% t(i+1)=t(i)+stap;
% end;
% % figure
% % plot(t,u),xlabel('t (s)'),ylabel('u(m)'),grid;
% % figure
% % plot(t,pitch*180/pi),xlabel('t (s)'),ylabel('pitch(deg)'),grid;
% % figure
% % plot(t,x),xlabel('t (s)'),ylabel('x(m)'),grid;
% % figure
% % plot(t,w),xlabel('t (s)'),ylabel('w(m)'),grid;
% % figure
% % plot(t,q),xlabel('t (s)'),ylabel('q(m)'),grid; 
% % figure
% % plot(t,labi),xlabel('t (s)'),ylabel('labi(m)'),grid;
% % figure
% % plot(t,-z),xlabel('t (s)'),ylabel('h(m)'),grid;
% % figure
% % plot(t(1:800),longit*180/pi),xlabel('t (s)'),ylabel('longit grd'),grid;
% 
% 
