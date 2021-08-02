function [ lambda_effective, sizeOfCoefficients_out, coefficients_out ] = reduceEffectForBufferSharing( src, dest, NO_OF_TILES, lambda_tile, sizeOfCoefficients, coefficients )

% global coefficients;
% global sizeOfCoefficients;

global effectiveLambdaForBufferSharing;

global visitedNodeForBufferSharing;


% if (effectiveLambdaForBufferSharing(NO_OF_TILES*(src-1)+dest, 2) == 1)
%         lambda_effective = effectiveLambdaForBufferSharing(NO_OF_TILES*(src-1)+dest, 1);
%         sizeOfCoefficients_out = sizeOfCoefficients;
%         coefficients_out = coefficients;
% end

% if (visitedNodeForBufferSharing(NO_OF_TILES*(src-1)+dest) == 1)
%     lambda_effective = 0;
%     sizeOfCoefficients_out = sizeOfCoefficients;
%     coefficients_out = coefficients;
% else
    %if already calculated find from table
    if (effectiveLambdaForBufferSharing(NO_OF_TILES*(src-1)+dest, 2) == 1)
        lambda_effective = effectiveLambdaForBufferSharing(NO_OF_TILES*(src-1)+dest, 1);
        sizeOfCoefficients_out = sizeOfCoefficients;
        coefficients_out = coefficients;
        %     fprintf('Effective lambda of src: %d and dest: %d is found from table\n', src, dest);
    else
        visitedNodeForBufferSharing(NO_OF_TILES*(src-1)+dest) = 1;
        
        sameClassDest = findSameClass( src, dest, NO_OF_TILES );
        
        assert(length(sameClassDest) == NO_OF_TILES/2-1, 'Size of same class destination should be %d',NO_OF_TILES/2-1);
        
        sameClassDestTraffic = zeros(NO_OF_TILES/2-1, 2);
        
        for i = 1:NO_OF_TILES/2-1
            sameClassDestTraffic(i,:) = [src sameClassDest(i)];
        end
        
        trafficToBeConsidered = sameClassDestTraffic;
        
        if (trafficToBeConsidered ~= 0)
            for i = 1:length(trafficToBeConsidered)
                %otherSrc and otherDest is the src and dest for which effect will be
                %reduced
                otherSrc = trafficToBeConsidered(i,1);
                otherDest = trafficToBeConsidered(i,2);
                %     coefficients(sizeOfCoefficients) = 1;
                %         fprintf('src: %d dest: %d will reduce the effect with coefficient %0.4f for src: %d dest: %d\n', otherSrc, otherDest, coefficients(sizeOfCoefficients), src, dest );
%                 fprintf('In reduceEffectForBufferSharing dest: %d, src: %d\n',dest, src);
%                 fprintf('size: %d\n', sizeOfCoefficients);
                [effectiveLambdaOfDependentTraffic, sizeOfCoefficients_1, coefficients_1]  = reduceEffectForChannelSharing( otherSrc, otherDest, NO_OF_TILES, lambda_tile, sizeOfCoefficients, coefficients );
                sizeOfCoefficients = sizeOfCoefficients_1+1;
                coefficients = coefficients_1;
                lambda_effective = lambda_tile(dest, src) - coefficients(sizeOfCoefficients)*effectiveLambdaOfDependentTraffic;
%                 fprintf('In reduceEffectForBufferSharing,(%d, %d) is reducing effect of (%d, %d) with coefficient %0.4f and effective lambda is %0.4f\n',otherSrc, otherDest, src, dest, coefficients(sizeOfCoefficients), lambda_effective);
            end
        end
        
        % effective lambda is zero if original lambda is 0
        if (lambda_tile(dest, src) == 0)
            lambda_effective = 0;
        end
        
        effectiveLambdaForBufferSharing(NO_OF_TILES*(src-1)+dest, :) = [lambda_effective, 1];
        
        %     fprintf('Original lambda is %0.4f and Effective lambda is %0.4f for src: %d dest: %d\n\n', lambda_tile(dest, src), lambda_effective, src, dest);
        sizeOfCoefficients_out = sizeOfCoefficients;
        coefficients_out = coefficients;
        
    end
% end
end

