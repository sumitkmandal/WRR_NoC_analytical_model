clc
clear
% close all

setCustomFigParameters

num_tiles = 64;
NO_OF_COLS = 8;
NO_OF_ROWS = 8;

T_serv = 1;
debug_required = 0;

sinkprob = 1;
weights = [1 1]; %[source, ring]
sim_length = 100000;
% pb_array = 0:0.1:0.3;
pb_array = 0;
% Traffic in east direction without self transactions

% inj_rate_array = [0.001:0.001:0.006 0.0065 0.0066 0.007];
inj_rate_array = [0.001:0.001:0.006 0.0065 0.0067];
% inj_rate_array = [0.002 0.005];
% inj_rate_array = 0.007;
% lambda_array = [0.052:0.001:0.054];
% lambda_array = 0.055;
% lambda_array = 0.096;


mode = 'deltaT';%'decomp'; %'deltaT'


%% Analytical model
latency_analytical = zeros(length(inj_rate_array), length(pb_array));
tile_to_tile_latency = zeros(num_tiles, num_tiles, length(inj_rate_array));

for pb_idx = 1:length(pb_array)
    
    pb = pb_array(pb_idx);
    
    for lambda_idx = 1:length(inj_rate_array)
        
        lambda_array = inj_rate_array(lambda_idx)*ones(NO_OF_ROWS*NO_OF_COLS, NO_OF_ROWS*NO_OF_COLS);
        
        no_of_vert_rings = NO_OF_COLS;
        no_of_horiz_rings = NO_OF_ROWS;
        
        queuing_time_vert_rings = zeros(NO_OF_ROWS, NO_OF_ROWS, NO_OF_COLS);
        queuing_time_horiz_rings = zeros(NO_OF_COLS, NO_OF_COLS, NO_OF_ROWS);
        
        queuing_time = zeros(NO_OF_ROWS*NO_OF_COLS, NO_OF_ROWS*NO_OF_COLS);
        
        lambda_vert_rings = zeros(NO_OF_ROWS, NO_OF_ROWS, NO_OF_COLS);
        lambda_horiz_rings = zeros(NO_OF_COLS, NO_OF_COLS, NO_OF_ROWS);
        
        %vertical rings
        
        for vert_idx = 1:NO_OF_COLS
            for src = 1:NO_OF_ROWS
                for dest = 1:NO_OF_ROWS
                    for dest_row = 1:NO_OF_ROWS
                        lambda_vert_rings(src, dest, vert_idx) = lambda_vert_rings(src, dest, vert_idx) + lambda_array((src-1)*NO_OF_COLS + vert_idx, (dest-1)*NO_OF_COLS + dest_row);
                    end
                end
            end
%             queuing_time_vert_rings(:,:, vert_idx) = get_latency_analytical_CWRR_mesh( lambda_vert_rings(:,:, vert_idx), NO_OF_ROWS, T_serv, weights, pb, debug_required, mode );
            queuing_time_vert_rings(:,:, vert_idx) = get_latency_analytical_CWRR_mesh_wim( lambda_vert_rings(:,:, vert_idx), NO_OF_ROWS, T_serv, weights, pb, debug_required, mode );
        end
        
        
        %horizontal rings
        
        for horiz_idx = 1:NO_OF_ROWS
            for src = 1:NO_OF_COLS
                for dest = 1:NO_OF_COLS
                    for src_row = 1:NO_OF_ROWS
                        lambda_horiz_rings(src, dest, horiz_idx) = lambda_horiz_rings(src, dest, horiz_idx) + lambda_array((src_row-1)*NO_OF_COLS + src, (horiz_idx-1)*NO_OF_ROWS + dest);
                    end
                end
            end
%             queuing_time_horiz_rings(:,:, horiz_idx) = get_latency_analytical_CWRR_mesh( lambda_horiz_rings(:,:, horiz_idx), NO_OF_COLS, T_serv, weights, pb, debug_required, mode );
            queuing_time_horiz_rings(:,:, horiz_idx) = get_latency_analytical_CWRR_mesh_wim( lambda_horiz_rings(:,:, horiz_idx), NO_OF_COLS, T_serv, weights, pb, debug_required, mode );
        end
        
        
        % for each src_dest pair we will compute latency
        for num_src_node = 1:NO_OF_ROWS*NO_OF_COLS
            for num_dest_node = 1:NO_OF_ROWS*NO_OF_COLS
                % extract row and column id for src and dest
                src_row_id = extract_row_id( num_src_node, NO_OF_COLS, NO_OF_ROWS );
                src_col_id = extract_column_id( num_src_node, NO_OF_COLS );
                
                dest_row_id = extract_row_id( num_dest_node, NO_OF_COLS, NO_OF_ROWS );
                dest_col_id = extract_column_id( num_dest_node, NO_OF_COLS );
                
                
                if (lambda_array(num_src_node, num_dest_node) ~= 0)
                    queuing_time(num_src_node, num_dest_node) = queuing_time_vert_rings(src_row_id, dest_row_id, src_col_id) + abs(src_row_id - dest_row_id) + 1 + ...
                        queuing_time_horiz_rings(src_col_id, dest_col_id, dest_row_id) + abs(src_col_id - dest_col_id);
                end
                
            end
        end
        
        
        queuing_time_weighted_total = 0;
        lambda_total = 0;
        for src = 1:num_tiles
            for dest = 1:num_tiles
                queuing_time_weighted_total = queuing_time_weighted_total + queuing_time(src, dest)*lambda_array(src, dest);
                lambda_total = lambda_total + lambda_array(src, dest);
            end
        end
        
        latency_analytical(lambda_idx) = queuing_time_weighted_total/lambda_total;
        tile_to_tile_latency(:, :, lambda_idx) = queuing_time;
        
        
%         [latency_analytical(lambda_idx, pb_idx), tile_to_tile_latency(:,:,lambda_idx)] = ...
%             get_latency_analytical_CWRR(inj_rate_array(lambda_idx), num_tiles, T_serv, weights, pb, debug_required, mode);
        
    end
end

%% Extracting simulation result
% directory = '../../../../Simulink_models/Model_with_6_tile_no_polarity_ringbuf_finite_queue/';


directory = '../../../CWRR_8x8_mesh/';
% 
% ring_weights_array = [1 3 2 3];
% src_weights_array = [1 2 1 1];

ring_weights_array = weights(2);
src_weights_array = weights(1);

num_weight_cfg = length(ring_weights_array);

avg_latency_sim = zeros(length(inj_rate_array), num_weight_cfg);


for pb_idx = 1:length(pb_array)
    
    for weight_idx = 1:num_weight_cfg
        
        src_weights = src_weights_array(weight_idx);
        ring_weights = ring_weights_array(weight_idx);
        
        %     source_weight = weight(1);
        %     ring_weight = weight(2);
        %     sim_dir = strcat('credit_source_', num2str(source_weight), '_ring_', num2str(ring_weight));
        %     cd(sim_dir);
        
        dir_name = strcat('ring_', num2str(ring_weights), '_src_', num2str(src_weights), '_', num2str(sim_length/1000), 'k');

        % results_directory = strcat(directory, sim_length, '_simulation_', wrr, '_wrr', '/', mode);
        results_directory = strcat(directory, '/', dir_name);
        cd(results_directory);
        
        
        pb = pb_array(pb_idx);
        for inj_rate_idx = 1:length(inj_rate_array)
            
            inj_rate = inj_rate_array(inj_rate_idx);
            
%             if (src_weights == 1 && ring_weights == 2)
%                 output_dir = strcat('outputs_lambda_', num2str(inj_rate), '_sinkprob_', num2str(sinkprob), '_pb_', num2str(pb));
%             else
            output_dir = strcat('outputs_lambda_', num2str(inj_rate), '_pb_', num2str(pb), '_r_', num2str(ring_weights), '_s_', num2str(src_weights));
%             end
            cd(output_dir);
            
            fileid = fopen('latency_output.txt');
            text = fgetl(fileid);
            fclose(fileid);
            
            text_head_rem = strrep(text, '----------------Average latency is ', '');
            text_tail_rem = strrep(text_head_rem, ' for set = 1 for pass = 1----------------------', '');
            
            latency = str2double(text_tail_rem);
            avg_latency_sim(inj_rate_idx, pb_idx) = latency;
            
            cd ..
            
        end
        
        cd ../..
        
    end
end


fprintf('The end\n');
% 
% latency_sim = [3.716581 3.807674 3.942705 4.114868 4.356960 4.693922 5.180857 6.001818 7.688916 13.153799 16.046793 23.122410];
% % 
% stop_index = min(13, length(lambda_array));
% % 
% avg_error = 100*mean(abs(latency_sim(1:stop_index) - latency_analytical(1:stop_index))./latency_sim(1:stop_index));
% fprintf('Average error is %0.2f\n', avg_error);
% % 
% figure();
% %class 3
% plot(lambda_array(1:stop_index), latency_sim(1:stop_index), 'r-o');
% xlabel('Injection Rate per Class (packets/cycle)');
% ylabel('Average Latency (cycles)')
% hold on
% plot(lambda_array(1:stop_index), latency_analytical(1:stop_index), 'b-.^');
% legend('Simulation', 'Analytical');
% grid on
% ylim([0 50])