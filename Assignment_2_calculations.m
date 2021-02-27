%% Calculations assignment 2 helicopter course
clear all
close all
clc

%Ideal Power
g = 9.81;
MTOW = 9979 * g;
W = MTOW;
rho = 1.225;
R = 8.18;

P_ideal = W*sqrt(W/(2*rho*pi*R^2)) %ideal power for hovering

FM = 0.69;
P_hover_ACT = P_ideal/FM

%% Blade element theory

vi_hover = sqrt(W/(2*pi*rho*R^2))

T = W; % T = W [N] in case of 
vi = vi_hover;
%calculate C_DP_bar 
N = 4;
v_tip = 220.98; %m/s
Omega = v_tip/R; %rad/s
c = 52.73/100; %chord in m
Re = 0.97*R; %effective blade radius
C_L_bar = 6*T/(N*rho*Omega^2*c*Re^3);
C_DP_bar = 0.018;
sigma = 0.082;


P_hover_BEM = T*vi + C_DP_bar/8 * rho*sigma*(Omega*R)^3*pi*R^2

