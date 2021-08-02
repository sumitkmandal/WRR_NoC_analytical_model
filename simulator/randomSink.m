function [ receiving_tiles ] = randomSink( )

%% This script randomly decides
%       1. how many core will inject
%       2. which cores will inject
%       3. in which tiles packets will be sinked from those cores

% Upon deciding the traffic pattern, this script will also create lambda
% matrix

NUM_OF_RINGS = 6;

%% Deciding how many core will inejct

no_of_cores_receiving = ceil(NUM_OF_RINGS*rand());

% no_of_cores_injecting = 6;

receiving_tiles = zeros(1, no_of_cores_receiving);

%% Deciding which cores will inject

if (no_of_cores_receiving == 6)
    receiving_tiles = [1 2 3 4 5 6];
end

if (no_of_cores_receiving == 1 || no_of_cores_receiving == 5)
    tile = randi(6,1);
    if (no_of_cores_receiving == 1)
        receiving_tiles = tile;
    else
        receiving_tiles = excludeTile( NUM_OF_RINGS, tile );
    end
end

if (no_of_cores_receiving == 2 || no_of_cores_receiving == 4)
    tile_1 = randi(6,1);
    
    temp = randi(6,1);
    
    while (tile_1 == temp)
        temp = randi(6,1);
    end
    
    tile_2 = temp;
    
    tile = [tile_1 tile_2];
    
    if (no_of_cores_receiving == 2)
        receiving_tiles = tile;
    else
        receiving_tiles = excludeTile( NUM_OF_RINGS, tile );
    end
end

if (no_of_cores_receiving == 3)
    tile_1 = randi(6,1);
    
    temp_1 = randi(6,1);
    
    while (tile_1 == temp_1)
        temp_1 = randi(6,1);
    end
    
    tile_2 = temp_1;
    
    temp_2 = randi(6,1);
    
    while (tile_1 == temp_2 || tile_2 == temp_2)
        temp_2 = randi(6,1);
    end
    
    tile_3 = temp_2;
    
    receiving_tiles = [tile_1 tile_2 tile_3];
end

for m = 1:no_of_cores_receiving
    if (receiving_tiles(m) == 0)
        receiving_tiles
        assert (1==0, 'Index of a tile should not be zero. Check algo.\n\n');
    end
end

for y = 1:no_of_cores_receiving
    for z = 1:no_of_cores_receiving
        if (y ~= z && receiving_tiles(y) == receiving_tiles(z))
            receiving_tiles
            assert(1==0, 'Two indices are same in injecting tiles array. Check algo.\n\n');
        end
    end
end



end

