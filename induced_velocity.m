%% Helicopter Performance assignment 1 calculations
%hover
g = 9.81;
MTOW = 7708 * g;
W = MTOW;
rho = 1.225;
R = 8.18;

vi_hover = sqrt(W/(2*pi*rho*R^2))


%forward flight highspeed
V = linspace(100 ,200,5)*1000/3600;
V_bar_h = V/vi_hover;
CDS = 1.5;
D_fus_h = CDS*0.5*rho*V.*V;
alpha_h = asind(D_fus_h/W);

v_i_high = W./(2*rho*pi*R^2*V)

%forward flight low speed
V_l = linspace(25 ,100,4)*1000/3600;
V_bar_l = V_l/vi_hover;
CDS = 1.5;
D_fus_l = CDS*0.5*rho*V_l.*V_l;
alpha_l = asind(D_fus_l/W);

vi_bar = sqrt(-V_bar_l.^2/2 + sqrt(V_bar_l.^4/4 +1))
v_i_low = vi_bar * vi_hover
x = linspace(25,200,8)*1000/3600
y1 = [11.1658    8.9004    6.7082 5.2856    4.2284    3.5237    3.0203    2.6428]
y2 = [12.099 10.2994 6.3008 5.4526 4.2409 3.6351 3.0293 2.6657]
plot(x,y1,'g')
hold on
plot(x,y2,'b')
xlabel('Forward velocity(m/s)')
ylabel('induced velocity(m/s)')
legend('Glauret','Haffner')
