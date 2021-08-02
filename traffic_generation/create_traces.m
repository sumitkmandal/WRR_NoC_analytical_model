% create GGeo trace with specified lambda and pb for all source
clc
clear
close all


num_node = 64;

% lambda_array = [0.01:0.01:0.06];
% lambda_array = 0.2;
% lambda_array = [0.010	0.065	0.080	0.085	0.010	0.060	0.068	0.072	0.005	0.040	0.050	0.055	0.001	0.025	0.040	0.043	0.001	0.020	0.030	0.035];
% p_burst_array = [0.2 0.6];
% p_burst_array = [0.1 0.3];
p_burst_array = [0 0.1 0.3];
% p_burst_array = [0];

% lambda_array = [
% 0.085
% 0.087
% 0.088
% 0.060
% 0.061
% ];
% lambda_array = [0.04:0.04:0.32 0.33];
% lambda_array = 0.02:0.02:0.16;
% lambda_array = [0.02:0.02:0.06 0.07:0.005:0.1];
% lambda_array = 0.096:0.001:0.099;
% lambda_array = [0.04:0.04:0.4 0.41 0.411];
% lambda_array = [0.1:-0.001:0.090 0.085:-0.005:0.07 0.06:-0.02:0.02];
% lambda_array = 0.086:0.001:0.089;
% lambda_array = [0.01 0.48];
% lambda_array = [0.005:0.005:0.06];
% lambda_array = [0.001];
% lambda_array = [0.01:0.01:0.04 0.05:0.005:0.07 0.001];
% lambda_array = [0.001:0.001:0.007 0.0065 0.0067];
% lambda_array = [0.0065 0.0067];
% lambda_array = 0.0066;
% lambda_array = 0.001:0.001:0.009;
% lambda_array = 0.01:0.001:0.013;
% lambda_array = [0.014 0.015];
lambda_array = [0.005 0.006 0.0065 0.0067];
% lambda_array = [0.096 0.095 0.094];
% lambda_array = [0.093:-0.001:0.090 0.085:-0.005:0.07 0.06:-0.02:0.02];
% 0.091:0.001:0.094;

% lambda_array = 0.49;

sources = 1:num_node;
% sources = [1:6 9:14 17:22 25:30 33:38 41:46];
% sources = [1 2];
% sources = [1 2 3];
% dests = 1:num_node;
dests = sources;
% dests = 2;

% sources = [1 3];
% dests = 3;

trace_len = 1E5;
rand_factor = 5;

for lambda_idx = 1:length(lambda_array)
    for pb_idx = 1:length(p_burst_array)
        
        lambda = lambda_array(lambda_idx);
        p_burst = p_burst_array(pb_idx);
        
        lambda_string = sprintf('lambda_%.4f', round(lambda,4));
        dir_name = strcat(lambda_string, '_pb_', num2str(p_burst), '_rand_factor_', num2str(rand_factor));
%         dir_name = sprintf('lambda_', num2str(lambda), '_pb_', num2str(p_burst));
        mkdir(dir_name);
        
        event_trace_src = {};
        for src_idx = 1:length(sources)
            event_trace = {};
            rng(sources(src_idx)*rand_factor);
            
            %split case
%             if (src_idx == 1)
%                 dests = [2 3];
%             elseif (src_idx == 2)
%                 dests = 3;
%             else
%                 %do nothing
%             end
%             dests = [];
            
            %unidirectional traces
%             for node_idx = 1:num_node
%                 if (node_idx > src_idx)
%                     dests = [dests node_idx];
%                 end
%             end
            
            if (~isempty(dests))
                
%                 if (src_idx == 2)
%                     lambda = 0.64;
%                 end
                
                for dest_idx = 1:length(dests)
                    event_trace{dests(dest_idx)} = gen_trace_GGeo_dist_func(lambda, p_burst, trace_len);
                    event_trace{dests(dest_idx)} = modify_trace(event_trace{dests(dest_idx)}, trace_len); %change the trace to contain only the events
                end
                event_trace_src{sources(src_idx)} = merge_traces(event_trace, num_node, trace_len, dests);
                timestamps = event_trace_src{sources(src_idx)};
                
                cd (dir_name);
                timestamp_str = strcat('timestamps_tile', num2str(sources(src_idx)));
                save(timestamp_str, 'timestamps');
                cd ..
            end
            
        end
    end
end


% create custom trace
% event_trace_src = {};
% 
% 
% lambda = 0.2;
% p_burst = 0.1;
% trace_len = 1E5;
% 
% % sources = 3;
% % dests = 3;
% 
% sources = 1;
% dests = [4 5];
% 
% 
% for src_idx = 1:length(sources)
%     event_trace = {};
%     rng(sources(src_idx));
%     for dest_idx = 1:length(dests)
%         event_trace{dests(dest_idx)} = gen_trace_GGeo_dist_func(lambda, p_burst, trace_len);
%         event_trace{dests(dest_idx)} = modify_trace(event_trace{dests(dest_idx)}, trace_len); %change the trace to contain only the events
%     end
%     event_trace_src{sources(src_idx)} = merge_traces(event_trace, num_node, trace_len, dests);
%     timestamps = event_trace_src{sources(src_idx)};
% 
% %     cd (dir_name);
%     timestamp_str = strcat('timestamps_tile', num2str(sources(src_idx)));
%     save(timestamp_str, 'timestamps');
% %     cd ..
% 
% end

