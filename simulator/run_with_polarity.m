
%% GLOBAL DECLARATIONS


global NO_OF_TILES;

global latency_total;

global latency_total_array;

global packet_count;

global packet_count_array;

global packet_generation_file;
global sink_packet_latency_file;
global missed_packet_info;
% global tile_3_traffic_tracking;
global lambda_cache_1;
global lambda_cache_2;
global lambda_cache_3;
global lambda_cache_4;
global lambda_cache_5;
global lambda_cache_6;
global debugRequired;
global sim_length;
global packet_generation_stopped;
global tile1_core;
global tile1_cache;
global tile2_core;
global tile2_cache;
global tile3_core;
global tile3_cache;
global tile4_core;
global tile4_cache;
global tile1_core_size;
global tile1_cache_size;
global tile2_core_size;
global tile2_cache_size;
global tile3_core_size;
global tile3_cache_size;
global tile4_core_size;
global tile4_cache_size;
global num_misssed_packets;
global sim_file;
global even_core_empty;

global average_latency_array;

global sd_latency_array;

global packet_latency_array;

global tile_1_sink;
global tile_2_sink;
global tile_3_sink;
global tile_4_sink;
global tile_5_sink;
global tile_6_sink;

%%FILE GENERATION

% rmdir ('outputs', 's');
mkdir outputs;
cd outputs;
latency_output_file = fopen('latency_output.txt', 'w');

average_latency = 0;
save('average_latency.mat', 'average_latency');

cd ..

create_blank_data;

% fprintf('------------------------- Running simulation %d times with step %d ----------------------\n\n', num_of_iterations, step_size);
fprintf('------------------------- Latency result is available in the file "latency_output.txt" ----------------\n\n');

%% SIMULATION SWEEP

% num_of_iterations = 10;                                                       % Sweep with this many injection rates
% step_size = 0.05;
% lambda = step_size:step_size:lambda_max;
% lambda = 0.005:0.005:0.08;
lambda = 0.05;

rng(04052018);

NO_OF_ITER = 1;

% for i=1:length(lambda)
for i = 1:1
    
%     injecting_tiles = randomSource();
%     injecting_tiles = [1 2 3 4 5];
       injecting_tiles = [1 2]; 
    no_of_tiles_injecting = length(injecting_tiles);
    
    
%     lambda_core_1 = 0;
%     lambda_core_2 = 0;
%     lambda_core_3 = 0;
%     lambda_core_4 = 0;
%     lambda_core_5 = 0;
%     lambda_core_6 = 0;
    
    
    tile_1_sink = 0;
    tile_2_sink = 0;
    tile_3_sink = 0;
    tile_4_sink = 0;
    tile_5_sink = 0;
    tile_6_sink = 0;
    
    for j = 1:no_of_tiles_injecting
        if (injecting_tiles(j) == 1)
%             tile_1_sink = randomSink();
            tile_1_sink = [1 2 3 4 5 6];
        end
        if (injecting_tiles(j) == 2)
%             tile_2_sink = randomSink();
            tile_2_sink = [3 4 5 6];
        end
        if (injecting_tiles(j) == 3)
%             tile_3_sink = randomSink();
            tile_3_sink = [3 4 5 6];
        end
        if (injecting_tiles(j) == 4)
%             tile_4_sink = randomSink();
            tile_4_sink = [5 6];
        end
        if (injecting_tiles(j) == 5)
%             tile_5_sink = randomSink();
            tile_5_sink = [5 6];
        end
        if (injecting_tiles(j) == 6)
%             tile_6_sink = randomSink();
        end
    end
    
%     for j = 1:no_of_tiles_injecting
%         if (injecting_tiles(j) == 1)
% %             lambda_core_1 = (rand/6)*length(tile_1_sink);
%             lambda_core_1 = lambda(i)*length(tile_1_sink);
%         end
%         if (injecting_tiles(j) == 2)
% %             lambda_core_2 = (rand/6)*length(tile_2_sink);
%             lambda_core_2 = lambda(i)*length(tile_2_sink);
%         end
%         if (injecting_tiles(j) == 3)
% %             lambda_core_3 = (rand/6)*length(tile_3_sink);
%             lambda_core_3 = lambda(i)*length(tile_3_sink);
%         end
%         if (injecting_tiles(j) == 4)
% %             lambda_core_4 = (rand/6)*length(tile_4_sink);
%             lambda_core_4 = lambda(i)*length(tile_4_sink);
%         end
%         if (injecting_tiles(j) == 5)
% %             lambda_core_5 = (rand/6)*length(tile_5_sink);
%             lambda_core_5 = lambda(i)*length(tile_5_sink);
%         end
%         if (injecting_tiles(j) == 6)
% %             lambda_core_6 = (rand/6)*length(tile_6_sink);
%             lambda_core_6 = lambda(i)*length(tile_6_sink);
%         end
%     end
    
    
    
    %     lambda_core_1 = rand*0.75;
    %     lambda_core_2 = rand*0.75;
    %     lambda_core_3 = rand*0.75;
    %     lambda_core_4 = rand*0.75;
    %     lambda_core_5 = rand*0.75;
    %     lambda_core_6 = rand*0.75;
    lambda_cache_1 = 0;
    lambda_cache_2 = 0;
    lambda_cache_3 = 0;
    lambda_cache_4 = 0;
    lambda_cache_5 = 0;
    lambda_cache_6 = 0;
    
    
    average_latency_iter_array = zeros(NO_OF_ITER, NO_OF_TILES, NO_OF_TILES);
    sd_iter_array = zeros(NO_OF_ITER, NO_OF_TILES, NO_OF_TILES);
    latency_total_array = zeros(NO_OF_TILES, NO_OF_TILES);
    packet_count_array = zeros(NO_OF_TILES, NO_OF_TILES);
    
    for iter = 1:NO_OF_ITER
        even_core_empty = 0;
        
        % Initialize global parameters
        
        packet_generation_stopped = 0;
        
        latency_total = 0;
        
        for from = 1:NO_OF_TILES
            for to = 1:NO_OF_TILES
                packet_latency_array(to,:,from) = zeros(1, 100000); %% assuming 1000000 no of packets from i to j
            end
        end
        
        packet_count = 0;
        
        warning('off','all');
        
        if (debugRequired == 1)
            tile1_core = zeros(10000, 3);
            tile1_cache = zeros(10000, 3);
            tile2_core = zeros(10000, 3);
            tile2_cache = zeros(10000, 3);
            tile3_core = zeros(10000, 3);
            tile3_cache = zeros(10000, 3);
            tile4_core = zeros(10000, 3);
            tile4_cache = zeros(10000, 3);
            tile1_core_size = 0;
            tile1_cache_size = 0;
            tile2_core_size = 0;
            tile2_cache_size = 0;
            tile3_core_size = 0;
            tile3_cache_size = 0;
            tile4_core_size = 0;
            tile4_cache_size = 0;
            num_misssed_packets = 0;
            cd outputs;
            packet_generation_file_name = strcat('packet_generation_file_', int2str(i), '.txt');
            sink_packet_latency_file_name = strcat('each_packet_latency_', int2str(i), '.txt');
            missed_packet_info_file_name = strcat('missed_packet_info_', int2str(i), '.txt');
            tile_3_traffic_tracking_file_name = strcat('tile_3_traffic_tracking_', int2str(i), '.txt');
            output_dir_name = strcat('output_', int2str(i));
            mkdir (output_dir_name);
            cd (output_dir_name);
            packet_generation_file = fopen(packet_generation_file_name, 'w');
            sink_packet_latency_file = fopen(sink_packet_latency_file_name, 'w');
            missed_packet_info = fopen(missed_packet_info_file_name, 'w');
            cd ..
            cd ..
            %         tile_3_traffic_tracking = fopen(tile_3_traffic_tracking_file_name, 'w');
        end
        
        tic
        sim_file = 'CWRR_8x8_mesh';
        simOut = sim(sim_file, 'StartTime','0','StopTime',sim_length);
        toc
        
        % SCORE_BOARD
        if (debugRequired == 1)
            print_missed_packet_info();
            fprintf(missed_packet_info, '%d packets have been lost out of %d total packets\n\n\n', num_misssed_packets, (packet_count+num_misssed_packets));
            cd outputs;
            cd (output_dir_name);
            fclose(packet_generation_file);
            fclose(sink_packet_latency_file);
            fclose(missed_packet_info);
            cd ..
            cd ..
            %         fclose(tile_3_traffic_tracking);
        end
        
        average_latency_seed(iter) = calcul_latency_if_packets( latency_total , packet_count );
        
        for from = 1:NO_OF_TILES
            for to = 1:NO_OF_TILES
                average_latency_iter_array(iter, to, from) = calcul_latency_if_packets(latency_total_array(to, from), packet_count_array(to, from));
                sd_iter_array(iter, to, from) = calcul_sd(packet_latency_array(to, :, from), packet_count_array(to, from));
            end
        end
        
        fprintf('\n\nLatency is %f\n\n', latency_total/packet_count);
        
        cd outputs;
        fprintf(latency_output_file, '----------------Average latency is %f for set = %d for pass = %d----------------------\n\n\n', average_latency_seed(iter), i, iter);
        cd ..
        
    end %for j = 1:5
    
    average_latency = mean(average_latency_seed) ;
    
    for from = 1:NO_OF_TILES
        for to = 1:NO_OF_TILES
            average_latency_array(from,to) = mean(average_latency_iter_array(:, to, from));
            sd_latency_array(from, to) = sqrt((sum(average_latency_iter_array(:, to, from))/NO_OF_ITER));
        end
    end
    
    cd outputs;
    fprintf(latency_output_file, '----------------Average latency is %f for set = %d ----------------------\n\n\n', average_latency(i), i);
    %avg_latency_struct = load('average_latency.mat');
    %avg_latency_val = avg_latency_struct.average_latency;
    %avg_latency_val = [avg_latency_val average_latency];
    %average_latency = avg_latency_val;
    %save('average_latency.mat', 'average_latency');
    cd ..
    
    save_data;
    
end
