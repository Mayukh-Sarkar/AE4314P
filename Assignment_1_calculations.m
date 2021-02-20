clear all
close all
clc 

%% Helicopter Performance assignment 1 calculations
%hover
g = 9.81;
MTOW = 7708 * g;
W = MTOW;
rho = 1.225;
R = 8.18;

vi_hover = sqrt(W/(2*pi*rho*R^2))


%forward flight
V = 180*1000/3600; %m/s mission speed
% V = 82.2; %m/s max operating speed
% V = 36.11; %m/s half the operating speed
V_bar = V/vi_hover;
CDS = 1.5;
D_fus = CDS*0.5*rho*V^2;

alpha = asind(D_fus/W)

syms x
vi_bar = vpasolve(x^2 == (V_bar*cosd(alpha)^2 + (V_bar*sind(alpha)+x)^2)^(-1), x);
vi_bar = vi_bar(2,1)
V_sin = V_bar*sind(alpha)
V_cos = V_bar*cosd(alpha)

vi_forw = vi_bar * vi_hover