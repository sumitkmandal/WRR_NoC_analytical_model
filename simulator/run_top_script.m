%This code assumes half ring to east direction only with single memory
%controller

clc
clear
close all
tic

%7 node
% lambda = 0.005:0.005:0.060;
% num_node = 7;

%8 node
lambda = 0.004:0.004:0.048;
num_node = 8;

%6 node
%read latency data from mat file
% latency_data_struct = load('outputs/average_latency_tile_to_tile');
% latency_sim = latency_data_struct.average_latency_tile_to_tile_data;
% data_size = length(latency_sim(:,1,1)) - 1;
% latency_sim = latency_sim(2:data_size+1,:,:);
% num_node = 6;
% lambda = 0.005:0.005:0.005*data_size;
% latency_array_simulation = zeros(data_size, num_node);

latency_array_analyt = zeros(length(lambda), num_node);

for index = 1:length(lambda)
    
    %generate custom injection rate
    lambda_array = zeros(num_node, num_node); %(src, dest)
    for i = 1:num_node
        for j = i:num_node
            lambda_array(i,j) = lambda(index);
        end
    end
    
    for i = 1:num_node
        if (rem(i,2) == 0)
            lambda_array(i, i) = 0;
        end
    end    
    
    %comment below for other than 6 nodes
%     lambda_tot = zeros(length(lambda), num_node);
%     latency_dest = zeros(1, num_node);
%     for dest_idx = 1:num_node
%         lambda_tot = 0;
%         q_time_tot = 0;
%         for src_idx = 1:num_node
%             q_time_tot = q_time_tot + latency_sim(index, dest_idx, src_idx)*lambda_array(src_idx, dest_idx);
%             lambda_tot = lambda_tot + lambda_array(src_idx, dest_idx);
%         end
%         latency_dest(dest_idx) = q_time_tot/lambda_tot;
%     end
%     latency_array_simulation(index, :) = latency_dest;
    
    serv_time = 1;
    vac_time = 1;
    
    %main function to compute (src, dest) queuing time
    [ queuing_time ] = get_Q_time_from_generalized_model( num_node, lambda_array, serv_time, vac_time );
    
    %modify queuing time to xPlore style reporting
    
    latency_dest = zeros(1, num_node);
    
    for dest = 1:num_node
        lambda_tot = 0;
        q_time_tot = 0;
        for src = 1:num_node
            lambda_tot = lambda_tot + lambda_array(src, dest);
            q_time_tot = q_time_tot + (queuing_time(src, dest) + abs(src - dest) + 1)*lambda_array(src, dest);
        end
        if (lambda_tot == 0)
            latency_dest(dest) = 0;
        else
            latency_dest(dest) = q_time_tot/lambda_tot;
        end
    end
    latency_array_analyt(index,:) = latency_dest;
end

latency_array_analyt;

%7 nodes
% latency_array_simulation = [1.52 2.51 2.55 3.56 3.59 4.56 4.59;
%                             1.54 2.53 2.62 3.62 3.69 4.64 4.72;
%                             1.57 2.55 2.69 3.69 3.82 4.72 4.86;
%                             1.59 2.57 2.77 3.77 3.98 4.82 5.04;
%                             1.63 2.59 2.87 3.87 4.17 4.93 5.26;
%                             1.66 2.61 3.00 3.98 4.42 5.06 5.54;
%                             1.70 2.63 3.16 4.12 4.75 5.21 5.92;
%                             1.74 2.66 3.36 4.29 5.21 5.40 6.44;
%                             1.78 2.69 3.63 4.50 5.90 5.63 7.20;
%                             1.83 2.71 4.01 4.78 7.07 5.91 8.44;
%                             1.89 2.75 4.55 5.15 9.67 6.29 10.94;
%                             1.96 2.78 5.45 5.67 22.12 6.78 21.00];

%8 nodes
latency_array_simulation = [1.52 2.51 2.55 3.57 3.58 4.59 4.57 5.60;
                            1.54 2.53 2.59 3.65 3.65 4.71 4.66 5.71
                            1.56 2.56 2.64 3.73 3.74 4.84 4.77 5.85
                            1.57 2.57 2.71 3.84 3.85 5.01 4.89 6.01
                            1.59 2.59 2.77 3.98 3.98 5.22 5.04 6.21
                            1.62 2.62 2.85 4.15 4.13 5.50 5.21 6.47
                            1.65 2.65 2.94 4.36 4.31 5.88 5.42 6.81
                            1.67 2.67 3.06 4.65 4.54 6.42 5.68 7.29
                            1.70 2.70 3.19 5.06 4.83 7.24 6.00 7.97
                            1.74 2.73 3.35 5.66 5.21 8.71 6.44 9.17
                            1.77 2.77 3.56 6.70 5.74 12.06 7.01 11.71
                            1.81 2.82 3.83 8.86 6.51 27.55 7.85 22.92];
                        
sum_latency_overall_sim = zeros(length(lambda), 1);
sum_latency_overall_ana = zeros(length(lambda), 1);

for node_idx = 1:num_node
    sum_latency_overall_sim = sum_latency_overall_sim + latency_array_simulation(:,node_idx);
    sum_latency_overall_ana = sum_latency_overall_ana + latency_array_analyt(:, node_idx);
end

avg_latency_overall_sim = sum_latency_overall_sim./num_node;
avg_latency_overall_ana = sum_latency_overall_ana./num_node;

100 - mean(abs(avg_latency_overall_sim - avg_latency_overall_ana)./avg_latency_overall_sim)

%data normalization

max_sim = max(avg_latency_overall_sim);
max_ana = max(avg_latency_overall_ana);

max_latency = max(max_sim, max_ana);

avg_latency_overall_sim = avg_latency_overall_sim./max_latency;
avg_latency_overall_ana = avg_latency_overall_ana./max_latency;


f1 = plot(lambda, avg_latency_overall_sim, '^-k');
set(f1,'LineWidth', 1.4, 'MarkerSize', 11);
hold on;

f2 = plot(lambda, avg_latency_overall_ana, '*-r');
set(f2,'LineWidth', 1.4, 'MarkerSize', 11);
xlabel('Injection rate (\lambda tokens/cycle)', 'FontSize', 14, 'FontWeight', 'bold');
xticks([lambda(1) lambda(2) lambda(3) lambda(4) lambda(5) lambda(6) lambda(7) lambda(8) lambda(9) lambda(10) lambda(11) lambda(12) lambda(13) lambda(14) lambda(15) lambda(16)])
% set(gca, 'XTickLabel', {'\lambda_1', '\lambda_2', '\lambda_3', '\lambda_4', '\lambda_5', '\lambda_6', '\lambda_7', '\lambda_8', '\lambda_9', '\lambda_{10}', '\lambda_{11}', '\lambda_{12}', '\lambda_{13}', '\lambda_{14}'});
set(gca, 'XTickLabel', {'\lambda_1', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '\lambda_{max}'});

y = sprintf('Average latency (normalized)');
ylabel(y, 'FontSize', 14, 'FontWeight', 'bold');

t = sprintf('Simulation vs analytical');
title(t, 'FontSize', 14, 'FontWeight', 'bold');
set(f1,'LineWidth', 1.4, 'MarkerSize', 11);
legend('Simulaiton', 'Analytical');
legend('show');
legend('location', 'northwest');
grid on
                            
toc