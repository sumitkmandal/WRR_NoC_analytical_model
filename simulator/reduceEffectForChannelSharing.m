function [ lambda_effective, sizeOfCoefficients_out, coefficients_out ] = reduceEffectForChannelSharing( src, dest, NO_OF_TILES, lambda_tile, sizeOfCoefficients, coefficients )

% global coefficients;
% global sizeOfCoefficients;

global effectiveLambdaForChannelSharing;

global visitedNodeForChannelSharing;

% if (visitedNodeForChannelSharing(NO_OF_TILES*(src-1)+dest) == 1)
%     lambda_effective = 0;
%     sizeOfCoefficients_out = sizeOfCoefficients;
%     coefficients_out = coefficients;
% else
    %if already calculated find from table
    if (effectiveLambdaForChannelSharing(NO_OF_TILES*(src-1)+dest, 2) == 1)
        lambda_effective = effectiveLambdaForChannelSharing(NO_OF_TILES*(src-1)+dest, 1);
        sizeOfCoefficients_out = sizeOfCoefficients;
        coefficients_out = coefficients;
        %     fprintf('Effective lambda of src: %d and dest: %d is found from table\n', src, dest);
    else
        visitedNodeForChannelSharing(NO_OF_TILES*(src-1)+dest) = 1;
        
        dependentTraffic = findDependentTraffic( src, dest, NO_OF_TILES );
        
        trafficToBeConsidered =  dependentTraffic;
        
        if (trafficToBeConsidered ~= 0)
            for i = 1:length(trafficToBeConsidered)
                
                %otherSrc and otherDest is the src and dest for which effect will be
                %reduced
                otherSrc = trafficToBeConsidered(i,1);
                otherDest = trafficToBeConsidered(i,2);
%                 sizeOfCoefficients = sizeOfCoefficients+1;
                %     coefficients(sizeOfCoefficients) = 1;
                %         fprintf('src: %d dest: %d will reduce the effect with coefficient %0.4f for src: %d dest: %d\n', otherSrc, otherDest, coefficients(sizeOfCoefficients), src, dest );
%                 fprintf('In reduceEffectForChannelSharing dest: %d, src: %d\n',dest, src);
%                 fprintf('size: %d\n', sizeOfCoefficients);
%                 [effectiveLambdaOfDependentTraffic, sizeOfCoefficients_1, coefficients_1]  = reduceEffectForBufferSharing( otherSrc, otherDest, NO_OF_TILES, lambda_tile, sizeOfCoefficients, coefficients );
%                 sizeOfCoefficients = sizeOfCoefficients_1+1;
%                 coefficients = coefficients_1;
                sizeOfCoefficients = sizeOfCoefficients+1;
                effectiveLambdaOfDependentTraffic = lambda_tile(otherDest, otherSrc);
                lambda_effective = lambda_tile(dest, src) - coefficients(sizeOfCoefficients)*effectiveLambdaOfDependentTraffic;
            end
        else
            lambda_effective = lambda_tile(dest, src);
        end
        
        %effective lambda is 0 if original lambda is 0
        if (lambda_tile(dest, src) == 0)
            lambda_effective = 0;
        end
        
        effectiveLambdaForChannelSharing(NO_OF_TILES*(src-1)+dest, :) = [lambda_effective, 1];
        
        %     fprintf('Original lambda is %0.4f and Effective lambda is %0.4f for src: %d dest: %d\n\n', lambda_tile(dest, src), lambda_effective, src, dest);
        sizeOfCoefficients_out = sizeOfCoefficients;
        coefficients_out = coefficients;
        
    end
% end

end

