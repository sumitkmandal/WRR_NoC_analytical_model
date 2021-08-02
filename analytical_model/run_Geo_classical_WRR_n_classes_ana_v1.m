function [occupancy_cwrr_ana, demetres_occupancy, delta_t_out, R_hat_out] ...
    = run_Geo_classical_WRR_n_classes_ana_v1(lambda_v, pb, T_serv_v, weights_class_v, weighted_coeff)


num_class = length(lambda_v);
occupancy_cwrr_ana = zeros(1, num_class);
T_serv = T_serv_v(1);  %assuming equal service time

rho_v = lambda_v.*T_serv;
cA_in_v = 2/(1-pb) - 1 - lambda_v;

% R = 0.5*rho_v(1)*(T_serv - 1) + 0.5*rho_v(2)*(T_serv - 1);
% r1 = 1; r2 = 2;
%
% % sum(queue occupancy) invariant: Demetre's model
% h = 1/(1 - sum(rho_v));
% a =  R + 0.5*rho_v(2)*(rho_v(1) - rho_v(2) + 1);
% nq_1 = lambda_v(1)*a*h;
% a =  R + 0.5*rho_v(1)*(rho_v(2) - rho_v(1) + 1);
% nq_2 = lambda_v(2)*a*h;
% nq_sum_model = nq_1 + nq_2;
% n_sum_model = nq_sum_model + rho_v(1) + rho_v(2);

% R = 0.5*rho_v(1)*(T_serv - 1) + 0.5*rho_v(2)*(T_serv - 1) + 0.5*rho_v(3)*(T_serv - 1);
% h = 1/(1 - sum(rho_v));
% a =  R + 0.5*(rho_v(2) + rho_v(3))*(rho_v(1) - (rho_v(2) + rho_v(3)) + 1);
% nq_1 = lambda_v(1)*a*h;
%
% a =  R + 0.5*(rho_v(1) + rho_v(3))*(rho_v(2) - (rho_v(1) + rho_v(3)) + 1);
% nq_2 = lambda_v(2)*a*h;
%
% a =  R + 0.5*(rho_v(1) + rho_v(2))*(rho_v(3) - (rho_v(1) + rho_v(2)) + 1);
% nq_3 = lambda_v(3)*a*h;

occupancy_rr_ana = zeros(1, num_class);


%obtain the residual time
residual_time = 0;
for class_idx = 1:num_class
    
    if (lambda_v(class_idx) ~= 0)
        
        residual_time = residual_time + 0.5*T_serv*(rho_v(class_idx) - 1 + cA_in_v(class_idx));
        
    end
end

% for class_idx = 1:num_class
%
%
%     if (lambda_v(class_idx) ~= 0)
%
%         other_class = setdiff(1:num_class, class_idx); %extract other classes
%         sum_other_class_rho = sum(rho_v(other_class));
%
%         interim_term = residual_time + 0.5*sum_other_class_rho*(rho_v(class_idx) - sum_other_class_rho + 1);
%         occupancy_rr_ana(class_idx) = lambda_v(class_idx)*occupancy_rr_ana(class_idx)*interim_term/(1 - sum(rho_v));
% %
% %         sum_term = 0;
% %         for sum_idx = 1:num_class
% %             if lambda_v(sum_idx) ~= 0
% %                 sum_term = sum_term + (lambda_v(class_idx)/lambda_v(sum_idx))*rho_v(sum_idx)^2*cA_in_v(sum_idx);
% %             end
% %         end
% %
% %         sum_term = 0.5*sum_term/(1 - sum(rho_v));
% %
% %         occupancy_rr_ana(class_idx) = occupancy_rr_ana(class_idx) + sum_term;
%
%     end
%
%
% end

for class_idx = 1:num_class
    
    
    if (lambda_v(class_idx) ~= 0)
        
        occupancy_rr_ana(class_idx) = 0.5*rho_v(class_idx)*(cA_in_v(class_idx) - 1);
        %         occupancy_rr_ana(class_idx) = 0.5*T_serv*(rho_v(class_idx) - 1 + cA_in_v(class_idx));
        
        sum_term = 0;
        for sum_idx = 1:num_class
            if lambda_v(sum_idx) ~= 0
                sum_term = sum_term + (lambda_v(class_idx)/lambda_v(sum_idx))*rho_v(sum_idx)^2*cA_in_v(sum_idx);
            end
        end
        
        sum_term = 0.5*sum_term/(1 - sum(rho_v));
        
        occupancy_rr_ana(class_idx) = occupancy_rr_ana(class_idx) + sum_term;
        
    end
    
    
end




demetres_occupancy = sum(occupancy_rr_ana);

% == step(1):assume RR arbito (compute cS^2) ====
% *** busy i-cycle ***
num_iter = 11;
T_busy_cycle_model_v_new = T_serv*ones(num_iter, num_class);
for iter_idx = 1:(num_iter-1)
    
    for class_idx = 1:num_class
        
        if (lambda_v(class_idx) ~= 0)
            
            other_class = setdiff(1:num_class, class_idx); %extract other classes
            
            T_busy_cycle_model_v_new(iter_idx+1, class_idx) = T_serv;
            
            for other_class_idx = 1:length(other_class)
                
                if (lambda_v(other_class_idx) ~= 0)
                    
                    %                     T_busy_cycle_model_v_new(iter_idx+1, class_idx) = T_busy_cycle_model_v_new(iter_idx+1, class_idx) + ...
                    %                         min(1, lambda_v_decomposed(other_class(other_class_idx))*T_busy_cycle_model_v_new(iter_idx, class_idx))*...
                    %                         min(1, lambda_v_decomposed(class_idx)*T_busy_cycle_model_v_new(iter_idx, class_idx))*...
                    %                         T_serv;
                    
                    T_busy_cycle_model_v_new(iter_idx+1, class_idx) = T_serv + ...
                        min(1, lambda_v(other_class(other_class_idx))*T_busy_cycle_model_v_new(iter_idx, class_idx))*...
                        min(1, lambda_v(class_idx)*T_busy_cycle_model_v_new(iter_idx, class_idx))*...
                        T_serv;
                    
                end
                
            end
            
        end
    end
    
end


% *** model based on busy cycle ***
dn_sum = 0;
m = 0;
for class_idx = 1:num_class
    rho_hat_v(class_idx) = lambda_v(class_idx)*T_busy_cycle_model_v_new(num_iter, class_idx);
    delta_t(class_idx) = T_busy_cycle_model_v_new(num_iter, class_idx) - T_serv;
    dn_sum = dn_sum + lambda_v(class_idx)*delta_t(class_idx);
    m = m + lambda_v(class_idx)/(1 - rho_hat_v(class_idx));
end

R_hat = (demetres_occupancy - dn_sum)/m;

for class_idx = 1:num_class
    w_model_busy_cyc_v(class_idx) = R_hat/(1 - rho_hat_v(class_idx)) + delta_t(class_idx);
    nq_model_busy_cyc_v(class_idx) = lambda_v(class_idx)*w_model_busy_cyc_v(class_idx);
    n_node_busy_cyc_v(class_idx) = nq_model_busy_cyc_v(class_idx) + rho_hat_v(class_idx);
end

waiting_time_cwrr_ana = zeros(1, num_class);
occupancy_cwrr_ana = zeros(1, num_class);
delta_t_out = zeros(1, num_class);
rho_hat = zeros(1, num_class);

if (sum(weights_class_v) == num_class) % round robin, dont do rest of the steps
    
    for class_idx  = 1:num_class
       
        if (lambda_v(class_idx) ~= 0)
            
            occupancy_cwrr_ana = nq_model_busy_cyc_v;
            delta_t_out = delta_t;
            rho_hat = lambda_v.*(T_serv + delta_t);
            
        end
    
    end
    
else
    
    
    % === calculate cS^2 of RR ===
    for class_idx = 1:num_class
        cS_sqr_RR_v(class_idx) = 0;
        if lambda_v(class_idx) > 0
            n = n_node_busy_cyc_v(class_idx);
            cA_sqr = cA_in_v(class_idx);
            a = 2*n*(1 - rho_hat_v(class_idx)) - rho_hat_v(class_idx)*(1 - rho_hat_v(class_idx)) - rho_hat_v(class_idx)*cA_sqr;
            b = rho_hat_v(class_idx)*rho_hat_v(class_idx);
            cS_sqr_RR_v(class_idx) = a/b;
            
            %         if (cS_sqr_RR_v(class_idx) < 0)
            %             cS_sqr_RR_v(class_idx) = 0;
            %         end
            
        end
    end
    
    % === Approximate cS^2 of WRR of class with high weights ===
    % [x, max_w_id] = max(credit_class_v);
    
    % cS^2 of WRR: change class after full weight is used
    % m = credit_class_v(max_w_id);
    % alpha = 1/(m*m);
    % cS_sqr_hat = alpha*cS_sqr_RR_v(max_w_id);
    
    if (pb > 0)
        cS_sqr_hat = cS_sqr_RR_v./(weights_class_v/min(weights_class_v));
    else
        %     cS_sqr_hat = cS_sqr_RR_v/(max(weights_class_v)^2);
        cS_sqr_hat = cS_sqr_RR_v./sqrt((weights_class_v/min(weights_class_v)));
    end
    % cS_sqr_hat = cS_sqr_RR_v/(max(weights_class_v)^2);
    % modification by SKM
    % m = credit_class_v(max_w_id);
    % alpha = (m*m);
    % cS_sqr_hat = alpha*cS_sqr_RR_v(max_w_id);
    % cS_hat(1) = sqrt(cS_sqr_hat);
    
    %% === step (2) ===
    n_iter = 11;
    Tc_model_temp = T_serv*ones(1, num_class);
    
    for class_idx = 1:num_class
        
        if (lambda_v(class_idx) ~= 0)
            
            other_class = setdiff(1:num_class, class_idx);
            num_other_class = length(other_class);
            
            lambda_mult = 0;
            
            for other_class_idx = 1:num_other_class
                
                other_class_id = other_class(other_class_idx);
                if (lambda_v(other_class_id) ~= 0)
                    
                    weight_coeff = 0;
                    for weight_idx = 1:weights_class_v(other_class_id)
                        weight_coeff = weight_coeff + 1/weight_idx;
                    end
                    
                    if (weighted_coeff == 1)
                        lambda_mult = lambda_mult + lambda_v(other_class_id)*weight_coeff;
                    else
                        lambda_mult = lambda_mult + lambda_v(other_class_id)*weights_class_v(other_class_id);
                    end
                    
                end
                
            end
            lambda_mult = lambda_mult*lambda_v(class_idx);
            a = lambda_mult*T_serv/weights_class_v(class_idx);
            b = -1;
            c = weights_class_v(class_idx)*T_serv;
            
            x = b^2 - 4*a*c;
            
            if x < 0
                x = 0;
                %             b = -sqrt(4*a*c);
                a = b^2/(4*c);
            end
            
            Tc_model_temp(class_idx) = (-b-sqrt(x))/(2*a);
            
            for iter = 1:n_iter
                
                Tc_model_temp(class_idx) = max([T_serv, Tc_model_temp(class_idx)]);
                Tc_model_temp(class_idx) = min([(weights_class_v(class_idx) + 1)*T_serv, Tc_model_temp(class_idx)]);
                
                m1 = min([lambda_v(class_idx)*Tc_model_temp(class_idx)/weights_class_v(class_idx), 1]);
                m2 = 0;
                
                for other_class_idx = 1:num_other_class
                    
                    
                    other_class_id = other_class(other_class_idx);
                    if (lambda_v(other_class_id) ~= 0)
                        
                        weight_coeff = 0;
                        
                        for weight_idx = 1:weights_class_v(other_class_id)
                            weight_coeff = weight_coeff + 1/weight_idx;
                        end
                        
                        if (weighted_coeff == 1)
                            m2 = m2 + ...
                                min([lambda_v(other_class_idx)*Tc_model_temp(class_idx)*weight_coeff, 1]);
                        else
                            m2 = m2 + ...
                                min([lambda_v(other_class_id)*Tc_model_temp(class_idx)*weights_class_v(other_class_id), 1]);
                        end
                    end
                end
                
                Tc_model_temp(class_idx) = weights_class_v(class_idx)*T_serv + m1*m2*T_serv;
                
            end
            
        end
        
    end
    
    T_hat = ones(1, num_class);
    for class_idx = 1:num_class
        
        if (lambda_v(class_idx) ~= 0)
            
            T_hat(class_idx) = Tc_model_temp(class_idx)/weights_class_v(class_idx);
            
        end
        
        
    end
    
    % T_hat = Tc_model_temp./weights_class_v;
    % T_hat_2 = (Tc_model_temp - T_serv*weights_class_v) + T_serv;
    %
    % T_hat = (T_hat_1 + T_hat_2)/2;
    
    rho_hat = lambda_v'.*T_hat;
    delta_t_out = T_hat - T_serv;
    
    % obtain Cs^2 through the invariant
    
    A = 0;
    B = 0;
    
    for class_idx = 1:num_class
        
        if (lambda_v(class_idx) ~= 0)
            cA_sqr = cA_in_v(class_idx);
            A = A + 0.5*(rho_hat(class_idx)*(rho_hat(class_idx) - 1 + cA_sqr))/(1 - rho_hat(class_idx)) + lambda_v(class_idx)*delta_t_out(class_idx);
            B = B + rho_hat(class_idx)*cS_sqr_RR_v(class_idx)/(weights_class_v(class_idx)*(1 - rho_hat(class_idx)));
        end
        
    end
    
    if (B == 0)
        cs_factor = 0;
    else
        difference = (demetres_occupancy - A);
        
        if difference < 0.0001
            cs_factor = 0;
        else
            cs_factor = (demetres_occupancy - A)/B;
        end
    end
    
    for class_idx = 1:num_class
        
        cA_sqr = cA_in_v(class_idx);
        nq_v(class_idx) = 0.5*rho_hat(class_idx)*(rho_hat(class_idx) - 1 + cA_sqr + rho_hat(class_idx)*cS_sqr_hat(class_idx))/(1 - rho_hat(class_idx));
        occupancy_cwrr_ana(class_idx) = nq_v(class_idx) + lambda_v(class_idx)*delta_t_out(class_idx);
        
        %     nq_v_1(class_idx) = 0.5*rho_hat(class_idx)*(rho_hat(class_idx) - 1 + cA_sqr + rho_hat(class_idx)*cs_factor*cS_sqr_RR_v(class_idx)/weights_class_v(class_idx))...
        %         /(1 - rho_hat(class_idx)) + lambda_v(class_idx)*delta_t_out(class_idx);
        %     occupancy_cwrr_ana(class_idx) = nq_v_1(class_idx);
        
        %     n1 = nq_v(class_idx) + rho_hat;
        
        
    end
end
%second pass for delta_t
p0_v = zeros(1, num_class);
T_hat_ME = T_serv*ones(1, num_class);

for class_idx = 1:num_class
    
    other_class = setdiff(1:num_class, class_idx); %extract other classes
    
    if (lambda_v(class_idx) ~= 0 && sum(lambda_v(other_class)) ~= 0)
        
        
        
        rho_self = rho_v(class_idx);
        rho_others = sum(rho_v(other_class));
        %             p0_v(class_idx) = 1 - rho_self - rho_others*(occupancy_cwrr_ana(class_idx) + rho_hat(class_idx) - rho_self)/(occupancy_cwrr_ana(class_idx) + rho_hat(class_idx) + rho_others);
        p0_v(class_idx) = 1 - rho_self - rho_others*(occupancy_cwrr_ana(class_idx))/(occupancy_cwrr_ana(class_idx) + rho_others);
        T_hat_ME(class_idx) = (1 - p0_v(class_idx))/lambda_v(class_idx);
        
        
    end
    
end

delta_t_ME = T_hat_ME - T_serv;
% delta_t_out = (delta_t_ME + delta_t_out)/2;

if (sum(weights_class_v) == num_class)
    
    delta_t_out = delta_t_ME;
    
end


R_hat_out = zeros(1, num_class);

for class_idx = 1:num_class
    
    if (lambda_v(class_idx) ~= 0)
        
        waiting_time_cwrr_ana(class_idx) = occupancy_cwrr_ana(class_idx)/lambda_v(class_idx) + delta_t_out(class_idx);
%         waiting_time_cwrr_ana(class_idx) = occupancy_cwrr_ana(class_idx)/lambda_v(class_idx);
        R_hat_out(class_idx) = (waiting_time_cwrr_ana(class_idx) - delta_t_out(class_idx))*(1 - rho_hat(class_idx)) - T_serv*pb/(1-pb);
        %         R_hat_out(class_idx) = (waiting_time_cwrr_ana(class_idx) - delta_t_out(class_idx))*(1 - rho_hat(class_idx));
    end
    
    
end


end

