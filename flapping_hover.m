%% rotating frame
lambda = vi_hover/gammaR;
theta = -16*pi/180;
c = 0.53;
cla = 15.73;

I_bl = 9567;
gamma_f = rho*cla*0.53*R^4/I_bl;
g1 = gamma_f/16;
beta_part = (gamma_f/8)*(theta - 4*lambda/3);
az = linspace(0,8*pi,100);
t = az/gamma;
beta_hom = beta_part.*exp(-g1.*gamma.*t).*(cos(gamma*sqrt(1-g1^2).*t) + (g1/(sqrt(1-g1^2))).*sin(gamma.*sqrt(1-g1^2).*t));
beta_r = beta_hom + beta_part;
beta_1 = beta_hom/beta_part;
plot(az,beta_1)
xlabel('azimuth')
ylabel('\beta/\beta_0')

%% non-rotating frame
 
beta_n = beta_part;