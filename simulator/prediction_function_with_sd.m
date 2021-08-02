function func_out = prediction_function_with_sd( average_latency, training_data_size, constant_latency, lambda_tile, coefficients, no_of_tile, standard_deviation )

func = 0;
% no_of_tile
% standard_deviation
for i = 1:training_data_size
    numerator = 0.5;
    denominator = 1;
    
%         for j = 1:no_of_tile %to
%             for k = 1:no_of_tile %from
%                 numerator = numerator +  coefficients(no_of_tile*(j-1)+k)*lambda_tile(i, k, j);
% %                 denominator = denominator - coefficients(1*no_of_tile^2  + no_of_tile*(j-1)+k)*lambda_tile(i, k, j);
%             end
%         end
%     
%         for l1 = 1:no_of_tile
%             expr = 0;
%             for l2 = 1:no_of_tile
%                 for l3 = 1:no_of_tile
%                     expr = expr + coefficients(no_of_tile*no_of_tile + no_of_tile*no_of_tile*(l1-1) + no_of_tile*(l2-1) + l3)*...
%                         lambda_tile(i,l2,l3);
%                 end
%             end
%             expr = 1 - expr;
%             denominator = denominator*expr;
%         end
    
    for l1 = 1:no_of_tile
        expr = 0;
        for l2 = 1:no_of_tile
            for l3 = 1:no_of_tile
%                 expr = expr + coefficients(no_of_tile*no_of_tile*(no_of_tile-1) + no_of_tile*no_of_tile*(l1-1) + no_of_tile*(l2-1) + l3)*...
%                     lambda_tile(i,l2,l3);
                expr = expr + coefficients((1+no_of_tile^2)*(no_of_tile) + no_of_tile*no_of_tile*(l1-1) + no_of_tile*(l2-1) + l3)*...
                    lambda_tile(i,l2,l3);
            end
        end
        expr_array(l1) = 1 - expr;
        denominator = denominator*expr_array(l1);
    end
    
%     denominator
    
    for j = 2:no_of_tile
%         if (j==1)
%             prod = 1;
%         else
          prod = expr_array(j);
%         end
%         for idx = 1:(j-1)
%             prod = prod*expr_array(idx);
%         end
        lin_expr = 0.5*coefficients((no_of_tiles^2+1)*(j-2)+1);
        for k = 1:no_of_tile %to
            for l = 1:no_of_tile %from
                lin_expr = lin_expr +  coefficients(((no_of_tile^2+1)*(j-2)+1)+no_of_tile*(k-1)+l)*lambda_tile(i, k, l);
            end
        end
        numerator = numerator + prod*lin_expr;
    end
    
    % cooking residual term
    
    lin_expr = 0.5*coefficients((no_of_tiles^2+1)*(no_of_tiles-1))+1;
    
    for k = 1:no_of_tile %to
        for l = 1:no_of_tile %from
            lin_expr = lin_expr + coefficients(((no_of_tile^2+1)*(no_of_tiles-1)+1)+no_of_tile*(k-1)+l)*lambda_tile(i, k, l);
        end
    end
    
    prod = (lin_expr*denominator)/expr_array(1); % residual term cooked
    
    numerator = numerator + prod;
    
    
%     numerator
    
    predicted_latency = constant_latency + (numerator/denominator);
    if (standard_deviation(i) ~= 0)
        error = (average_latency(i) - predicted_latency)/ (average_latency(i)*(standard_deviation(i)));
    else
        error = (average_latency(i) - predicted_latency)/ (average_latency(i));
    end

%     error = (average_latency(i) - predicted_latency)/ (average_latency(i));
    normalized_error = error^2;
    func = func + normalized_error;
    
end
func_out = func;

end

