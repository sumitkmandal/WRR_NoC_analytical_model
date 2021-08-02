function func_out = prediction_function_with_sd_and_recusrion( src, dest, average_latency, training_data_size, constant_latency, lambda_tile, coefficients, NO_OF_TILES, standard_deviation )

func = 0;

serviceTime = 2;

prediction_error = 0;

for i = 1:training_data_size
    
    sizeOfCoefficients = 0;
    
    lambda_tile_part(:,:) = lambda_tile(i,:,:);
    
    [predicted_latency, sizeOfCoefficients_out, coefficients_out] = findOverAllWaitTimeExpression( src, dest, NO_OF_TILES, serviceTime, lambda_tile_part, sizeOfCoefficients, coefficients );
    
    %     if (isnan(predicted_latency) == 1)
    %         fprintf('Average latency is %f\n', average_latency(i));
    %     end
    
    predicted_latency = predicted_latency + constant_latency;
    
    %     average_latency(i) = average_latency(i)/(average_latency(i) + 10);
    %     predicted_latency = predicted_latency/(predicted_latency + 10);
    
    %         if (standard_deviation(i) ~= 0)
    %             error = (average_latency(i) - predicted_latency)/ (average_latency(i)*(standard_deviation(i)));
    %         else
    %             error = (average_latency(i) - predicted_latency)/ (average_latency(i));
    %         end
    
    error = (average_latency(i) - predicted_latency)/ (average_latency(i));
    
%     fprintf('Original latency is %0.4f and predicted latnecy is %0.4f\n',average_latency(i), predicted_latency);
    
    prediction_error = prediction_error + abs((average_latency(i) - predicted_latency)/ (average_latency(i)));
    normalized_error = abs(error);
    func = func + normalized_error;
end

prediction_error/training_data_size

func_out = func;

end