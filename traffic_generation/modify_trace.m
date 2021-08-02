function [ op_trace ] = modify_trace( ip_trace, trace_len )
%change the trace to contain only the events

op_trace = [];

for trace_idx = 1:trace_len
    if (ip_trace(trace_idx) ~= 0)
        op_trace = [op_trace; [trace_idx, ip_trace(trace_idx)]];
    end
end

end

