function [occupancy_wrr_ana, extra_waiting_for_other_class, demetres_occupancy, delta_t, delta_t_ME, cS_hat] ...
    = run_Geo_classical_WRR_2_classes_ana_v7(lambda_v, cA_in_v, credit_class_v, T_serv_v, W_1, delta_T_sim)


extra_waiting_for_other_class = 0;
demetres_occupancy = 0;
delta_t = 0;
delta_t_ME = 0;
num_class = 2;

rho_v = lambda_v.*T_serv_v;
T_serv = T_serv_v(1);

R = 0.5*rho_v(1)*(T_serv - 1) + 0.5*rho_v(2)*(T_serv - 1);
r1 = 1; r2 = 2;

% sum(queue occupancy) invariant: Demetre's model
h = 1/(1 - sum(rho_v));
a =  R + 0.5*rho_v(2)*(rho_v(1) - rho_v(2) + 1);
nq_1 = lambda_v(1)*a*h;
a =  R + 0.5*rho_v(1)*(rho_v(2) - rho_v(1) + 1);
nq_2 = lambda_v(2)*a*h;
nq_sum_model = nq_1 + nq_2;
n_sum_model = nq_sum_model + rho_v(1) + rho_v(2);

% == step(1):assume RR arbito (compute cS^2) ====
% *** busy i-cycle *** 
n_iter = 5;
for r = 1:num_class    
    other_class = 1;
    if r == 1; other_class = 2; end

    % solving a*Tc^2 + b*Tc + c = 0, Tc = effective service cycle 
    a = lambda_v(1)*lambda_v(2)*T_serv;
    b = -1;
    c = T_serv;
    Tc_model_v(r) = (-b - sqrt(b^2 - 4*a*c))/(2*a);
    for iter = 1:n_iter
        m1 = min([1, lambda_v(1)*Tc_model_v(r)]);
        m2 = min([1, lambda_v(2)*Tc_model_v(r)]);
        Tc_model_v(r) = T_serv + m1*m2*T_serv; 
    end    
end

% *** queuing model based on busy i-cycle ***
dn_sum = 0;
m = 0;
for r = 1:2
    rho_hat_v(r) = lambda_v(r)*Tc_model_v(r);
    dT(r) = Tc_model_v(r) - T_serv;
    dn_sum = dn_sum + lambda_v(r)*dT(r);
    m = m + lambda_v(r)/(1 - rho_hat_v(r));
end

R_hat = (nq_sum_model - dn_sum)/m;

for r = 1:2
    w_model_busy_cyc_v(r) = R_hat/(1 - rho_hat_v(r)) + dT(r);
    nq_model_busy_cyc_v(r) = lambda_v(r)*w_model_busy_cyc_v(r);
    n_node_busy_cyc_v(r) = nq_model_busy_cyc_v(r) + rho_hat_v(r); 
end

% === calculate cS^2 of RR ===
for r = 1:2
    cS_sqr_RR_v(r) = 0;
    if lambda_v(r) > 0
        n = n_node_busy_cyc_v(r);
        cA_sqr = 1 - lambda_v(r);
        a = 2*n*(1 - rho_hat_v(r)) - rho_hat_v(r)*(1 - rho_hat_v(r)) - rho_hat_v(r)*cA_sqr;
        b = rho_hat_v(r)*rho_hat_v(r);
        cS_sqr_RR_v(r) = a/b;
    end
end

% === Approximate cS^2 of WRR of class with high weights === 
[x, max_w_id] = max(credit_class_v);

% cS^2 of WRR: change class after full weight is used
m = credit_class_v(max_w_id);
alpha = 1/(m*m);
cS_sqr_hat = alpha*cS_sqr_RR_v(max_w_id);

% modification by SKM
% m = credit_class_v(max_w_id);
% alpha = (m*m);
% cS_sqr_hat = alpha*cS_sqr_RR_v(max_w_id);
cS_hat = sqrt(cS_sqr_hat);

%% === step (2) === 
n_iter = 5;
r = max_w_id;
other_class = 1;
if r == 1 
    other_class = 2; 
end

lambda_mult = lambda_v(1)*lambda_v(2);
% lambda_mult = lambda_v(1)*(1-lambda_v(2));
% solving a*Tc^2 + b*Tc + c = 0, Tc = effective service cycle 
% a = lambda_mult*T_serv;
k = credit_class_v(r);
% b = lambda_mult*T_serv*((-k + 1)/T_serv) - 1;
% c = 2*T_serv;
a = lambda_mult*T_serv/k;
b = - 1;
c = k*T_serv;
x = b^2 - 4*a*c;
if x < 0
    x = 0;
    b = -sqrt(4*a*c);
end
Tc_model_temp = (-b - sqrt(x))/(2*a);

for iter = 1:n_iter
%     m_r = min([1, lambda_v(r)*(Tc_model + (-k + 1)/T_serv)]);
%     m_other = min([1, lambda_v(other_class)*Tc_model]);
%     Tc_model = credit_class_v(r)*T_serv + m_r*m_other*T_serv;
%     rho_sum = rho_v(1) + rho_v(2);
%     for j = 1:2
%         if Tc_model*lambda_v(other_class) >= 1
%             Tc_model = rho_sum/lambda_v(other_class);
%         end
%     
%         if (Tc_model/credit_class_v(r))*lambda_v(r) >= 1
%             Tc_model = rho_sum/lambda_v(r);
%         end
%     end
%     
%     Tc_model = max([k*T_serv, Tc_model]);

    Tc_model_temp = max([T_serv, Tc_model_temp]);
    Tc_model_temp = min([(k + 1)*T_serv, Tc_model_temp]);
    if r == 1
        m1 = min([1, lambda_v(1)*Tc_model_temp/k]);
        m2 = min([1, lambda_v(2)*Tc_model_temp]);
    end
    if r == 2
        m1 = min([1, lambda_v(1)*Tc_model_temp]);
        m2 = min([1, lambda_v(2)*Tc_model_temp/k]);
    end
        
    Tc_model_temp = k*T_serv + m1*m2*T_serv; 
end
Tc_model = Tc_model_temp;

T_hat = Tc_model/credit_class_v(r);
rho_hat = lambda_v(r)*T_hat;
dT = T_hat - T_serv;

delta_t = dT;

cA_sqr = 1 - lambda_v(r);
nq_v(r) = 0.5*rho_hat*(rho_hat - 1 + cA_sqr + rho_hat*cS_sqr_hat)/(1 - rho_hat);
occupancy_wrr_ana(r) = nq_v(r) + lambda_v(r)*dT;
n1 = nq_v(r) + rho_hat;

n2 = n_sum_model - n1;
occupancy_wrr_ana(other_class) = n2 - rho_v(other_class);

end

