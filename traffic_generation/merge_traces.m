function [ merged_trace ] = merge_traces( event_traces, num_node, trace_len, dests )
%Merge traces for different destinations

%If there are more than one class at the same time then randomly serialize
%them

merged_trace = [];

latest_time = 0;

if (isempty(dests))
    dests = 1:num_node;
end

for cur_time = 1:trace_len
    trace_this_time = zeros(num_node, 2);
%     fprintf('Time: %d\n', cur_time);
%     for dest_idx = 1:num_node
    for dest_idx = 1:length(dests)
        event_trace_this_dest = event_traces{dests(dest_idx)};
        if ~isempty(find(event_trace_this_dest(:, 1) == cur_time, 1))
            trace_this_time(dests(dest_idx), :) = event_trace_this_dest(find(event_trace_this_dest(:, 1) == cur_time, 1), :);
        end
    end
    
    trace_to_be_chosen = randperm(num_node);
    
    for choose_idx = 1:num_node
        choose = trace_to_be_chosen(choose_idx);
        
        if (trace_this_time(choose, 1) ~= 0)
            latest_time = latest_time + 1;
            
            %delaying the packet
            if (latest_time < cur_time)
                latest_time = cur_time;
            end
            merged_trace = [merged_trace; [latest_time, choose, trace_this_time(choose, 2)]];
        end
        
    end
    
end


end

