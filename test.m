 m=2200.00; %mass of the helicopter (kg)
 Iy=4973.00; %pitch moment of inertia kg-m^2
 CDS=1.673; %equi flat plate area NASA CR 3579
 omega=44.4012; %rotor rad/sec
 R=4.91; %rotor radius
 gamma=5.07; %Locks inertia number
 a=5.7; %lift curve slope
 sigma=0.075; %solidity ratio
 rho=1.225; %density at ISA
 g=9.81;
 h=0.945; %height of the rotor above cg
 step=0.01; %for looping
 number=0;
%control variables
 theta0=8.7*3.14/180; %collective
 thetac=4.3*3.14/180; %longitudinal cyclic
%state variables
 u=50.00; %initial velo 50 m/s
 udot=0.0;
 w=0.0;
 wdot=0.0;
 q=0.0;
 qdot=0.0;
 thetaf=-7.3*3.14/180; %fuselage pitch attitude
 thetafdot=0.0*3.14/180;
 V=0.0; %velocity of the helicopter (m/s)
 c=0.0; % vertical velo
 ht=0.0; %height above ground
 z=0.0;
 zdot=0.0;
 
  alfac=0.0*3.14/180; %AoA of CP
 mu=0.0; %advance ratio
 lambdac=0.0; %total inflow ratio w.r.t. CP
 lambdai=sqrt(m*g/(3.14*R*R*2*rho))/(omega*R); %induceinflow ratio
 lambdaidot=0.0;
 tau=0.1; %time lag
 a1(1)=0.0*3.14/180; %longitudinal disk tilt
 CTbem(1)=0.0; %thrust coeffi through BEM theory
 CTglau(1)=0.0; %thrust coeffi through Glauert
 A(1)=[]
 B(1)=0.0; %for CTglau calculation
 T(1)=0.0; %thrust
 D(1)=0.0; %drag
 phi(1)=0.0*3.14/180;
 dtf=0.0;
 dtfdot=0.0;
 x=0.0;
 xdot=0.0;
 dx=0.0;
 dxdot=0.0;
 dc=0.0;
 dcdot=0.0;
 thetafdesi=0.0*3.14/180; % in rad
 xdesi=2000.0; % 2 km from starting point
 cdesi=0.0;
 htdesi=100;
 k1=0.890; %k1*(thetaf-thetafdesi)
 k2=0.60; %k2*q
 k3=0.000143; %k3*INTEGRAL(thetaf-thetafdesi)
 k4=-0.000569; %k4*(xdesi-x)
 k5=0.0138; %k5*u
 k6=0.00; %k6*INTEGRAL(xdesi-x)

 k7=0.06; %k7*(cdesi-c)
 k8=0.050; %k8*INTEGRAL(cdesi-c)
 k9=0.0386; %k9*(htdesi-ht)
 k10=0.890;
 number = 200;
 for i = 1:length(number)
     if u(i) == 0
         if w(i)>0
             phi(i) = 1.57;
         elseif w(i) == 0
             phi(i) = -1.57;
         end
     else 
       phi(i) = atan(w(i)/u(i));
     end
     if u < 0
         phi(i+1) = phi(i) + pi;
     end
      alfac(i) =  thetac - phi(i);
      V(i) = sqrt(u(i)^2 +w(i)^2);
      mu(i) = (V(i)/(omega*R))*cos(alfac(i));
      lambdac(i) = (V(i)/(omega*R))*sin(alfac(i));
      a1(i) = (2.67*mu(i)*theta0-2*mu(i)*(lambdac(i)+lambdai)-16*q)/(gamma*omega)/(1-0.5*mu(i)^2);
      CTbem(i) = 0.25*a*sigma*(0.67*theta0*(1+1.5*mu(i)*mu(i))-(lambdac(i)+lambdai));
      A(i) = (V(i)*cos(alfac(i)-a1(i))/(omega*R))*(V*cos(alfac(i)-a1(i))/(omega*R));
      B(i) = (V(i)*sin(alfac(i)-a1(i))/(omega*R)+lambdai)*(V*sin(alfac(i)-a1(i))/(omega*R)+lambdai);
      CTglau(i) = 2*lambdai*sqrt(A(i)+B(i));
      T(i) = 3.14*CTbem(i)*rho*omega*omega*R*R*R*R;
      D(i) = CDS*0.5*rho*V(i)^2;
      
      udot(i) = -g*sin(thetaf)-(D*u(i))/(m*V(i))+T*sin(thetac-a1(i))/m-q*w(i);
      wdot(i) = g*cos(thetaf)-(D*w(i))/(m*V(i))-T*cos(thetac-a1(i))/m+q*u(i);
      qdot(i) = -T(i)*h*sin(thetac-a1(i))/Iy;
      thetafdot(i) = q(i);
      xdot(i) = u(i)*cos(thetaf)+w(i)*sin(thetaf);
      zdot(i) =-c(i);
      lambdaidot(i) = (CTbem(i)-CTglau(i))/tau;
      u(i+1) = u(i) + udot(i)*step;
      w(i+1) = w(i)+ wdot(i)*step;
      q(i+1) = q(i)+ qdot(i)*step;
      thetaf(i+1) = thetaf(i) + thetafdot(i)*step;
      x(i+1) = x(i) + xdot(i)*step;
      z(i+1) = z(i) + zdot(i)*step;
      lambdai(i+1) = lambdaidot(i)+ lambdaidot(i)*step;
      c(i)=u(i)*sin(thetaf(i))-w(i)*cos(thetaf(i));
      ht(i)=-z(i);
      cdesi=k9*(htdesi-ht(i))+k10*c(i);
      dcdot=(cdesi-c(i));
      dc(i+1)=dc(i)+dcdot(i)*step;
      theta0=(5.01*3.14/180)+k7*dcdot+k8*dc;
      
 end
      
      
             
                