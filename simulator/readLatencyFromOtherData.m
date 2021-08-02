function [ average_latency_dataset, sd_dataset ] = readLatencyFromOtherData( )

average_latency_tile1_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_1_core.mat');
average_latency_tile2_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_2_core.mat');
average_latency_tile3_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_3_core.mat');
average_latency_tile4_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_4_core.mat');
average_latency_tile5_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_5_core.mat');
average_latency_tile6_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_6_core.mat');

average_latency_tile2_1_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_2_1_core.mat');
average_latency_tile2_2_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_2_2_core.mat');
average_latency_tile2_3_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_2_3_core.mat');
average_latency_tile2_4_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_2_4_core.mat');
average_latency_tile2_5_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_2_5_core.mat');
average_latency_tile2_6_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_2_6_core.mat');

average_latency_tile3_1_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_3_1_core.mat');
average_latency_tile3_2_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_3_2_core.mat');
average_latency_tile3_3_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_3_3_core.mat');
average_latency_tile3_4_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_3_4_core.mat');
average_latency_tile3_5_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_3_5_core.mat');
average_latency_tile3_6_core_training_struct = load('Training data/with sd/correct data/config_1/mean latency/average_latency_tile_3_6_core.mat');

average_latency_tile1_core_training_config_1 = average_latency_tile1_core_training_struct.average_latency_tile1_core;
average_latency_tile2_core_training_config_1 = average_latency_tile2_core_training_struct.average_latency_tile2_core;
average_latency_tile3_core_training_config_1 = average_latency_tile3_core_training_struct.average_latency_tile3_core;
average_latency_tile4_core_training_config_1 = average_latency_tile4_core_training_struct.average_latency_tile4_core;
average_latency_tile5_core_training_config_1 = average_latency_tile5_core_training_struct.average_latency_tile5_core;
average_latency_tile6_core_training_config_1 = average_latency_tile6_core_training_struct.average_latency_tile6_core;

average_latency_tile2_1_core_training_config_1 = average_latency_tile2_1_core_training_struct.average_latency_tile2_to_1_core;
average_latency_tile2_2_core_training_config_1 = average_latency_tile2_2_core_training_struct.average_latency_tile2_to_2_core;
average_latency_tile2_3_core_training_config_1 = average_latency_tile2_3_core_training_struct.average_latency_tile2_to_3_core;
average_latency_tile2_4_core_training_config_1 = average_latency_tile2_4_core_training_struct.average_latency_tile2_to_4_core;
average_latency_tile2_5_core_training_config_1 = average_latency_tile2_5_core_training_struct.average_latency_tile2_to_5_core;
average_latency_tile2_6_core_training_config_1 = average_latency_tile2_6_core_training_struct.average_latency_tile2_to_6_core;

average_latency_tile3_1_core_training_config_1 = average_latency_tile3_1_core_training_struct.average_latency_tile3_to_1_core;
average_latency_tile3_2_core_training_config_1 = average_latency_tile3_2_core_training_struct.average_latency_tile3_to_2_core;
average_latency_tile3_3_core_training_config_1 = average_latency_tile3_3_core_training_struct.average_latency_tile3_to_3_core;
average_latency_tile3_4_core_training_config_1 = average_latency_tile3_4_core_training_struct.average_latency_tile3_to_4_core;
average_latency_tile3_5_core_training_config_1 = average_latency_tile3_5_core_training_struct.average_latency_tile3_to_5_core;
average_latency_tile3_6_core_training_config_1 = average_latency_tile3_6_core_training_struct.average_latency_tile3_to_6_core;

average_latency_dataset = [average_latency_tile1_core_training_config_1; average_latency_tile2_core_training_config_1; average_latency_tile3_core_training_config_1; average_latency_tile4_core_training_config_1; average_latency_tile5_core_training_config_1; average_latency_tile6_core_training_config_1;...
                           average_latency_tile2_1_core_training_config_1; average_latency_tile2_2_core_training_config_1; average_latency_tile2_3_core_training_config_1; average_latency_tile2_4_core_training_config_1; average_latency_tile2_5_core_training_config_1; average_latency_tile2_6_core_training_config_1;...
                           average_latency_tile3_1_core_training_config_1; average_latency_tile3_2_core_training_config_1; average_latency_tile3_3_core_training_config_1; average_latency_tile3_4_core_training_config_1; average_latency_tile3_5_core_training_config_1; average_latency_tile3_6_core_training_config_1];
%% sd

sd_latency_tile_1_core_training_struct = load('Training data/with sd/correct data/config_1/sd latency/sd_tile_1_core.mat');
sd_latency_tile_1_core_training_config_1 = sd_latency_tile_1_core_training_struct.standard_deviation_1_core;

sd_latency_tile2_1_core_training_struct = load('Training data/with sd/correct data/config_1/sd latency/sd_2_1_core.mat');
sd_latency_tile2_2_core_training_struct = load('Training data/with sd/correct data/config_1/sd latency/sd_2_2_core.mat');
sd_latency_tile2_3_core_training_struct = load('Training data/with sd/correct data/config_1/sd latency/sd_2_3_core.mat');
sd_latency_tile2_4_core_training_struct = load('Training data/with sd/correct data/config_1/sd latency/sd_2_4_core.mat');
sd_latency_tile2_5_core_training_struct = load('Training data/with sd/correct data/config_1/sd latency/sd_2_5_core.mat');
sd_latency_tile2_6_core_training_struct = load('Training data/with sd/correct data/config_1/sd latency/sd_2_6_core.mat');

sd_latency_tile2_1_core_training_config_1 = sd_latency_tile2_1_core_training_struct.standard_deviation_2_to_1_core;
sd_latency_tile2_2_core_training_config_1 = sd_latency_tile2_2_core_training_struct.standard_deviation_2_to_2_core;
sd_latency_tile2_3_core_training_config_1 = sd_latency_tile2_3_core_training_struct.standard_deviation_2_to_3_core;
sd_latency_tile2_4_core_training_config_1 = sd_latency_tile2_4_core_training_struct.standard_deviation_2_to_4_core;
sd_latency_tile2_5_core_training_config_1 = sd_latency_tile2_5_core_training_struct.standard_deviation_2_to_5_core;
sd_latency_tile2_6_core_training_config_1 = sd_latency_tile2_6_core_training_struct.standard_deviation_2_to_6_core;


sd_latency_tile3_1_core_training_struct = load('Training data/with sd/correct data/config_1/sd latency/sd_3_1_core.mat');
sd_latency_tile3_2_core_training_struct = load('Training data/with sd/correct data/config_1/sd latency/sd_3_2_core.mat');
sd_latency_tile3_3_core_training_struct = load('Training data/with sd/correct data/config_1/sd latency/sd_3_3_core.mat');
sd_latency_tile3_4_core_training_struct = load('Training data/with sd/correct data/config_1/sd latency/sd_3_4_core.mat');
sd_latency_tile3_5_core_training_struct = load('Training data/with sd/correct data/config_1/sd latency/sd_3_5_core.mat');
sd_latency_tile3_6_core_training_struct = load('Training data/with sd/correct data/config_1/sd latency/sd_3_6_core.mat');

sd_latency_tile3_1_core_training_config_1 = sd_latency_tile3_1_core_training_struct.standard_deviation_3_to_1_core;
sd_latency_tile3_2_core_training_config_1 = sd_latency_tile3_2_core_training_struct.standard_deviation_3_to_2_core;
sd_latency_tile3_3_core_training_config_1 = sd_latency_tile3_3_core_training_struct.standard_deviation_3_to_3_core;
sd_latency_tile3_4_core_training_config_1 = sd_latency_tile3_4_core_training_struct.standard_deviation_3_to_4_core;
sd_latency_tile3_5_core_training_config_1 = sd_latency_tile3_5_core_training_struct.standard_deviation_3_to_5_core;
sd_latency_tile3_6_core_training_config_1 = sd_latency_tile3_6_core_training_struct.standard_deviation_3_to_6_core;

sd_dataset = [sd_latency_tile_1_core_training_config_1;
              sd_latency_tile2_1_core_training_config_1; sd_latency_tile2_2_core_training_config_1; sd_latency_tile2_3_core_training_config_1; sd_latency_tile2_4_core_training_config_1; sd_latency_tile2_5_core_training_config_1; sd_latency_tile2_6_core_training_config_1;...
              sd_latency_tile3_1_core_training_config_1; sd_latency_tile3_2_core_training_config_1; sd_latency_tile3_3_core_training_config_1; sd_latency_tile3_4_core_training_config_1; sd_latency_tile3_5_core_training_config_1; sd_latency_tile3_6_core_training_config_1];
end

