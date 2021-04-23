g=9.81;	
cla = 5.73 ;%rad
sigma  = 0.082; %solidity of main rotor
lok=7.8829; %checked but not sure
cds=1.5; %checked
mass=9979; %MTOW
rho=1.225; %checked
vtip=220.98; %checked
diam=2*8.18; %checked
iy=94475.21158; %from own calculations
mast=1; %weet niet wat het is
omega=vtip/(diam/2);
area=pi/4*diam^2;
tau=.1;		%time constant in dynamiCs inflow!!!
collect(1)=0.0662; %read from trim graph at 90kts [rad]
longit(1)=0.01485; %read from trim graph at 90kts [rad]

%gain values;
k1 = 0.9;
k2 = 0.6;
k3 = 0.01;
