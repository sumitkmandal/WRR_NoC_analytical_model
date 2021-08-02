function [ coeffs ] = modify_data_and_get_coeffs( src, dest, average_latency_orig, sd_orig, lambda_tile_orig, options, offset, NO_OF_TILES )

[ lambda_tile_modified, average_latency_tile_modified, standard_deviation_tile_modified ] = ...
    remove_lambda_of_zero_latency( lambda_tile_orig, average_latency_orig, sd_orig, NO_OF_TILES );

% global coefficients;
% global sizeOfCoefficients;

% coefficients = zeros(1,100);

training_data_size_modified = length(average_latency_tile_modified)

lambda_tile_part(:,:) = lambda_tile_modified(1,:,:);
sizeOfCoefficients = 0;
coefficientsDummy = zeros(1,1000);
[predicted_latency, sizeOfCoefficients_out, coefficients_out, higherLowerBound] = findOverAllWaitTimeExpression( src, dest, NO_OF_TILES, offset, lambda_tile_part, sizeOfCoefficients, coefficientsDummy );
lb = zeros(1,sizeOfCoefficients_out);
ub = 0.25*ones(1,sizeOfCoefficients_out);
higherLowerBound = higherLowerBound(2:length(higherLowerBound));

for i = 1:length(higherLowerBound)
    lb(higherLowerBound(i)) = 0;
    ub(higherLowerBound(i)) = 0.25;
end

sizeOfCoefficients_out
% x_tile_0 = zeros(1, (2*NO_OF_TILES^3+NO_OF_TILES+1));
x_tile_0 = zeros(1,sizeOfCoefficients_out);

% coeffs = fmincon (@(x_tile_arr) prediction_function_with_sd(average_latency_tile_modified, training_data_size_modified, offset, lambda_tile_modified, x_tile_arr, NO_OF_TILES, standard_deviation_tile_modified), ...
%     x_tile_0, [], [], [], [], [], [], [], options);

coeffs = fmincon (@(coefficients) prediction_function_with_sd_and_recusrion(src, dest, average_latency_tile_modified, training_data_size_modified, offset, lambda_tile_modified, coefficients, NO_OF_TILES, standard_deviation_tile_modified), ...
    x_tile_0, [], [], [], [], lb, ub, [], options);

% coeffs = GODLIKE (@(x_tile_arr) prediction_function_with_sd(average_latency_tile_modified, training_data_size_modified, offset, lambda_tile_modified, x_tile_arr, 6, standard_deviation_tile_modified), ...
%      -20*ones(1,72), 20*ones(1,72));

end

