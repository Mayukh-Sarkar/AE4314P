%% rotating frame
lambda = vi_hover/gammaR;
theta = degtorad(-16);
c = 0.53;
cla = 7.73;
m = 127.8;
I_bl = m*R^2/3 ;
gamma_f = rho*cla*c*R^4/I_bl;
g1 = gamma_f/16;
beta_part = (gamma_f/8)*(theta - 4*lambda/3);
az = linspace(0,degtorad(700),100);
t = az/gamma;
beta_hom = beta_part.*exp(-g1.*gamma.*t).*(cos(gamma*sqrt(1-g1^2).*t) + (g1/(sqrt(1-g1^2))).*sin(gamma.*sqrt(1-g1^2).*t));
beta_r = beta_hom + beta_part;
beta_1 = beta_hom/beta_part;
plot(az,beta_1,'r','LineWidth' ,1.25)
xlabel('azimuth(rad)')
ylabel('\beta/\beta_0')

%% non-rotating frame
 
beta_n = beta_part;