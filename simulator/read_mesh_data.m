function [ average_latency, sd_latency, lambda_tile, training_data_size ] = read_mesh_data( no_of_rows, no_of_cols, diff_injection_rate, path )

cd (path);
% 
% convertTextDataToMat('output_mesh');

no_of_tiles = no_of_rows*no_of_cols;

str_lat_1 = 'average_latency_from_tile_';
str_lat_2 = '_to_tile_';

str_sd_1 = 'sd_latency_from_tile_';
str_sd_2 = '_to_tile_';

for i = 1:no_of_tiles
    for j = 1:no_of_tiles
        lat_data_struct = load(strcat(str_lat_1, int2str(i), str_lat_2, int2str(j), '.mat'));
        latency_data = lat_data_struct.lat_data;
        average_latency(:,j,i) = latency_data;
        
        sd_data_struct = load(strcat(str_sd_1, int2str(i), str_sd_2, int2str(j), '.mat'));
        sdev_data = sd_data_struct.sd_data;
        sd_latency(:,j,i) = sdev_data;
    end
end

training_data_size = length(average_latency(:,1,1));

lambda_tile = zeros(training_data_size, no_of_tiles, no_of_tiles);

if (diff_injection_rate == 0)
    lambda_struct = load('lambda_tile.mat');
    lambda_tile_tot = lambda_struct.lambda;
    
    for i = 1:training_data_size %training data
        for j = 1:no_of_tiles % from
            for k = 1:no_of_tiles %to
                if ( k == j)
                    lambda_tile(i, k, j) = 0;
                else
                    lambda_tile(i, k, j) = lambda_tile_tot(i)/(no_of_tiles-1);
                end
            end
        end
    end
else
    str_injection_rate_1 = 'injection_rates_';
    str_injection_rate_2 = '_to_';
    
    %     for i = 1:training_data_size %training data
    for j = 1:no_of_tiles % from
        for k = 1:no_of_tiles %to
            if ( k == j)
                lambda_tile(:, k, j) = zeros(1,training_data_size); 
            else
                injection_rate_string = strcat(str_injection_rate_1, int2str(j), str_injection_rate_2, int2str(k), '.mat');
                lambda_struct = load(injection_rate_string);
                data = lambda_struct.injection_rate_data;
                lambda_tile(:, k, j) = data(1:training_data_size);
            end
        end
    end
    %     end
end

cd ../..

end

