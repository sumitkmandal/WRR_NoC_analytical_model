function [tile_to_tile_latency] = ...
    get_latency_analytical_CWRR_mesh(lambda_array, num_tiles, T_serv, weights, pb, debug_required, mode)


% lambda_array = zeros(num_tiles, num_tiles);
% % avg_latency = 0;
% tile_to_tile_latency = zeros(num_tiles, num_tiles);
% 
% for src_idx = 1:num_tiles
%     for dest_idx = 1:num_tiles
%         
%         lambda_array(src_idx, dest_idx) = lambda_in;
%         
%     end
% end


lambda_to_sink = zeros(3, num_tiles); %east, west, self
lambda_to_east = zeros(2, num_tiles); %ring, self
lambda_to_west = zeros(2, num_tiles); %ring, self


for tile_idx = 1:num_tiles
    
    if (debug_required == 1)
        fprintf('Creating injection rate for tile %d\n', tile_idx);
    end
    
    % arbitration to sink
    if (tile_idx ~= 1)
        lambda_to_sink(1, tile_idx) = sum(sum(lambda_array(1:(tile_idx-1), tile_idx)));
    end
    
    if (tile_idx ~= num_tiles)
        lambda_to_sink(2, tile_idx) = sum(sum(lambda_array((tile_idx+1):num_tiles, tile_idx)));
    end
    
    lambda_to_sink(3, tile_idx) = lambda_array(tile_idx, tile_idx);
    
    
    
    %arbitration to east
    if (tile_idx ~= 1 && tile_idx ~= num_tiles)
        lambda_to_east(1, tile_idx) = sum(sum(lambda_array(1:(tile_idx-1), (tile_idx+1):num_tiles)));
    end
    
    if (tile_idx ~= num_tiles)
        lambda_to_east(2, tile_idx) = sum(sum(lambda_array(tile_idx, (tile_idx+1):num_tiles)));
    end
    
    
    
    %arbitration to west
    if (tile_idx ~= 1 && tile_idx ~= num_tiles)
        lambda_to_west(1, tile_idx) = sum(sum(lambda_array((tile_idx+1):num_tiles, 1:(tile_idx-1))));
    end
    
    if (tile_idx ~= 1)
        lambda_to_west(2, tile_idx) = sum(sum(lambda_array(tile_idx, 1:(tile_idx-1))));
    end
end

if (debug_required == 1)
    fprintf('Injection rate creation is done\n');
end


delta_t_to_sink = zeros(3, num_tiles); %east, west, self
delta_t_to_east = zeros(2, num_tiles); %ring, self
delta_t_to_west = zeros(2, num_tiles); %ring, self


R_hat_to_sink = zeros(3, num_tiles); %east, west, self
R_hat_to_east = zeros(2, num_tiles); %ring, self
R_hat_to_west = zeros(2, num_tiles); %ring, self

occupancy_wo_split_to_sink = zeros(3, num_tiles); %east, west, self
occupancy_wo_split_to_east = zeros(2, num_tiles); %ring, self
occupancy_wo_split_to_west = zeros(2, num_tiles); %ring, self

weights_sink = [weights(2), weights(2), weights(1)]; %east, west, self
weights_east = [weights(2), weights(1)]; %ring, self
weights_west = [weights(2), weights(1)]; %ring, self

for tile_idx = 1:num_tiles
    
    
    if (debug_required == 1)
        fprintf('Analyzing CWRR for tile %d\n', tile_idx);
    end
    
    if (strcmp(mode, 'decomp'))
        
        [occupancy_wo_split_to_sink(:, tile_idx), ~, delta_t_to_sink(:, tile_idx), R_hat_to_sink(:, tile_idx)] ...
            = run_Geo_classical_WRR_3_classes_ana_decomposition(lambda_to_sink(:, tile_idx), pb, T_serv*ones(1, 3), weights_sink);
        
        [occupancy_wo_split_to_east(:, tile_idx), ~, delta_t_to_east(:, tile_idx), R_hat_to_east(:, tile_idx)] ...
            = run_Geo_classical_WRR_3_classes_ana_decomposition(lambda_to_east(:, tile_idx), pb, T_serv*ones(1, 2), weights_east);
        
        [occupancy_wo_split_to_west(:, tile_idx), ~, delta_t_to_west(:, tile_idx), R_hat_to_west(:, tile_idx)] ...
            = run_Geo_classical_WRR_3_classes_ana_decomposition(lambda_to_west(:, tile_idx), pb, T_serv*ones(1, 2), weights_west);
        %
    elseif (strcmp(mode, 'deltaT'))
        [occupancy_wo_split_to_sink(:, tile_idx), ~, delta_t_to_sink(:, tile_idx), R_hat_to_sink(:, tile_idx)] ...
            = run_Geo_classical_WRR_n_classes_ana_v1(lambda_to_sink(:, tile_idx), pb, T_serv*ones(1, 3), weights_sink, 0);
        
        [occupancy_wo_split_to_east(:, tile_idx), ~, delta_t_to_east(:, tile_idx), R_hat_to_east(:, tile_idx)] ...
            = run_Geo_classical_WRR_n_classes_ana_v1(lambda_to_east(:, tile_idx), pb, T_serv*ones(1, 2), weights_east, 0);
        
        [occupancy_wo_split_to_west(:, tile_idx), ~, delta_t_to_west(:, tile_idx), R_hat_to_west(:, tile_idx)] ...
            = run_Geo_classical_WRR_n_classes_ana_v1(lambda_to_west(:, tile_idx), pb, T_serv*ones(1, 2), weights_west, 0);
        
    else
        
        assert(1==2, 'Mode not supported');
        
    end
    
end


if (debug_required == 1)
    fprintf('CWRR analysis is done\n');
end


% compute waiting time in each queue (will add corresponding delta_t later)
queue_waiting_time = zeros(4, num_tiles); %ring_to_east, ring_to_west, self_to_east, self_to_west
total_lambda = zeros(4, num_tiles); %ring_to_east, ring_to_west, self_to_east, self_to_west
total_rho = zeros(4, num_tiles); %ring_to_east, ring_to_west, self_to_east, self_to_west
total_R_hat = zeros(4, num_tiles); %ring_to_east, ring_to_west, self_to_east, self_to_west

for tile_idx = 1:num_tiles
    
    if (debug_required == 1)
        fprintf('Analyzing individual queues for tile %d\n', tile_idx);
    end
    
    
    %ring_to_east
    total_lambda(1, tile_idx) = lambda_to_east(1, tile_idx) + lambda_to_sink(1, tile_idx);
    total_rho(1, tile_idx) = lambda_to_east(1, tile_idx)*(T_serv + delta_t_to_east(1, tile_idx)) + ...
        lambda_to_sink(1, tile_idx)*(T_serv + delta_t_to_sink(1, tile_idx));
    total_R_hat(1, tile_idx) = R_hat_to_east(1, tile_idx) + R_hat_to_sink(1, tile_idx);
    queue_waiting_time(1, tile_idx) = total_R_hat(1, tile_idx)/(1 - total_rho(1, tile_idx));
    
    
    %ring_to_west
    total_lambda(2, tile_idx) = lambda_to_west(1, tile_idx) + lambda_to_sink(2, tile_idx);
    total_rho(2, tile_idx) = lambda_to_west(1, tile_idx)*(T_serv + delta_t_to_west(1, tile_idx)) + ...
        lambda_to_sink(2, tile_idx)*(T_serv + delta_t_to_sink(2, tile_idx));
    total_R_hat(2, tile_idx) = R_hat_to_west(1, tile_idx) + R_hat_to_sink(2, tile_idx);
    queue_waiting_time(2, tile_idx) = total_R_hat(2, tile_idx)/(1 - total_rho(2, tile_idx));
    
    
    %self_to_east
    if (rem(tile_idx, 2) == 1)
        total_lambda(3, tile_idx) = lambda_to_east(2, tile_idx) + lambda_to_sink(3, tile_idx);
        total_rho(3, tile_idx) = lambda_to_east(2, tile_idx)*(T_serv + delta_t_to_east(2, tile_idx)) + ...
            lambda_to_sink(3, tile_idx)*(T_serv + delta_t_to_sink(3, tile_idx));
        total_R_hat(3, tile_idx) = R_hat_to_east(2, tile_idx) + R_hat_to_sink(3, tile_idx);
        
    else
        total_lambda(3, tile_idx) = lambda_to_east(2, tile_idx);
        total_rho(3, tile_idx) = lambda_to_east(2, tile_idx)*(T_serv + delta_t_to_east(2, tile_idx));
        total_R_hat(3, tile_idx) = R_hat_to_east(2, tile_idx);
    end
    queue_waiting_time(3, tile_idx) = total_R_hat(3, tile_idx)/(1 - total_rho(3, tile_idx));
    
    
    %self_to_west
    if (rem(tile_idx, 2) == 0)
        total_lambda(4, tile_idx) = lambda_to_west(2, tile_idx) + lambda_to_sink(3, tile_idx);
        total_rho(4, tile_idx) = lambda_to_west(2, tile_idx)*(T_serv + delta_t_to_west(2, tile_idx)) + ...
            lambda_to_sink(3, tile_idx)*(T_serv + delta_t_to_sink(3, tile_idx));
        total_R_hat(4, tile_idx) = R_hat_to_west(2, tile_idx) + R_hat_to_sink(3, tile_idx);
        
    else
        total_lambda(4, tile_idx) = lambda_to_west(2, tile_idx);
        total_rho(4, tile_idx) = lambda_to_west(2, tile_idx)*(T_serv + delta_t_to_west(2, tile_idx));
        total_R_hat(4, tile_idx) = R_hat_to_west(2, tile_idx);
    end
    queue_waiting_time(4, tile_idx) = total_R_hat(4, tile_idx)/(1 - total_rho(4, tile_idx));
end


if (debug_required == 1)
    fprintf('Queue analysis is done\n');
end

if (debug_required == 1)
    fprintf('Computing latency for each src-dest pair\n');
end

for src_idx = 1:num_tiles
    for dest_idx = 1:num_tiles
        
        total_latency = 0;
        
        if (lambda_array(src_idx, dest_idx) ~= 0)
            
%             total_latency = total_latency + abs(src_idx - dest_idx) + 1; %const_latency
            
            % at source
            if (src_idx < dest_idx) % to east
                total_latency = total_latency + queue_waiting_time(3, src_idx) + ...
                    delta_t_to_east(2, src_idx);
            elseif (src_idx > dest_idx) % to west
                total_latency = total_latency + queue_waiting_time(4, src_idx) + ...
                    delta_t_to_west(2, src_idx);
            else
                if (rem(src_idx, 2) == 1) % to east
                    total_latency = total_latency + queue_waiting_time(3, src_idx) + ...
                        delta_t_to_sink(3, src_idx);
                else % to west
                    total_latency = total_latency + queue_waiting_time(4, src_idx) + ...
                        delta_t_to_sink(3, src_idx);
                end
            end
            
            % at ring
            if (src_idx < dest_idx) % to east
                total_latency = total_latency + ...
                    sum(queue_waiting_time(1, (src_idx+1):dest_idx)) + ...
                    delta_t_to_sink(1, dest_idx);
                
                if (abs(src_idx - dest_idx) > 1)
                    
                    sum(delta_t_to_east(1, (src_idx+1):(dest_idx-1)));
                    
                end
            elseif (src_idx > dest_idx) % to west
                total_latency = total_latency + ...
                    sum(queue_waiting_time(2, dest_idx:(src_idx-1))) + ...
                    delta_t_to_sink(2, dest_idx);
                
                if (abs(src_idx - dest_idx) > 1)
                    
                    sum(delta_t_to_west(1, (dest_idx+1):(src_idx-1)));
                    
                end
            else
                % do nothing. there is no ring latency
            end
            
        end
        
        tile_to_tile_latency(src_idx, dest_idx) = total_latency;
        
    end
end

% avg_latency = sum(sum(tile_to_tile_latency.*lambda_array))/sum(sum(lambda_array));


if (debug_required == 1)
    fprintf('Modeling is done\n');
end

% % get injection rate at each ring stop
% % first ring stop is between first and second tile
% % therefore there are total five ring stops
% %at each ring stop there are three class: 1)class
% %which sinks, 2)class which is through, 3)class which is coming from the source
%
% lambda_ring_stops = zeros(3, num_tiles-1);
%
% for ring_stop_idx = 1:num_tiles-1
%     lambda_ring_stops(1, ring_stop_idx) = sum(lambda_array(1:ring_stop_idx, ring_stop_idx+1));
%
%     if (ring_stop_idx < num_tiles)
%         lambda_ring_stops(2, ring_stop_idx) = sum(sum(lambda_array(1:ring_stop_idx, (ring_stop_idx+2):num_tiles)));
%         lambda_ring_stops(3, ring_stop_idx) = sum(lambda_array(ring_stop_idx+1, (ring_stop_idx+2):num_tiles));
%     end
%
% end
%
% %compute waiting time at each class at each ring stop
% waiting_time_ring_stops = zeros(3, num_tiles);
% waiting_time_ring_stops_dummy_sim = zeros(3, num_tiles);
%
% occupancy_wrr_ana = zeros(3, num_tiles-1);
% occupancy_wrr_dummy_sim = zeros(3, num_tiles-1);
% c_D_sq_merged = zeros(1, num_tiles-1);
% cA_in_v = zeros(3, num_tiles-1);
%
% for ring_stop_idx = 1:num_tiles-1
%
%     if (ring_stop_idx == 1)
%         for class_idx = 1:3
%             cA_in_v(class_idx, ring_stop_idx) = sqrt(1 - lambda_ring_stops(class_idx, ring_stop_idx));
%         end
%     else
%         total_lambda = lambda_ring_stops(2, ring_stop_idx) + lambda_ring_stops(3, ring_stop_idx);
%         cA_in_v(1, ring_stop_idx) = sqrt((2/(1-pb))- 1 - lambda_ring_stops(1, ring_stop_idx));
%         cA_in_v(2, ring_stop_idx) = sqrt(1 + (lambda_ring_stops(2, ring_stop_idx)/total_lambda)*(c_D_sq_merged(ring_stop_idx-1) - 1));
%         cA_in_v(3, ring_stop_idx) = sqrt(1 + (lambda_ring_stops(3, ring_stop_idx)/total_lambda)*(c_D_sq_merged(ring_stop_idx-1) - 1));
%     end
%
% %     [occupancy_wrr_dummy_sim(:, ring_stop_idx), ~, delta_T] = ...
% %         run_Geo_WRR_3_classes_split_SKM_interleaved_RR(lambda_ring_stops(:, ring_stop_idx)', T_serv_class_array, 500, 0, 1E6, weight_for_3_class, 1);
% %     waiting_time_ring_stops_dummy_sim(:, ring_stop_idx) = occupancy_wrr_dummy_sim(:, ring_stop_idx)./lambda_ring_stops(:, ring_stop_idx);
%
%     [occupancy_wrr_ana(:, ring_stop_idx), c_D_sq_merged(ring_stop_idx)] = ...
%         run_Geo_WRR_3_classes_split_ana_SKM_IWRR(lambda_ring_stops(:, ring_stop_idx)', cA_in_v(:, ring_stop_idx), T_serv_class_array, pb, 0, 0, weight_for_3_class);
%     waiting_time_ring_stops(:, ring_stop_idx) = occupancy_wrr_ana(:, ring_stop_idx)./lambda_ring_stops(:, ring_stop_idx);
%
% %     [occupancy, prob_waiting_for_other_class, delta_t, service_time_class_2, num_class_2_packets, bw, actual_injection, nq_overtime] = ...
% %     run_Geo_WRR_3_classes_split_SKM_interleaved_RR(lambda_class_v, T_serv_class_v, buf_size, server_blocked_prob, sim_length_cycle, weights_v, check_only_head)
% %
%
% %     [occupancy_wrr_ana(:, ring_stop_idx), c_D_sq_merged(ring_stop_idx)] = ...
% %         run_Geo_WRR_3_classes_split_ana_explain(lambda_ring_stops(:, ring_stop_idx)', cA_in_v(:, ring_stop_idx), T_serv_class_array, 0, 0, 0);
% %     waiting_time_ring_stops(:, ring_stop_idx) = occupancy_wrr_ana(:, ring_stop_idx)./lambda_ring_stops(:, ring_stop_idx);
%
% end
%
% for ring_stop_idx = 1:num_tiles-1
%     for class_idx = 1:3
%         if isnan(waiting_time_ring_stops(class_idx, ring_stop_idx))
%             waiting_time_ring_stops(class_idx, ring_stop_idx) = 0;
%         end
%     end
% end
%
% tile_to_tile_latency = convert_waiting_time_to_tile_2_tile_lat(num_tiles, waiting_time_ring_stops);
% tile_to_tile_latency_dummy_sim = convert_waiting_time_to_tile_2_tile_lat(num_tiles, waiting_time_ring_stops_dummy_sim);
%
%
%
%
% avg_latency = sum(sum(tile_to_tile_latency.*lambda_array))/sum(sum(lambda_array));
% avg_latency_dummy_sim = sum(sum(tile_to_tile_latency_dummy_sim.*lambda_array))/sum(sum(lambda_array));


end

