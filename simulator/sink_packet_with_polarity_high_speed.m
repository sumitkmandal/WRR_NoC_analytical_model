function [] = sink_packet_with_polarity_high_speed(u)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global latency_total;

global latency_total_array;


global packet_count;

global packet_count_array;

global sink_packet_latency_file;
global debugRequired;
global sim_file;
global warm_up_cycles;

global packet_latency_array;

% u(1): src id
% u(2): dest id
% u(3): payload
% u(4): to core
% u(5): time stamp
% u(6): current time
% u(7): global id
% u(8) : polarity

assert(u(2) == u(7), 'Packet has reached incorrect destination. Destination is %.0f\n\n', u(2));
latency = u(6) - u(5);
cur_time = get_param(sim_file,'SimulationTime');
%     out = [1 latency];
if (debugRequired == 1)
    fprintf(sink_packet_latency_file, 'Latency is %d for packet generated in tile %d and destined to tile %d core %d genereated on time %d with payload %d. It has reached on time %d with polarity %d.\n', latency, u(1), u(2), u(4), u(5), u(3), u(6), u(8));
    mark_packet(u(1), u(3));
end

if (u(1) ~= u(2))
    %check_polarity_rule(u); %commenting as we do not need polarity
    if (debugRequired == 1)
        fprintf(sink_packet_latency_file, 'Polarity passed\n\n\n');
    end
end %(u(1) ~= u(2))

if (cur_time > warm_up_cycles) %warm-up time
    latency_total = latency_total + latency;
    packet_count = packet_count + 1;
    
    
    latency_total_array(u(2), u(1)) = latency_total_array(u(2), u(1)) + latency;
    packet_count_array(u(2), u(1)) = packet_count_array(u(2), u(1)) + 1;
    packet_latency_array(u(2), packet_count_array(u(2), u(1)), u(1)) = latency;
    
end

end