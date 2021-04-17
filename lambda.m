
CTtemp =2*lambda_i*sqrt((mu.*cos(alpha_d)).*(mu.*cos(alpha_d))+ ((mu.*sin(alpha_d))+lambda_i).*((mu.*sin(alpha_d))+lambda_i));
while C_t - CTtemp < 0.0001
    lambda_f = lambda_i- - 0.0000001;
    CTtemp =2*lambda_f*sqrt((mu.*cos(alpha_d)).*(mu.*cos(alpha_d))+ ((mu.*sin(alpha_d))+lambda_f).*((mu.*sin(alpha_d))+lambda_f));
    disp(lambda_f)
end 
