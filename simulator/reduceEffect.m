function [ lambda_effective, sizeOfCoefficients_out, coefficients_out ] = reduceEffect( src, dest, NO_OF_TILES, lambda_tile, sizeOfCoefficients, coefficients )

% global coefficients;
% global sizeOfCoefficients;

global effectiveLambda;

assert(0, 'This code should not be used\n');

%if already calculated find from table
if (effectiveLambda(NO_OF_TILES*(src-1)+dest, 2) == 1)
    lambda_effective = effectiveLambda(NO_OF_TILES*(src-1)+dest, 1);
    sizeOfCoefficients_out = sizeOfCoefficients;
    coefficients_out = coefficients;
%     fprintf('Effective lambda of src: %d and dest: %d is found from table\n', src, dest);
else
    
    dependentTraffic = findDependentTraffic( src, dest, NO_OF_TILES );
    
    hasDependentTraffic = 0;
    
    if (dependentTraffic ~= 0)
%         hasDependentTraffic = 1;
    end
    
    sameClassDest = findSameClass( src, dest, NO_OF_TILES );
    
    assert(length(sameClassDest) == NO_OF_TILES/2-1, 'Size of same class destination should be %d',NO_OF_TILES/2-1);
    
    sameClassDestTraffic = zeros(NO_OF_TILES/2-1, 2);
    
    for i = 1:NO_OF_TILES/2-1
        sameClassDestTraffic(i,:) = [src sameClassDest(i)];
    end
    
    if (hasDependentTraffic == 1)
        trafficToBeConsidered =  [sameClassDestTraffic; dependentTraffic];
    else
        trafficToBeConsidered = sameClassDestTraffic;
    end
    
    if (trafficToBeConsidered ~= 0)
        for i = 1:length(trafficToBeConsidered)
            
            %otherSrc and otherDest is the src and dest for which effect will be
            %reduced
            otherSrc = trafficToBeConsidered(i,1);
            otherDest = trafficToBeConsidered(i,2);
            sizeOfCoefficients = sizeOfCoefficients+1;
            %     coefficients(sizeOfCoefficients) = 1;
            %         fprintf('src: %d dest: %d will reduce the effect with coefficient %0.4f for src: %d dest: %d\n', otherSrc, otherDest, coefficients(sizeOfCoefficients), src, dest );
            lambda_effective = lambda_tile(dest, src) - coefficients(sizeOfCoefficients)*lambda_tile(otherDest, otherSrc);
        end
    end
    
    if (lambda_tile(dest, src) == 0)
        lambda_effective = 0;
    end
    
    effectiveLambda(NO_OF_TILES*(src-1)+dest, :) = [lambda_effective, 1];
    
%     fprintf('Original lambda is %0.4f and Effective lambda is %0.4f for src: %d dest: %d\n\n', lambda_tile(dest, src), lambda_effective, src, dest);
    sizeOfCoefficients_out = sizeOfCoefficients;
    coefficients_out = coefficients;
    
end

end

