%SIMULATION OF A CYCLIC PITCH INPUT THETA_C=1 DEG GIVEN FROM HOVER 
%0.5 SEC<T<1 SEC. Now from the 15th second a PD controller becomes active 
%INITIAL DATA HELICOPTER
g=9.81;	
cla = 5.73 ;%rad
volh  = 0.082; %solidity of main rotor
lock=7.8829; %checked but not sure
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
longit(1)=0.0148;
%V = convvel(valuesToConvert, inputVelocityUnits, outputVelocityUnits);


t0 = 0;
steps = 800;
time = 500;
stap = (time-t0)/800;


V_man1 = convvel(90, 'kts', 'm/s');
theta_c_gen = a_1(125);
theta_0_gen = theta_0(125);
collect=(theta_0_gen) + (steps-1)*(0);
longit=(theta_c_gen) + (steps-1)*(0);

u0=convvel(90, 'kts', 'm/s');



w0 = 0;
q0 = 0;
pitch0 = -7.3*pi/180;

x0 = 0;
labi0=sqrt(mass*g/(area*2*rho))/vtip;

t = (t0) + (steps-1)*(0);
u=(u0) + (steps-1)*(0);
w=(w0) + (steps-1)*(0);
q=(q0) + (steps-1)*(0);
pitch=(pitch0) + (steps-1)*(0);
x=(x0) + (steps-1)*(0);
z=(0) + (steps-1)*(0);
longitgrad=(0) + (steps-1)*(0);
qdiml=(0) + (steps-1)*(0);
vdiml=(0) + (steps-1)*(0);
phi=(0) + (steps-1)*(0);
alpha_c = (0) + (steps-1)*(0);
mu = (0) + (steps-1)*(0);
labc = (0) + (steps-1)*(0);
a1 = (0) + (steps-1)*(0);
ctelem = (0) + (steps-1)*(0);
alfd = (0) + (steps-1)*(0);
ctglau = (0) + (steps-1)*(0);
labidot = (0) + (steps-1)*(0);
thrust = (0) + (steps-1)*(0);
helling = (0) + (steps-1)*(0);
vv = (0) + (steps-1)*(0);
labi = (0) + (steps-1)*(0);

udot = (0) + (steps-1)*(0);
wdot = (0) + (steps-1)*(0);
qdot = (0) + (steps-1)*(0);
pitchdot = (0) + (steps-1)*(0);

xdot = (0) + (steps-1)*(0);
zdot = (0) + (steps-1)*(0);
c = steps*(0);
dc = steps*(0);
v = steps*(0);
dv = steps*(0);
c_des=0;
h_des = 100;
pitch_des = 0;
dtf = steps*(0);
h = steps*(0);


K1 = 0.03;
K2 = 0.13;
K3 = 0.0015;
K4 = 0.0054;
K5 = 0.51;
K6 = 0.00;


K7 = 0.084;
K8 = 0.043;
K9 = 0.0386;
K10 = 0.91;

V_man1 = convvel(90, 'kts', 'm/s');
V_man2 = convvel(70, 'kts', 'm/s');
V_man3 = convvel(90, 'kts', 'm/s');
V_man4 = convvel(110, 'kts', 'm/s');
V_margin = convvel(5, 'kts', 'm/s');
minmantime = 30;
man1 = true;
man2 = true;
man3 = true;
man4 = true;
checks = true;



for i = 1 : length(steps)
    if t(i)<=80
        v_des =  V_man2;
        theta_c_gen = a_1(111);
        theta_0_gen = theta_0(111);
    
    if t(i)>80 && t(i)<=180
       v_des =  V_man3;
       theta_c_gen = a_1(125);
       theta_0_gen = theta_0(125);
    
    if t(i)>80 && t(i)<180
       v_des =  V_man4;
       theta_c_gen = a_1(111);
       theta_0_gen = theta_0(111);
    
        
   
    v(i) = sqrt(u(i)^2 + w(i)^2);
    if i+1 < steps
        pitch_des = K4 * (v_des - u(i)) + K5 * udot(i) + K6 * dv(i);
        dv(i+1) = dv(i) +(v_des-u(i))*stap;
    
    if (i + 1) < steps
        dtf(i) = dtf(i) + (pitch(i) - pitch_des) * stap;

        longit(i) =  K1 * (pitch(i) - pitch_des) * 180 / pi + K2 * q(i) * 180 /pi + K3 * dtf(i)*180/pi;
    
   
        c(i) = u(i) *sin(pitch(i)) - w(i) *cos(pitch(i));
        h(i) = -z(i);
        c_des = K9 * (h_des - h(i)) + K10 * c(i);
     if (i + 1) < steps
            dc(i + 1) = dc(i) + (c_des - c(i)) * stap;
            collect(i) = theta_0_gen + K7 * (c_des - c(i)) + K8 * dc(i + 1);
     
     countlst = zeros((minmantime/stap)) ; 
     if checks == true
       
        if t(i) >= minmantime
           if V_man2 - V_margin  <= u(i-j)&& u(j-i) <= V_man2 + V_margin
                countlst(j) = 1;
                
           if sum(countlst) == length(countlst)
                man1 = true;
                theta_c_gen = a_1(111);
                theta_0_gen = theta_0(111);
                v_des = V_man3  ;
         
        
        if man1 == true
            countlst = zeros((minmantime/stap));
            
            for j = 1: length(minmantime/stap)
                if V_man3 - V_margin  <= u(i+1-j) && u(i+1-j) <= V_man3 + V_margin
                    countlst(j) = 1;
                
                if sum(countlst) == length(countlst)
                    man2 = true;
                    theta_c_gen = a_1(125);
                    theta_0_gen = theta_0(125);                   
                    v_des = V_man4  ;
        
        if man2 == true
            countlst = zeros((minmantime/stap));
            for j = 1: length(minmantime/stap)
                if V_man4 - V_margin  <= u(i+1-j)&&u(i+1-j) <= V_man4 + V_margin
                    countlst(j) = 1;
                
                if sum(countlst) == length(countlst)
                    man3 = true;
                   
                end 
                end
            end
        end
                end
                end
            end
        end
           end
           end
        end
     end
     end
    end
    end
    end
    end
    end


     
        

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
teller(i)=-16/lock*qdiml(i)+8/3*mu(i)*collect(i)-2*mu(i)*(labc(i)+labi(i));
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

labidot(i)=(ctelem(i)-ctglau(i))/tau;



u(i+1)=u(i)+stap*udot(i);
w(i+1)=w(i)+stap*wdot(i);
v(i) = sqrt(u(i)^2 + w(i)^2);
q(i+1)=q(i)+stap*qdot(i);
pitch(i+1)=pitch(i)+stap*pitchdot(i);
x(i+1)=x(i)+stap*xdot(i);
labi(i+1)=labi(i)+stap*labidot(i);
z(i+1)=z(i)+stap*zdot(i);
t(i+1)=t(i)+stap;
end
     
figure(1)
plot(t,u),xlabel('t (s)'),ylabel('u(m)'),grid
 figure(2)
 plot(t,pitch*180/pi),xlabel('t (s)'),ylabel('pitch(deg)'),grid
figure(3)
plot(t,x),xlabel('t (s)'),ylabel('x(m)'),grid
figure(5)
plot(t,w),xlabel('t (s)'),ylabel('w(m)'),grid
figure(6)
plot(t,q),xlabel('t (s)'),ylabel('q(m)'),grid
figure(7)
plot(t,labi),xlabel('t (s)'),ylabel('labi(m)'),grid
figure(8)
plot(t,-z),xlabel('t (s)'),ylabel('h(m)'),grid
% figure(9)
% plot(t(1:800),longit*180/pi),xlabel('t (s)'),ylabel('longit grd'),grid


