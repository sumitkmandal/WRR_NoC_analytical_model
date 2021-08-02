function [out] = generate_packet_core(u)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global NUM_OF_RINGS;
global packet_generation_file;
global debugRequired;
global packet_gen_stop_time;
global packet_generation_stopped;
global tile1_core;
global tile2_core;
global tile3_core;
global tile4_core;
global tile1_core_size;
global tile2_core_size;
global tile3_core_size;
global tile4_core_size;
global sim_file;



% u(1): ID
% u(2): lambda55
% u(3): payload
% u(4): queue full


queue_full = u(3);

valid = 0;
%out = zeros(1,5);
cur_time = get_param(sim_file,'SimulationTime');

if (cur_time == packet_gen_stop_time)
    packet_generation_stopped = 1;
    %             fprintf('Packet generation has been stopped. Core of tile %d is entering into cool down\n\n', u(1));
    %             break;
end

if (queue_full == 1 || packet_generation_stopped == 1)
    valid = 0;
    pushToQueue = 0; 
    
%     if (packet_generation_stopped == 1)
%         fprintf('Packet generation has been stopped. Model is entering into cool down\n\n');
%     end
    
    data = [-1, -1, u(2), 0];
else
    
%     if (rnd < u(2)) % u(2): lambda
 %       valid = 1;                              % A packet will be generated in this cycle
        
        dst_id = u(4);
        
%         dst_id = ceil(NUM_OF_RINGS*rand());
    if (dst_id ~= 0) 
        valid=1;
        payload = u(2) + 2;                     % Sequence id
        if (dst_id == u(1))
            data = [u(1),dst_id,payload,1];     % if destined to same tile it should go to cache
        else
%             if (rand() > 0.5)
%                 data = [u(1),dst_id,payload,0]; %goes to core
%             else
                data = [u(1),dst_id,payload,1];
%             end %if (rand() > 0.5)
        end %(dst_id == u(1))
        pushToQueue = 1;
        
    else % if (rnd <= u(2))
        data = [-1,-1,u(2), 0];                 % Invalid data. Just pass the payload
        pushToQueue = 0;
    end
    
    if (debugRequired == 1)
        if (cur_time == packet_gen_stop_time)
            packet_generation_stopped = 1;
%             fprintf('Packet generation has been stopped. Core of tile %d is entering into cool down\n\n', u(1));
            %             break;
        end
        
        if (data(1) ~= -1)
            fprintf(packet_generation_file, 'Packet with core payload %d was generated from tile %d core, will be going east to %d, will go to core %d\n\n\n', data(3), data(1), data(2), data(4));
        end
        
        if(data(1) == 1)
            tile1_core_size = tile1_core_size+1;
            tile1_core(tile1_core_size,:) = [data(3) data(2) 0];
        end
        if(data(1) == 2)
            tile2_core_size = tile2_core_size+1;
            tile2_core(tile2_core_size,:) = [data(3) data(2) 0];
        end
        if(data(1) == 3)
            tile3_core_size = tile3_core_size+1;
            tile3_core(tile3_core_size,:) = [data(3) data(2) 0];
        end
        if(data(1) == 4)
            tile4_core_size = tile4_core_size+1;
            tile4_core(tile4_core_size,:) = [data(3) data(2) 0];
        end
    end %(debugRequired == 1)
    
    
end % queue_full == 1

% out(1): valid
% out(2): src id
% out(3): dst_id
% out(4): payload
% out(5): toCore toCore = 0 -> packet will go to core, otherwise it will go
                                                       % to cache

% out = [valid, data, pushToQueue];
out(1) = valid;
out(2:5) = data;
out(6) = pushToQueue;

%fprintf('packet is generating from %d, will go to %d, is valid %d, will go to core %d, will be pushed %d\n\n\n', out(2), out(3), out(1), out(5), out(6));

%fclose(fileID);

end
