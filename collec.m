MTOW = 9979; %maximum takeoff weight
g = 9.81; % acc due to gravity
R = 8.18; % radius of main rotor
rho = 1.225; % density at sea level
sigma  = 0.082; %solidity of main rotor
v_tip = 220.98; %m/s , rotor tip velocity gammaR
cla = 5.73 ;%rad
Area = pi*R^2; % area of the rotor blade 
W = MTOW *g; %weight of the helicopter
CDS = 1.5; %coeff od drag*surface area
v_i_hover = sqrt(W/(2*rho*Area)); %induced hover velocity
lambda_i = v_i_hover/v_tip; % non-dim induced velocity

v_tip = 220.98;
lambda_i = v_i_hover/v_tip;
%x(1) is theta_0 x(2) is thetac
% Cte = cla/4*sigma*(2/3*x(1)*(1+1.5* mu.*2) - (lambda_i+mu*alpha_d + mu*x(2)));
% a1 = (8/3*mu*x(2)-2*mu*(lambda_i + mu*alpha_d + mu*x(2)))./(1-0.5*mu.^2);
V = [V_l V_h(2:end)];
disp(V)
v_i_m = [v_i_low v_i_high(2:end)];
%Ct = T/(rho*Area*v_tip^2);
    D_fus = CDS*0.5*rho*V.*V; %drag force on the fuselage
    T = sqrt(W^2 + D_fus.^2);
    Ct = T/(rho*Area*v_tip^2);
    mu = V/v_tip;
    lambda_i = v_i_hover/v_tip;
for i = 1 : length(V)
    lambda_i_list = [];
    C_t = 2*lambda_i.*sqrt((V(i).*cos(D_fus/W)/(v_tip)).^2 + (V(i).*sin(D_fus(i)/W)/(v_tip) + lambda_i).^2);
    
    f = @(lambda_i) Ct - 2*lambda_i.*sqrt((V(i).*cos(D_fus(i)/W)/(v_tip)).^2 + (V(i).*sin(D_fus(i)/W)/(v_tip) + lambda_i).^2);

    lambda_i = fzero(f,0);
    lambda_i_list = [lambda_i_list;lambda_i];
end

%     f = @(lambda_i) Ct(i)-2*lambda_i.*sqrt((V.*cos(D_fus/W)/(v_tip)).^2 + (V.*sin(D_fus/W)/(v_tip) + lambda_i).^2);
%     lambda_i = fsolve(f,0);
%     lambda_i_list = [lambda_i_list;lambda_i];
    %C_t = 2*lambda_i.*sqrt((V.*cos(D_fus/W)/(v_tip)).^2 + (V.*sin(D_fus/W)/(v_tip) + lambda_i).^2);
    A = [1+1.5*mu.^2 , -(8/3)*mu; -mu   (2/3)+mu.^2];
    B =[-2.*mu.^2.*(D_fus/W)-2.*mu.*lambda_i ; (4/sigma)*(C_t/cla)+ mu.*(D_fus/W) + lambda_i];
    
    x = linsolve(A,B);

% figure(1);
% plot(V,, 'r')
% hold on
% plot(V,theta_0 , 'b')
% hold off