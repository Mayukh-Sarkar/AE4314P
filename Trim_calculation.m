%% helicopter parameters
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


%% for forward motion
V = [V_l V_h(2:end)];
v_i_m = [v_i_low v_i_high(2:end)];


%% for forward motion



D_fus = CDS*0.5*rho*V.*V; %drag force on the fuselage
T = sqrt(W^2 + D_fus.^2); %rotor thrust force

alpha_d = D_fus/W; %angle of attack of disc plane;
Ct = T/(rho*Area*v_tip^2); % coeff of thrust for the main rotor
mu = V/v_tip;
for i = 1: length(V)
    C_t = 2*lambda_i.*sqrt((V(i).*cos(D_fus(i)/W)/(v_tip)).^2 + (V(i).*sin(D_fus(i)/W)/(v_tip) + lambda_i).^2);
    
    f = @(lambda_i) Ct - 2*lambda_i.*sqrt((V(i).*cos(D_fus(i)/W)/(v_tip)).^2 + (V(i).*sin(D_fus(i)/W)/(v_tip) + lambda_i).^2);
    lambda_i(i) = fsolve(f,0);
%     A = [1+1.5*mu.^2 , -(8/3)*mu; -mu   (2/3)+mu.^2];
%     B(i) =[-2.*mu(i).^2.*(D_fus(i)/W)-2.*mu(i).*lambda_i(i) ; (4/sigma)*(Ct(i)/cla)+ mu(i).*(D_fus(i)/W)+lambda_i(i)];
%     MAT = linsolve(A,B);
end
 det = 0.67-0.67*mu.*mu+1.5*mu.*mu.*mu.*mu;
a_1 = -((-2*mu.*mu.*D_fus/W)-(2*mu.*lambda_i))./(det);
% theta_0 = ((4.*Ct)./(sigma*cla)+mu.*D_fus/W+lambda_i)./det;
% a_1 = ( (8/3).*mu.*theta_0 - 2.*mu.^2.*(D_fus/W) - 2*lambda_i)./(1+1.5.*mu.^2); 
%theta_0 = (3./(8.*mu)).*(a_1.*(1-0.5.*mu.^2)+2*mu.*lambda_i+2*mu.*alpha_d + 2.*mu.*a_1);
theta_0 = ((4.*Ct)./(sigma*cla)+mu.*D_fus/W+lambda_i)./det;
% A = [1+1.5*mu.^2 , -(8/3)*mu; -mu   (2/3)+mu.^2];
% B =[-2.*mu.^2.*(D_fus/W)-2.*mu.*lambda_i ; (4/sigma)*(Ct/cla)+ mu.*(D_fus/W)+lambda_i];
% MAT = inv(A)*B;
    

% figure;
plot(V,rad2deg(a_1), 'r')
hold on
plot(V,rad2deg(theta_0) , 'b')
hold off
% xlim([0 100])
% xlabel('V(m/s)')
% ylabel('Angle(degrees)')
% legend('cyclic pitch','collective pitch')
% grid on

