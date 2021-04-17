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
V = linspace(0,100,100);

for i = 1 : length(V) % hover to max speed in m/s
    D_fus = CDS*0.5*rho*V.*V; %drag force on the fuselage
    T = sqrt(W^2+ D_fus.*D_fus); %rotor thrust force
    alpha_d = D_fus/W; %angle of attack of disc plane;
    C_t = T/(rho*Area*v_tip^2); % coeff of thrust for the main rotor
    mu = V/v_tip;
%matrix
    CTtemp =2*lambda_i*sqrt((mu.*cos(alpha_d)).*(mu.*cos(alpha_d))+ ((mu.*sin(alpha_d))+lambda_i).*((mu.*sin(alpha_d))+lambda_i));
    while mean(abs(C_t - CTtemp)) <= 0.0001
    lambda_f = lambda_i - 0.0001;
    CTtemp =2*lambda_f*sqrt((mu.*cos(alpha_d)).*(mu.*cos(alpha_d))+ ((mu.*sin(alpha_d))+lambda_f).*((mu.*sin(alpha_d))+lambda_f));
    disp(lambda_f)
    end 
   
    det = 0.67-0.67*mu.*mu+1.5*mu.*mu.*mu.*mu;
    a_1 = -((-2*mu.*mu.*D_fus/W)-(2*mu.*lambda_f))./det;
    theta_0 = ((4*C_t)/(sigma*cla)+mu.*D_fus/W+lambda_f)./det;

end 
figure(1);
plot(V,a_1, 'r')
hold on
plot(V,theta_0 , 'b')
hold off