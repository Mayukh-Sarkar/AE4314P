<<<<<<< Updated upstream

CTtemp =2*lambda_i*sqrt((mu.*cos(alpha_d)).*(mu.*cos(alpha_d))+ ((mu.*sin(alpha_d))+lambda_i).*((mu.*sin(alpha_d))+lambda_i));
while C_t - CTtemp < 0.0001
    lambda_f = lambda_i- - 0.0000001;
    CTtemp =2*lambda_f*sqrt((mu.*cos(alpha_d)).*(mu.*cos(alpha_d))+ ((mu.*sin(alpha_d))+lambda_f).*((mu.*sin(alpha_d))+lambda_f));
    disp(lambda_f)
end 
=======
for i = 1: length(C_t)
    y = @(x) C_t(i)-2*x.*sqrt((mu(i).*cos(alpha_d)).*(mu(i).*cos(alpha_d))+((mu(i).*sin(alpha_d))+x).*((mu(i).*sin(alpha_d)+x)));
    X = fzero(y,0);
end
>>>>>>> Stashed changes
