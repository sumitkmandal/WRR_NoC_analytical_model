cd outputs;

% global lambda_core_1;
% global lambda_core_2;
% global lambda_core_3;
% global lambda_core_4;
% global lambda_core_5;
% global lambda_core_6;
% 
% global tile_1_sink;
% global tile_2_sink;
% global tile_3_sink;
% global tile_4_sink;
% global tile_5_sink;
% global tile_6_sink;

% lambda_core_1_struct = load('lambda_core_1.mat');
% lambda_core_2_struct = load('lambda_core_2.mat');
% lambda_core_3_struct = load('lambda_core_3.mat');
% lambda_core_4_struct = load('lambda_core_4.mat');
% lambda_core_5_struct = load('lambda_core_5.mat');
% lambda_core_6_struct = load('lambda_core_6.mat');
% 
% if (tile_1_sink == 0)
%     lambda_core_1_data = [lambda_core_1_struct.lambda_core_1_data ; 0 0 0 0 0 0];
%     save('lambda_core_1.mat', 'lambda_core_1_data');
% else
%     cd ..
%     lambda_core_1_array = build_lambda_array(lambda_core_1, tile_1_sink);
%     cd outputs;
%     lambda_core_1_data = [lambda_core_1_struct.lambda_core_1_data ; lambda_core_1_array];
%     save('lambda_core_1.mat', 'lambda_core_1_data');
% end
% 
% 
% if (tile_2_sink == 0)
%     lambda_core_2_data = [lambda_core_2_struct.lambda_core_2_data ; 0 0 0 0 0 0];
%     save('lambda_core_2.mat', 'lambda_core_2_data');
% else
%     cd ..
%     lambda_core_2_array = build_lambda_array(lambda_core_2, tile_2_sink);
%     cd outputs;
%     lambda_core_2_data = [lambda_core_2_struct.lambda_core_2_data ; lambda_core_2_array];
%     save('lambda_core_2.mat', 'lambda_core_2_data');
% end
% 
% 
% if (tile_3_sink == 0)
%     lambda_core_3_data = [lambda_core_3_struct.lambda_core_3_data ; 0 0 0 0 0 0];
%     save('lambda_core_3.mat', 'lambda_core_3_data');
% else
%     cd ..
%     lambda_core_3_array = build_lambda_array(lambda_core_3, tile_3_sink);
%     cd outputs;
%     lambda_core_3_data = [lambda_core_3_struct.lambda_core_3_data ; lambda_core_3_array];
%     save('lambda_core_3.mat', 'lambda_core_3_data');
% end
% 
% 
% if (tile_4_sink == 0)
%     lambda_core_4_data = [lambda_core_4_struct.lambda_core_4_data ; 0 0 0 0 0 0];
%     save('lambda_core_4.mat', 'lambda_core_4_data');
% else
%     cd ..
%     lambda_core_4_array = build_lambda_array(lambda_core_4, tile_4_sink);
%     cd outputs;
%     lambda_core_4_data = [lambda_core_4_struct.lambda_core_4_data ; lambda_core_4_array];
%     save('lambda_core_4.mat', 'lambda_core_4_data');
% end
% 
% 
% if (tile_5_sink == 0)
%     lambda_core_5_data = [lambda_core_5_struct.lambda_core_5_data ; 0 0 0 0 0 0];
%     save('lambda_core_5.mat', 'lambda_core_5_data');
% else
%     cd ..
%     lambda_core_5_array = build_lambda_array(lambda_core_5, tile_5_sink);
%     cd outputs;
%     lambda_core_5_data = [lambda_core_5_struct.lambda_core_5_data ; lambda_core_5_array];
%     save('lambda_core_5.mat', 'lambda_core_5_data');
% end
% 
% 
% if (tile_6_sink == 0)
%     lambda_core_6_data = [lambda_core_6_struct.lambda_core_6_data ; 0 0 0 0 0 0];
%     save('lambda_core_6.mat', 'lambda_core_6_data');
% else
%     cd ..
%     lambda_core_6_array = build_lambda_array(lambda_core_6, tile_6_sink);
%     cd outputs;
%     lambda_core_6_data = [lambda_core_6_struct.lambda_core_6_data ; lambda_core_6_array];
%     save('lambda_core_6.mat', 'lambda_core_6_data');
% end



global average_latency_array;

average_latency_struct = load('average_latency_tile_to_tile.mat');
temp_latency(1,:,:) = average_latency_array;
average_latency_tile_to_tile_data = [average_latency_struct.average_latency_tile_to_tile_data; temp_latency];
save('average_latency_tile_to_tile.mat', 'average_latency_tile_to_tile_data');


global sd_latency_array;

standard_deviation_struct = load('sd_tile_to_tile.mat');
temp_sd(1,:,:) = sd_latency_array;
sd_tile_to_tile_data = [standard_deviation_struct.sd_tile_to_tile_data; temp_sd];
save('sd_tile_to_tile.mat', 'sd_tile_to_tile_data');


cd ..