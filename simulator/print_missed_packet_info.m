function [ ] = print_missed_packet_info()
%% DETERMINES MISSED PACKETS AND PRINTS IN A FILE

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

find_status_zero_and_print(tile1_core, tile1_core_size, 1);
find_status_zero_and_print(tile2_core, tile2_core_size, 2);
find_status_zero_and_print(tile3_core, tile3_core_size, 3);
find_status_zero_and_print(tile4_core, tile4_core_size, 4);

find_status_zero_and_print(tile1_cache, tile1_cache_size, 1);
find_status_zero_and_print(tile2_cache, tile2_cache_size, 2);
find_status_zero_and_print(tile3_cache, tile3_cache_size, 3);
find_status_zero_and_print(tile4_cache, tile4_cache_size, 4);

end

