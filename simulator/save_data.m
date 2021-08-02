cd outputs;

global average_latency_array;

% average_latency_array = average_latency_array';

save('average_latency_tile_to_tile.mat', 'average_latency_array');

global sd_latency_array;

% sd_latency_array = sd_latency_array';

save('sd_tile_to_tile.mat', 'sd_latency_array');

cd ..

