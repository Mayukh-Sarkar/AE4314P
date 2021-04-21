
W=21582; 
R=4.91;
Iyy=4973; 
gamma=5.07; 
s=0.07;
SFP=2.3;
d=0.013;
a=5.73;
l = 0;
A = 3.14159.*R.*R;
h=0.1924;
mus=W./(9.81.*rho.*s.*A.*R);
iB=Iyy./(W.*R.*R./9.81);
d0=SFP./(s.*A);
nu0 = sqrt(W./(2.*rho.*A));
Vcap = V./v_tip;
Vbar=V./nu0;
wC=W./(rho.*s.*A.*v_tip.*v_tip);
tcD=wC;
tc=wC;
mu=V./v_tip;
hcD=0.25.*mu.*d;
nui0bar=sqrt(-0.5.*Vbar.*Vbar+sqrt(0.25.*Vbar.*Vbar.*Vbar.*Vbar+1));
nuibar=nui0bar;
lambdai = nui0bar.*nu0./v_tip;
alfaD=(-0.5.*Vcap.*Vcap.*d0+hcD)./tcD;
lambdaD=Vcap.*sin(alfaD)-lambdai;
mu=Vcap.*cos(alfaD);
theta0=((4.*tcD./a)-lambdaD.*(1-0.5.*mu.*mu)./(1+1.5.*mu.*mu)).*1.5.*(1+1.5.*mu.*mu)./(1-mu.*mu+2.25.*mu.*mu.*mu.*mu);
a1=2.*mu.*(1.33.*theta0+lambdaD)./(1+1.5.*mu.*mu);
hcD=0.25.*mu.*d;
B1=a1+hcD./wC;
a1s=a1-B1;
alfaNF=alfaD-a1;

dlambdai_dmu=(2.*mu.*theta0+alfaNF-((4.*tc)./(a.*lambdai)).*Vbar.*nuibar.*nuibar.*nuibar)./(1+(4./a).*(tc./lambdai).*(1+nuibar.*nuibar.*nuibar.*nuibar));

dlambda_dmu=alfaNF-dlambdai_dmu; 
da1_dmu=a1./mu-(2.*mu.*dlambda_dmu)./(1-0.5.*mu.*mu);

dtc_dmu=(2.*mu.*theta0+alfaNF+(Vbar.*nuibar.*nuibar.*nuibar)./(1+nuibar.*nuibar.*nuibar.*nuibar))./((4./a)+(lambdai./tc)./(1+nuibar.*nuibar.*nuibar.*nuibar));

dhcd_dmu=0.25.*d;
da1_dw=2.*mu./((1-0.5.*mu.*mu).*(1+0.25.*a.*lambdai./tc+nuibar.*nuibar.*nuibar.*nuibar));
dtc_dw=0.25.*a./(1+0.25.*a.*lambdai./tc+nuibar.*nuibar.*nuibar.*nuibar);
dhcd_dw=dtc_dw.*(0.5.*a1-mu.*theta0+mu.*lambdaD./(1-0.5.*mu.*mu));
da1_dq=(-16./gamma)./(1-0.5.*mu.*mu);
dtc_dq=0.0;
dhcd_dq=0.25.*a.*(0.5.*lambdaD+mu.*a1-mu.*mu.*theta0).*da1_dq;

xu=-tc.*da1_dmu-alfaD.*dtc_dmu-dhcd_dmu; 
xw=-tc.*da1_dw-alfaD.*dtc_dw-dhcd_dw; 
xq=-tc.*da1_dq-alfaD.*dtc_dq-dhcd_dq;
zu=-dtc_dmu; 
zw=-dtc_dw; 
zq=-dtc_dq;

mup=-(l-h.*a1s).*dtc_dmu+h.*(tc.*da1_dmu+dhcd_dmu); 
mwp=-(l-h.*a1s).*dtc_dw+h.*(tc.*da1_dw+dhcd_dw);
mqp=-(l-h.*a1s).*dtc_dq+h.*(tc.*da1_dq+dhcd_dq);

mud=mus.*mup./iB; 
mw=mus.*mwp./iB;
mq=mqp./iB;
da1_dB1=-mu.*da1_dw; 
dtc_dB1=-mu.*dtc_dw; 
dhcd_dB1=-mu.*dhcd_dw;

dtc_dT0=(a./6.0).*(1+1.5.*mu.*mu)./(1+(0.25.*a.*lambdai./tc).*(1+nuibar.*nuibar.*nuibar.*nuibar)); 
dlambdai_dT0=((lambdai./tc).*dtc_dT0)./(1+nuibar.*nuibar.*nuibar.*nuibar);

da1_dT0=((2.*mu)./(1-0.5.*mu.*mu)).*(1.33-dlambdai_dT0);
dlambdaD_dT0=mu.*da1_dT0-dlambdai_dT0; 
dhcd_dT0=(0.125.*a).*((a1.*dlambdaD_dT0+lambdaD.*da1_dT0)-2.*mu.*(lambdaD+theta0.*dlambdaD_dT0));
xB1=dtc_dB1.*alfaD+tc.*(1+mu.*da1_dw)-dhcd_dB1; 
zB1=-dtc_dB1; 
mB1p=-(l-h.*a1s).*dtc_dB1-(tc.*h).*(1+mu.*da1_dw)+h.*dhcd_dB1; 
mB1=mus.*mB1p./iB;

xT0=-tc.*da1_dT0-alfaD.*dtc_dT0-dhcd_dT0;
zT0=-dtc_dT0;
mT0p=-(l-h.*a1s).*dtc_dT0+(tc.*h).*da1_dT0+h.*dhcd_dT0;
mT0=mus.*mT0p./iB;
figure(1)
plot(V,zu,'r')
hold on
plot(V,zw,'b')
hold on
plot(V,zq,'g')
hold off
