function [effectiveLambdaOfDependentTraffic, sizeOfCoefficients_1, coefficients_1]  = reduceEffectForSelfBufferSharing( dependentTrafficSrc, dependentTrafficDest, targetSrc, targetDest, NO_OF_TILES, lambda_tile, sizeOfCoefficients, coefficients )

sameClassDest = findSameClass( targetSrc, targetDest, NO_OF_TILES );

effectiveLambdaOfDependentTraffic = lambda_tile(dependentTrafficDest, dependentTrafficSrc);
toBeReduced = 0;

for i = length(sameClassDest)
    sizeOfCoefficients = sizeOfCoefficients+1;
    if (lambda_tile(targetDest,targetSrc) ~= 0 && lambda_tile(dependentTrafficDest, dependentTrafficSrc) ~= 0)
%         coefficients(sizeOfCoefficients)
        effectiveLambdaOfDependentTraffic = effectiveLambdaOfDependentTraffic - (coefficients(sizeOfCoefficients))* lambda_tile(sameClassDest(i), targetSrc);
%         coefficients(sizeOfCoefficients)
%         toBeReduced  = toBeReduced + coefficients(sizeOfCoefficients)*(lambda_tile(sameClassDest(i), targetSrc)/lambda_tile(targetDest,targetSrc));
%         toBeReduced  = toBeReduced + coefficients(sizeOfCoefficients)*(lambda_tile(sameClassDest(i), targetSrc));
    end
end

assert (toBeReduced <= 1, 'toBeReduced should be less than or equal to 1\n\n');

% toBeReduced
% effectiveLambdaOfDependentTraffic = effectiveLambdaOfDependentTraffic*(1-toBeReduced);

coefficients_1 = coefficients;
sizeOfCoefficients_1 = sizeOfCoefficients;

end