lambda_i = v_i_hover/v_tip
%x(1) is theta_0 x(2) is thetac
% Cte = cla/4*sigma*(2/3*x(1)*(1+1.5* mu.*2) - (lambda_i+mu*alpha_d + mu*x(2)));
% a1 = (8/3*mu*x(2)-2*mu*(lambda_i + mu*alpha_d + mu*x(2)))./(1-0.5*mu.^2);
theta_0 = [];
theta_c = [];
for i = 1 : length(mu)
    f = @(x) [cla/4*sigma*(2/3*x(1))*(1+1.5* mu(i)*2) - (lambda_i+mu(i)*alpha_d + mu(i)*x(2));(8/3*mu(i)*x(2)-2.*mu(i)*(lambda_i + mu(i)*alpha_d + mu(i)*x(2)))/(1-0.5*mu(i)^2)];
        X = fsolve(f,[0,0]);
    theta_0 = [theta_0;X(1)];
    theta_c = [theta_c;X(2)];
end
figure(1);
plot(V,theta_c, 'r')
hold on
plot(V,theta_0 , 'b')
hold off