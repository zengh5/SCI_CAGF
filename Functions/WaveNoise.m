function [tc, coefVar]=WaveNoise(coef,NoiseVar);

tc = coef.^2;
coefVar = Threshold(filter2(ones(3,3)/(3*3), tc), NoiseVar);

for w = 5:2:9
    EstVar = Threshold(filter2(ones(w,w)/(w*w), tc), NoiseVar);
    coefVar = min(coefVar, EstVar);
end

% Wiener filter like attenuation
tc = coef.*NoiseVar./(coefVar+NoiseVar);
