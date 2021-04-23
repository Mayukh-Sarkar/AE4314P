V = 46.3; % velocity
W=9.81*9979; %weight
R=8.18; %rotor diameter
Iyy=94475; %moment of inertia
gamma=7.889; % lock number
sigma=0.082; % solidity
SFP=2.13; % equivalent fuselage area
cd=0.019; % drag coeff
cla=5.73; % lift curve slope
l = 0;
Area = 3.14159.*R.*R; %area
v_tip = 220.98; % tip velocity
h=0.1924;
mu=W./(9.81.*rho.*sigma.*Area.*R);
iB=Iyy./(W.*R.*R./9.81);
d0=SFP./(sigma.*Area);
nu0 = sqrt(W./(2.*rho.*Area));
Vcap = V./v_tip;
Vbar=V./nu0;
wc=W./(rho.*sigma.*Area.*v_tip.*v_tip);
tcD=wc;
tc=wc;
mu=V./v_tip;
hcD=0.25.*mu.*cd;
nui0bar=sqrt(-0.5.*Vbar.*Vbar+sqrt(0.25.*Vbar.*Vbar.*Vbar.*Vbar+1));
nuibar=nui0bar;
lambdai = nui0bar.*nu0./v_tip;
alfaD=(-0.5.*Vcap.*Vcap.*d0+hcD)./tcD;
lambdaD=Vcap.*sin(alfaD)-lambdai;
mu=Vcap.*cos(alfaD);
theta0=((4.*tcD./cla)-lambdaD.*(1-0.5.*mu.*mu)./(1+1.5.*mu.*mu)).*1.5.*(1+1.5.*mu.*mu)./(1-mu.*mu+2.25.*mu.*mu.*mu.*mu);
a1=2.*mu.*(1.33.*theta0+lambdaD)./(1+1.5.*mu.*mu);
hcD=0.25.*mu.*cd;
B1=a1+hcD./wc;
a1s=a1-B1;
alfaNF=alfaD-a1;

dlambdai_dmu=(2.*mu.*theta0+alfaNF-((4.*tc)./(cla.*lambdai)).*Vbar.*nuibar.*nuibar.*nuibar)./(1+(4./cla).*(tc./lambdai).*(1+nuibar.*nuibar.*nuibar.*nuibar));

dlambda_dmu=alfaNF-dlambdai_dmu; 
da1_dmu=a1./mu-(2.*mu.*dlambda_dmu)./(1-0.5.*mu.*mu);

dtc_dmu=(2.*mu.*theta0+alfaNF+(Vbar.*nuibar.*nuibar.*nuibar)./(1+nuibar.*nuibar.*nuibar.*nuibar))./((4./cla)+(lambdai./tc)./(1+nuibar.*nuibar.*nuibar.*nuibar));

dhcd_dmu=0.25.*cd;
da1_dw=2.*mu./((1-0.5.*mu.*mu).*(1+0.25.*cla.*lambdai./tc+nuibar.*nuibar.*nuibar.*nuibar));
dtc_dw=0.25.*cla./(1+0.25.*cla.*lambdai./tc+nuibar.*nuibar.*nuibar.*nuibar);
dhcd_dw=dtc_dw.*(0.5.*a1-mu.*theta0+mu.*lambdaD./(1-0.5.*mu.*mu));
da1_dq=(-16./gamma)./(1-0.5.*mu.*mu);
dtc_dq=0.0;
dhcd_dq=0.25.*cla.*(0.5.*lambdaD+mu.*a1-mu.*mu.*theta0).*da1_dq;

xu=-tc.*da1_dmu-alfaD.*dtc_dmu-dhcd_dmu; 
xw=-tc.*da1_dw-alfaD.*dtc_dw-dhcd_dw; 
xq=-tc.*da1_dq-alfaD.*dtc_dq-dhcd_dq;
zu=-dtc_dmu; 
zw=-dtc_dw; 
zq=-dtc_dq;

mup=-(l-h.*a1s).*dtc_dmu+h.*(tc.*da1_dmu+dhcd_dmu); 
mwp=-(l-h.*a1s).*dtc_dw+h.*(tc.*da1_dw+dhcd_dw);
mqp=-(l-h.*a1s).*dtc_dq+h.*(tc.*da1_dq+dhcd_dq);

mud=mu.*mup./iB; 
mw=mu.*mwp./iB;
mq=mqp./iB;
da1_dB1=-mu.*da1_dw; 
dtc_dB1=-mu.*dtc_dw; 
dhcd_dB1=-mu.*dhcd_dw;

dtc_dT0=(cla./6.0).*(1+1.5.*mu.*mu)./(1+(0.25.*cla.*lambdai./tc).*(1+nuibar.*nuibar.*nuibar.*nuibar)); 
dlambdai_dT0=((lambdai./tc).*dtc_dT0)./(1+nuibar.*nuibar.*nuibar.*nuibar);

da1_dT0=((2.*mu)./(1-0.5.*mu.*mu)).*(1.33-dlambdai_dT0);
dlambdaD_dT0=mu.*da1_dT0-dlambdai_dT0; 
dhcd_dT0=(0.125.*cla).*((a1.*dlambdaD_dT0+lambdaD.*da1_dT0)-2.*mu.*(lambdaD+theta0.*dlambdaD_dT0));
xB1=dtc_dB1.*alfaD+tc.*(1+mu.*da1_dw)-dhcd_dB1; 
zB1=-dtc_dB1; 
mB1p=-(l-h.*a1s).*dtc_dB1-(tc.*h).*(1+mu.*da1_dw)+h.*dhcd_dB1; 
mB1=mu.*mB1p./iB;

xT0=-tc.*da1_dT0-alfaD.*dtc_dT0-dhcd_dT0;
zT0=-dtc_dT0;
mT0p=-(l-h.*a1s).*dtc_dT0+(tc.*h).*da1_dT0+h.*dhcd_dT0;
mT0=mu.*mT0p./iB;
figure(1)
plot(V,zu,'r')
hold on
plot(V,zw,'b')
hold on
plot(V,zq,'g')
hold off
tau = 0;
A = [xu xw -wc*cos(tau) xq;zu zw -wc*sin(0) mu+zq;0 0 0 1;mu+zu*mwp mw+zw*mwp -mwp*wc*sin(0) mq+mwp*(mu+zq)]
B = [xB1 zB1 0 mB1+mwp*zB1; xT0 zT0 0 mT0p+mwp*zT0]