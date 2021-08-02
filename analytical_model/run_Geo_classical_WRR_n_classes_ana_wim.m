function [occupancy_cwrr_ana, demetres_occupancy, delta_t_out, R_hat_out] ...
    = run_Geo_classical_WRR_n_classes_ana_wim(lambda_v, pb, T_serv_v, weights_class_v, weighted_coeff)


demetres_occupancy = 0;
num_class = length(lambda_v);
occupancy_cwrr_ana = zeros(1, num_class);
T_serv = T_serv_v(1);  %assuming equal service time

rho_v = lambda_v.*T_serv;
rho_tot = sum(rho_v);
cA_in_v = 2/(1-pb) - 1 - lambda_v;

modif_serv_time = zeros(1, num_class);
R = zeros(1, num_class);
W_ana = zeros(1, num_class);

for class_idx = 1:num_class
    
    if (lambda_v(class_idx) ~= 0)
        
        other_class = setdiff(1:num_class, class_idx); %extract other classes
        sum_other_class_rho = sum(rho_v(other_class));
        modif_serv_time(class_idx) = T_serv/(1 - sum_other_class_rho);
        lambda_other_class_sum = sum(lambda_v(other_class));
        
        modif_serv_time(class_idx) = ...
            T_serv + min(1, lambda_other_class_sum*modif_serv_time(class_idx))*T_serv;
        
        
%         if (modif_serv_time(class_idx) == T_serv)
%             den = 1;
%         else
            den = (rho_v(class_idx)*(1 - (lambda_v(class_idx)/(1 - rho_tot)))*(1/(1 - lambda_v(class_idx)*modif_serv_time(class_idx))));
%         end
        num = lambda_v(class_idx)*T_serv_v(class_idx)^2;
        
        for idx = 1:length(other_class)
            
            other_class_idx = other_class(idx);
            lambda_other_class = lambda_v(other_class_idx);
            %         modif_serv_other_class = modif_serv_time(other_class_idx);
            
            if (lambda_other_class ~= 0)
                
                den = den + ...
                    rho_v(other_class_idx)*(1 - (lambda_v(other_class_idx)/(1 - rho_tot)))*...
                    (1/(1 - modif_serv_time(other_class_idx)))*(modif_serv_time(class_idx)/modif_serv_time(other_class_idx));
                
                
                num = num + lambda_v(other_class_idx)*T_serv_v(other_class_idx)^2;
                
            end
            
        end
        
        num = num*rho_tot/(2*(1 - rho_tot));
        
        R(class_idx) = num/den;
        
        W_ana(class_idx) = R(class_idx)/(1 - lambda_v(class_idx)*modif_serv_time(class_idx));
        occupancy_cwrr_ana(class_idx) = W_ana(class_idx).*modif_serv_time(class_idx);
        
    end
    
    
end

delta_t_out = modif_serv_time - T_serv;

R_hat_out = (W_ana - delta_t_out)*(1 - lambda_v*T_serv);

end

