%SIMULATION OF A CYCLIC PITCH INPUT THETA_C=1 DEG GIVEN FROM HOVER 
%0.5 SEC<T<1 SEC. Now from the 15th second a PD controller becomes active 
clear
%INITIAL DATA HELICOPTER
g=9.81;	
cla = 5.73 ;%rad
volh  = 0.082; %solidity of main rotor
lok=7.8829; %checked but not sure
cds=1.5; %checked
mass=9979; %MTOW
rho=1.225; %checked
vtip=220.98; %checked
diam=2*8.18; %checked
tau = .1; 
iy=94475.21158; %from own calculations
mast=1; %don't know what this is 
omega=vtip/(diam/2);
area=pi/4*diam^2;
collect(1)=0.0664;
% W= mass*g;
longit(1)=0;
V = 46.3;
% D_fus = 0.5*cds*V^2;
% theta_f = atan(-D_fus/W);


%initial values;
t0=0;
u0=0;
w0=-8;
q0=0;
pitch0=0*pi/180;
x0=0;
labi0=sqrt(mass*g/(area*2*rho))/vtip;

t(1)=t0;
u(1)=u0;
w(1)=w0;
q(1)=q0;
pitch(1)=pitch0;
x(1)=x0;
labi(1)=labi0;
z(1)=100;

%INTEGRATION 
aantal=800;
teind=80;
stap=(teind-t0)/aantal;

for i=1:aantal 
   if t(i)>=0.5 & t(i)<=1 longit(i)=1*pi/180;
   else longit(i)=0*pi/180;
   end
    
   if t(i)>=15 longitgrd(i)=.2*pitch(i)*180/pi+.2*q(i)*180/pi;%PD in deg
       longit(i)=longitgrd(i)*pi/180;	%in rad
   end    
   %longit(i)=longitgrd(i)*pi/180;	%in rad
   
%NO LAW FOR COLLECTIVE

c(i)=u(i)*sin(pitch(i))-w(i)*cos(pitch(i));
h(i)=-z(i);
v(i) = sqrt(u(i)^2 + w(i)^2);
k1 = 0.06;
k3 = 0.2;
h_des = 100;
v_des = 46.3;
c_des = k3*(h_des - h(i));
collect(i) = 5/180*pi + k1*(c_des-c(i));

%Defining the differential equations

%defining the nondimensional notations
qdiml(i)=q(i)/omega;
vdiml(i)=sqrt(u(i)^2+w(i)^2)/vtip;
if u(i)==0 	if w(i)>0 	phi(i)=pi/2;
        else phi(i)=-pi/2;end
else
phi(i)=atan(w(i)/u(i));
end
if u(i)<0
phi(i)=phi(i)+pi;
end
alfc(i)=longit(i)-phi(i);

mu(i)=vdiml(i)*cos(alfc(i));
labc(i)=vdiml(i)*sin(alfc(i));

%a1 Flapping calculi
teller(i)=-16/lok*qdiml(i)+8/3*mu(i)*collect(i)-2*mu(i)*(labc(i)+labi(i));
a1(i)=teller(i)/(1-.5*mu(i)^2);

%the thrust coefficient
ctelem(i)=cla*volh/4*(2/3*collect(i)*(1+1.5*mu(i)^2)-(labc(i)+labi(i)));
%Thrust coefficient from Glauert
alfd(i)=alfc(i)-a1(i);
ctglau(i)=2*labi(i)*sqrt((vdiml(i)*cos(alfd(i)))^2+(vdiml(i)*...
sin(alfd(i))+labi(i))^2);

%Equations of motion
labidot(i)=ctelem(i); 
thrust(i)=labidot(i)*rho*vtip^2*area;
helling(i)=longit(i)-a1(i);
vv(i)=vdiml(i)*vtip; 		%it is 1/sqrt(u^2+w^2)

udot(i)=-g*sin(pitch(i))-cds/mass*.5*rho*u(i)*vv(i)+...
thrust(i)/mass*sin(helling(i))-q(i)*w(i);

wdot(i)=g*cos(pitch(i))-cds/mass*.5*rho*w(i)*vv(i)-...
thrust(i)/mass*cos(helling(i))+q(i)*u(i);

qdot(i)=-thrust(i)*mast/iy*sin(helling(i));

pitchdot(i)=q(i);

xdot(i)=u(i)*cos(pitch(i))+w(i)*sin(pitch(i));

zdot(i)=-c(i);
uwens = 45;
labidot(i)=(ctelem(i)-ctglau(i))/tau;
corrdot(i)=uwens-u(i);
%corrcdot(i)=cwens(i)-c(i);
c_des = k3*(h_des - h(i));
collect(i) = 5/180*pi + k1*(c_des-c(i));

u(i+1)=u(i)+stap*udot(i);
w(i+1)=w(i)+stap*wdot(i);
q(i+1)=q(i)+stap*qdot(i);
pitch(i+1)=pitch(i)+stap*pitchdot(i);
x(i+1)=x(i)+stap*xdot(i);
labi(i+1)=labi(i)+stap*labidot(i);
z(i+1)=z(i)+stap*zdot(i);
t(i+1)=t(i)+stap;
% V(i) = sqrt(u(i)^2 + w(i)^2);
%      if t(i) == 100
%          Vdesi = 90;
%          dvdot(i) = Vdesi - V(i);
%          dx(i+1) =dx(i)+dxdot(i)*stap;
%          pitchdesi(i) = k4*dxdot(i) +k5*u(i) + k6*dx(i);
%      if 

        
end;
figure(1)
plot(t,u),xlabel('t (s)'),ylabel('u(m)'),grid
% figure(2)
% plot(t,pitch*180/pi),xlabel('t (s)'),ylabel('pitch(deg)'),grid
figure(3)
plot(t,x),xlabel('t (s)'),ylabel('x(m)'),grid
% figure(5)
% plot(t,w),xlabel('t (s)'),ylabel('w(m)'),grid
% figure(6)
% plot(t,q),xlabel('t (s)'),ylabel('q(m)'),grid
% figure(7)
% plot(t,labi),xlabel('t (s)'),ylabel('labi(m)'),grid
figure(8)
plot(t,-z),xlabel('t (s)'),ylabel('h(m)'),grid
% figure(9)
% plot(t(1:800),longit*180/pi),xlabel('t (s)'),ylabel('longit grd'),grid


