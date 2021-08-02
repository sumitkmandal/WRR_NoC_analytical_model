function [ latency ] = latency_calculation_with_recursion( src, dest, test_data_size, constant_latency, lambda_tile, coefficients, NO_OF_TILES )

latency = zeros(1, test_data_size);
% coefficients
serviceTime = 2;


for i = 1:test_data_size
% for i = 1:1
    fprintf('index is %d\n', i)
    sizeOfCoefficients = 0;
    
    lambda_tile_part(:,:) = lambda_tile(i,:,:);
    
    [predicted_latency, sizeOfCoefficients_out, coefficients_out] = findOverAllWaitTimeExpression( src, dest, NO_OF_TILES, serviceTime, lambda_tile_part, sizeOfCoefficients, coefficients );
    
    predicted_latency = predicted_latency + constant_latency;

    latency(i) = predicted_latency;
    
end