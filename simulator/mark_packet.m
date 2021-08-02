function [ ] = mark_packet( source, payload )

%% Marks the packet which have been received

global debugRequired;
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

assert(debugRequired == 1, 'Scoreboard is not needed if debug is not required\n\n');

if (mod(payload, 2) == 0)
    
    if (source == 1)
        assert(payload/2 <= tile1_core_size, 'Payload is %d and tile1_core_size is %d\n\n', payload, tile1_core_size)
        tile1_core((payload/2), 3) = 1;
    end
    
    
    if (source == 2)
        assert(payload/2 <= tile2_core_size, 'Payload is %d and tile2_core_size is %d\n\n', payload, tile2_core_size)
        tile2_core((payload/2), 3) = 1;
    end
    
    if (source == 3)
        assert(payload/2 <= tile3_core_size, 'Payload is %d and tile3_core_size is %d\n\n', payload, tile3_core_size)
        tile3_core((payload/2), 3) = 1;
    end
    
    if (source == 4)
        assert(payload/2 <= tile4_core_size, 'Payload is %d and tile4_core_size is %d\n\n', payload, tile4_core_size)
        tile4_core((payload/2), 3) = 1;
    end
    
else
    
    if (source == 1)
        assert((payload-1)/2 <= tile1_cache_size, 'Payload is %d and tile1_cache_size is %d\n\n', payload, tile1_cache_size)
        tile1_cache(((payload-1)/2), 3) = 1;
    end
    
    if (source == 2)
        assert((payload-1)/2 <= tile2_cache_size, 'Payload is %d and tile2_cache_size is %d\n\n', payload, tile2_cache_size)
        tile2_cache(((payload-1)/2), 3) = 1;
    end
    
    if (source == 3)
        assert((payload-1)/2 <= tile3_cache_size, 'Payload is %d and tile3_cache_size is %d\n\n', payload, tile3_cache_size)
        tile3_cache(((payload-1)/2), 3) = 1;
    end
    
    if (source == 4)
        assert((payload-1)/2 <= tile4_cache_size, 'Payload is %d and tile4_cache_size is %d\n\n', payload, tile4_cache_size)
        tile4_cache(((payload-1)/2), 3) = 1;
    end
    
end
end

