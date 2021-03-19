%% Helicopter Performance assignment 1 calculations
%hover
g = 9.81;
MTOW = 9979;
W = MTOW*g;
rho = 1.225;
R = 8.18;

vi_hover = sqrt(W/(2*pi*rho*R^2));


%% forward flight highspeed
V_h = linspace(100 ,296,100)*1000/3600;
V_bar_h = V_h/vi_hover;
CDS = 1.75;
D_fus_h = CDS*0.5*rho*V_h.*V_h;
alpha_h = asind(D_fus_h/W);
%for high speed V= V_r
v_i_high = W./(2*rho*pi*R^2*V_h);
v_i_bar_h = v_i_high/vi_hover;

%% forward flight low speed
V_l = linspace(25 ,100,100)*1000/3600;
V_bar_l = V_l/vi_hover;
CDS = 1.75;
D_fus_l = CDS*0.5*rho*V_l.*V_l;
alpha_l = asind(D_fus_l/W);
%Approximationg for low speed
vi_bar_low = sqrt(-V_bar_l.^2/2 + sqrt(V_bar_l.^4/4 +1));
v_i_low = vi_bar_low * vi_hover;
x = linspace(25,200,8)*1000/3600;
y1 = [11.1658    8.9004    6.7082 5.2856    4.2284    3.5237    3.0203    2.6428];
y2 = [12.099 10.2994 6.3008 5.4526 4.2409 3.6351 3.0293 2.6657];
plot(x,y1,'g')
hold on
plot(x,y2,'b')
xlabel('Forward velocity(m/s)')
ylabel('Induced velocity(m/s)')
legend('Glauert','Haffner')

