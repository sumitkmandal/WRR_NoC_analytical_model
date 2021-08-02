function [ average_latency, sd_latency, lambda_tile, training_data_size ] = read_all_mesh_data( )

[ average_latency_1, sd_latency_1, lambda_tile_1, training_data_size_1 ] = read_mesh_data( 4, 4, 1, 'output_mesh/data_03072018' );
[ average_latency_2, sd_latency_2, lambda_tile_2, training_data_size_2 ] = read_mesh_data( 4, 4, 0, 'output_mesh/data_03062018' );
[ average_latency_3, sd_latency_3, lambda_tile_3, training_data_size_3 ] = read_mesh_data( 4, 4, 1, 'output_mesh/data_03082018' );

average_latency = [average_latency_1; average_latency_2; average_latency_3];
sd_latency = [sd_latency_1; sd_latency_2; sd_latency_3];
lambda_tile = [lambda_tile_1; lambda_tile_2; lambda_tile_3];
training_data_size = training_data_size_1 + training_data_size_2 + training_data_size_3;

end

