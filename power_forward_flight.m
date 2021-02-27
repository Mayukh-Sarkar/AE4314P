
%% rotor powe for forward flight
V = [V_l V_h(2:end)];
v_i_bar_all = [vi_bar_low v_i_bar_h(2:end)];
sigma = 0.082;
sigma_t = 0.188;
gammaR = 220.98;
gammaR_t = 208.788;
R_t = 1.675;
mu = V/gammaR;
mu_t = V/gammaR_t;
gamma = gammaR/R;
gammat = gammaR_t/R_t;
N =4;
c_t = 0.265;
c = 0.53;
R_e = 0.87*R;
R_e_t = 0.97*R_t;
l_t = 9.926;
P_hover = 1.956*10^6;
T =W;
T_t = P_hover/(gamma*l_t);
P_para = CDS*0.5*rho*V.*V.*V/1000;
p_i = 1.15 *W *vi_hover*v_i_bar_all/1000;
C_l_bar = 6*T/(N*1.225*gamma^2*c*R_e^3);
C_d_bar = 0.04;
P_pro = sigma * C_d_bar*1.225*(gammaR)^3*pi*R^2*(1+4.65*mu.^2)/8000;

p_total = (P_pro +p_i + P_para);
figure(1)
plot(V,p_total,'b',V,P_pro,'g',V,p_i,'r',V,P_para,'k','LineWidth',1.25)
xlabel('Velocity [m/s]')
ylabel('Power[kW]')
legend('Total power','Profile power','Induced power','Parasite Power')

%% tail induced%% Helicopter Performance assignment 1 calculations
%hover


vi_hover_t = sqrt(T_t/(2*pi*rho*R_t^2));


%% forward flight highspeed
V_h = linspace(100 ,300,100)*1000/3600;
V_bar_h_t = V_h/vi_hover_t;
CDS = 1.5;
D_fus_h = CDS*0.5*rho*V_h.*V_h;
alpha_h = asind(D_fus_h/W);
%for high speed V= V_r
v_i_high_t = T_t./(2*rho*pi*R^2*V_h);
v_i_bar_h_t = v_i_high_t/vi_hover_t;

%% forward flight low speed
V_l = linspace(25 ,100,100)*1000/3600;
V_bar_l_t = V_l/vi_hover_t;
CDS = 1.5;
D_fus_l = CDS*0.5*rho*V_l.*V_l;
alpha_l = asind(D_fus_l/W);
%Approximationg for low speed
vi_bar_low_t = sqrt(-V_bar_l_t.^2/2 + sqrt(V_bar_l_t.^4/4 +1));
v_i_low_t = vi_bar_low_t * vi_hover_t;


v_i_bar_t = [vi_bar_low_t v_i_bar_h_t(2:end)];
%% tail rotor power forward bem
Coeff = (1 + 1.5*mu_t.^2*R_t^2/R_e_t^2);
C_l_bar_t = 6*T_t*(R_t/R_e_t)^3./(1.225*gammaR_t^2*pi*R_t^2.*Coeff*sigma_t);
C_d_bar_t = 0.015;
p_tail = 1.1*1.3*T_t*v_i_bar_t+sigma_t * C_d_bar_t*1.225*(gammaR_t)^3*pi*R_t^2*(1+4.65*mu_t.^2)/8;