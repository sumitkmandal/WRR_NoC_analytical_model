function [out] = generate_packet_cache(u)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global NUM_OF_RINGS;
global packet_generation_file;
global debugRequired;
global packet_gen_stop_time;
global packet_generation_stopped;
global tile1_cache;
global tile2_cache;
global tile3_cache;
global tile4_cache;
global tile1_cache_size;
global tile2_cache_size;
global tile3_cache_size;
global tile4_cache_size;
global sim_file;

rnd = rand();
% u(1): ID
% u(2): lambda55
% u(3): payload
% u(4): queue full


queue_full = u(4);

valid = 0;
%out = zeros(1,5);
cur_time = get_param(sim_file,'SimulationTime');

if (cur_time == packet_gen_stop_time)
    packet_generation_stopped = 1;
    if (debugRequired == 1)
%         fprintf('Packet generation has been stopped. Cache of tile %d is entering into cool down\n\n', u(1));
    end
end

if (queue_full == 1 || packet_generation_stopped == 1)
    valid = 0;
    pushToQueue = 0;
    
%     if (packet_generation_stopped == 1)
%        
%     end
    
    data = [-1, -1, u(3), 0];
else
    if (rnd < u(2)) % u(2): lambda
        valid = 1;                              % A packet will be generated in this cycle
        dst_id = ceil(NUM_OF_RINGS*rand());
        payload = u(3) + 2;                   % Sequence id
        if (dst_id == u(1))
            data = [u(1),dst_id,payload,0]; % if destined to same tile it should go to core
        else
            if (rand() > 0.5)
                data = [u(1),dst_id,payload,1];
            else
                data = [u(1),dst_id,payload,0];
            end %if (rand() > 0.5)
        end %(dst_id == u(1))
        pushToQueue = 1;
        
        if (debugRequired == 1)
            fprintf(packet_generation_file, 'Packet with cache payload %d was generated from tile %d cache, will be going east to tile %d, will go to core %d\n\n\n', data(3), data(1), data(2), data(4));
            if(data(1) == 1)
                tile1_cache_size = tile1_cache_size+1;
                tile1_cache(tile1_cache_size,:) = [data(3) data(2) 0];
            end
            if(data(1) == 2)
                tile2_cache_size = tile2_cache_size+1;
                tile2_cache(tile2_cache_size,:) = [data(3) data(2) 0];
            end
            if(data(1) == 3)
                tile3_cache_size = tile3_cache_size+1;
                tile3_cache(tile3_cache_size,:) = [data(3) data(2) 0];
            end
            if(data(1) == 4)
                tile4_cache_size = tile4_cache_size+1;
                tile4_cache(tile4_cache_size,:) = [data(3) data(2) 0];
            end
        end%(debugRequired == 1)
        
    else
        data = [-1,-1,u(3), 0];                 % Invalid data. Just pass the payload
        pushToQueue = 0;
    end
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

