auto_run = 1;

if (auto_run == 0)
    clc;
    clearvars;
    close all;
    clear;
end

%% GLOBAL DECLARATIONS

% global timestamps;
% global timestamps_2;
% fid = fopen('trace_file_cholesky.txt','rt');
% tmp = textscan(fid,'%d','Delimiter',' ');
% fclose(fid);
% timestamps = cell2mat(tmp);
%struct_data = load('timestamps_dest.mat');
% struct_data = load('timestamps_3.mat');
%

% Sink probability
% global sink_probability;
% sink_probability = 0.6;

global NO_OF_TILES;
global NO_OF_ROWS;
global NO_OF_COLS;
NO_OF_TILES = 64;
NO_OF_ROWS = 8;
NO_OF_COLS = 8;

for tile_id = 1:NO_OF_TILES 
  tile_name = strcat('timestamps_tile',num2str(tile_id));
  eval(['global ' tile_name]);
end

%global timestamps_tile1;
%global timestamps_tile2;
%global timestamps_tile3;
% global timestamps_tile4;
% global timestamps_tile5;
% global timestamps_tile6;
% global timestamps_tile7;
% global timestamps_tile8;
% global timestamps_tile1;
% global timestamps_tile2;
% global timestamps_tile3;
% global timestamps_tile4;
% global timestamps_tile5;
% global timestamps_tile6;
% global timestamps_tile7;
% global timestamps_tile8;

for tile_id = 1:NO_OF_TILES 
    struct_data = load(strcat('timestamps_tile',num2str(tile_id),'.mat'));
    timestamp_assign = sprintf('timestamps_tile%d = struct_data.timestamps;',tile_id);
    eval(timestamp_assign);
end

start_tile = 0;
end_tile = 0;

if (start_tile ~= 0 && end_tile ~= 0)
    for tile_id = start_tile:end_tile        %use when some tilestamps need to be put to zero for testing
        struct_data = load(strcat('timestamps_tile',num2str(tile_id),'.mat'));
        timestamp_assign = sprintf('timestamps_tile%d = [0 0 0; 0 0 0]',tile_id);
        eval(timestamp_assign);
    end
end

%struct_data = load('timestamps_tile1.mat');
%timestamps_tile1 = struct_data.timestamps;

% timestamps_tile1 = [0 0 0; 0 0 0];

% timestamps_tile2 = [0 0 0; 0 0 0];
% timestamps_tile3 = [0 0 0; 0 0 0];
% timestamps_tile4 = [0 0 0; 0 0 0];
% timestamps_tile5 = [0 0 0; 0 0 0];
% timestamps_tile6 = [0 0 0; 0 0 0];
% timestamps_tile7 = [0 0 0; 0 0 0];
% timestamps_tile8 = [0 0 0; 0 0 0];

%struct_data = load('timestamps_tile2.mat');
%timestamps_tile2 = struct_data.timestamps;

%struct_data = load('timestamps_tile3.mat');
% timestamps_tile3 = struct_data.timestamps;
% 
% struct_data = load('timestamps_tile4.mat');
% timestamps_tile4 = struct_data.timestamps;
% 
% struct_data = load('timestamps_tile5.mat');
% timestamps_tile5 = struct_data.timestamps;
% 
% struct_data = load('timestamps_tile6.mat');
% timestamps_tile6 = struct_data.timestamps;
% 
% struct_data = load('timestamps_tile7.mat');
% timestamps_tile7 = struct_data.timestamps;
% 
% struct_data = load('timestamps_tile8.mat');
% timestamps_tile8 = struct_data.timestamps;
% 

% timestamps = struct_data.timestamps;
% max_timestamps = max(timestamps); 
% 
% struct_data = load('timestamp_dest_1.mat');
% timestamps_2 = struct_data.timestamp_dest;
% max_timestamps_2 = max(timestamps_2);
% timestamps_2 = [0 0; 0 0];
% global timestamps;


global maxQueueSize;
global maxQueueSizeRing;
% global lambda_core_1;
% global lambda_core_2;
% global lambda_core_3;
% global lambda_core_4;
% global lambda_core_5;
% global lambda_core_6;
global lambda_cache_1;
global lambda_cache_2;
global lambda_cache_3;
global lambda_cache_4;
global lambda_cache_5;
global lambda_cache_6;
global debugRequired;
global sim_length;
global packet_gen_stop_time;
global packet_generation_stopped;
global latency_total;
global packet_count;
% global lambda_max;
% global step_size;
global warm_up_cycles;
% global even_core_empty;
% global initCredits;
global arbitration;
global sink_probability;
global sink_buffer_size;


%% INITIALIZE PARAMETERS


% lambda_core_1 = 0;
% lambda_core_2 = 0;
% lambda_core_3 = 0;
% lambda_core_4 = 0;
% lambda_core_5 = 0;
% lambda_core_6 = 0;
lambda_cache_1 = 0;
lambda_cache_2 = 0;
lambda_cache_3 = 0;
lambda_cache_4 = 0;
lambda_cache_5 = 0;
lambda_cache_6 = 0;
% step_size = 0.10;
% lambda_max = 0.10;
% lambda = [0.15];
% lambda = 0.025:0.025:0.25;
% sim_length = num2str(min(max_timestamps(1), max_timestamps_2(1)));
% sim_length = num2str(200000);
sim_length = num2str(100000);
warm_up_cycles = 0.1 * str2num(sim_length);

% initCredits = [100 100 50 50]; %higher number of credits to source
% initCredits = [1 1 2 2]; %first two numbers denote the weights to source; next two denote the weights to the ring

% 1 -> priority (TODO)
% 2 -> round robin (probabilistic)
% 3 -> weighted round robin (classical)
% 4 -> weighted round robin (interleaved)
% 5 -> weighted round robin (interleaved) %hacked to test unidirection
arbitration = 3;
sink_buffer_size = 500;
sink_probability = 1;

%% INPUT PARAMETERS
debugRequired = 0;
maxQueueSize = 500;
maxQueueSizeRing = 500;

% The change in injection rate
cool_down_amount = 0;
latency_total = 0;
packet_count = 0;
% even_core_empty = 0;

%% FIXED PARAMETERS

% NUM_OF_RINGS = 6;
packet_gen_stop_time = (str2double(sim_length) - (str2double(sim_length)*cool_down_amount));
packet_generation_stopped = 0;
