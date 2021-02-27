
%% rotor powe for forward flight
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
V = [V_l V(2:end)];
P_para = CDS*0.5*rho*V.*V.*V;
v_i_bar_ = [vi_bar_low v_i_bar_high(2:end)];
p_i = 1.15 *W *vi_hover;
C_l_bar = 6*T/(N*1.225*gamma^2*c*R_e^3);
C_d_bar = 0.04;
P_pro = sigma * C_d_bar*1.225*(gammaR)^3*pi*R^2*(1+4.65*mu.^2)/8;
UPDATE
%% tail rotor power forward bem
Coeff = (1 + 1.5*mu_t.^2*R_t^2/R_e_t^2);
C_l_bar_t = 6*T_t*(R_t/R_e_t)^3./(1.225*gammaR_t^2*pi*R_t^2.*Coeff*sigma_t);
C_d_bar_t = 0.015;
p_tail = 1.1*1.3*T_t*vi_bar_t+sigma_t * C_d_bar_t*1.225*(gammaR_t)^3*pi*R_t^2*(1+4.65*mu_t.^2)/8;