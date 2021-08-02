function [ latency ] = latency_calculation( test_data_size, constant_latency, lambda_tile_test, coefficients, no_of_tile )

latency = zeros(1, test_data_size);

for i = 1:test_data_size
    numerator = 0.5;
    denominator = 1;
    
%             for j = 1:no_of_tile %to
%                 for k = 1:no_of_tile %from
%                     numerator = numerator +  coefficients(no_of_tile*(j-1)+k)*lambda_tile_test(i, k, j);
% %                     denominator = denominator - coefficients(1*no_of_tile^2  + no_of_tile*(j-1)+k)*lambda_tile_test(i, k, j);
%                 end
%             end
    %
%     for l1 = 1:no_of_tile
%         expr = 0;
%         for l2 = 1:no_of_tile
%             for l3 = 1:no_of_tile
%                 expr = expr + coefficients(no_of_tile*no_of_tile + no_of_tile*no_of_tile*(l1-1) + no_of_tile*(l2-1) + l3)*...
%                     lambda_tile_test(i,l2,l3);
%                 
%             end
%         end
%         expr = 1 - expr;
%         denominator = denominator*expr;
%     end
%     
    for l1 = 1:no_of_tile
        expr = 0;
        for l2 = 1:no_of_tile
            for l3 = 1:no_of_tile
                expr = expr + coefficients(no_of_tile*no_of_tile*(no_of_tile-1) + no_of_tile*no_of_tile*(l1-1) + no_of_tile*(l2-1) + l3)*...
                    lambda_tile_test(i,l2,l3);
%                 expr = expr + coefficients(no_of_tile*no_of_tile + no_of_tile*no_of_tile*(l1-1) + no_of_tile*(l2-1) + l3)*...
%                     lambda_tile_test(i,l2,l3);
            end
        end
        expr_array(l1) = 1 - expr;
        denominator = denominator*expr_array(l1);
    end
    
    
    
    for j = 2:no_of_tile
%         if (j==1)
%             prod = 1;
%         else
          prod = expr_array(j);
%         end
%         for idx = 1:(j-1)
%             prod = prod*expr_array(idx);
%         end
        lin_expr = 0;
        for k = 1:no_of_tile %to
            for l = 1:no_of_tile %from
                lin_expr = lin_expr +  coefficients(no_of_tile*no_of_tile*(j-2)+no_of_tile*(k-1)+l)*lambda_tile_test(i, k, l);
            end
        end
        numerator = numerator + prod*lin_expr;
    end
    %
%     numerator
%     denominator
    latency(i) = constant_latency + (numerator/denominator);
    
end

end

