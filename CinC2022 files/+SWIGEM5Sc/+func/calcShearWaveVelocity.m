function [Power, SWV] = calcShearWaveVelocity(I, Q)
%% Calculate shear wave velocity from the IQ data.
% Im = I1 * Q2 - I2 * Q1
% Re = I1 * I2 + Q1 * Q2
% R1 = Re + i Im
% or simply R1 = IQ2 * conj(IQ1)

% Filters
wsz1 = 9;
% kernel1(:, 1, 1, 1) = gausswin(wsz1) ./ sum(gausswin(wsz1));
% kernel2(1, :, 1, 1) = gausswin(wsz1) ./ sum(gausswin(wsz1));
k4sz = 9;
% kernel4(1, 1, 1, :) = gausswin(k4sz) ./ sum(gausswin(k4sz));%1/k4sz*ones(1,k4sz);

P = Vars.get(SWIGEM5Sc.VarNames.P);
% FR = 1e6 / P.PRF_time / P.numCoherentComp;
T_prt = P.PRF_time * 1e-3; % Tprt in ms
c = Vars.speedofsound_mmmicrosec; % mm / \mu sec
f0 = P.transFrequency; % central frequency in MHz
V_nyq = c / f0 / 2 / T_prt; % nyqvist velocity measured in m/s


IQ = complex(I,Q);

%% All of these are equivilent (its a 1lag autocorrelation!)
% IQhalf = 1/2 * (IQ(:,:,:,1:end-1) + IQ(:,:,:,2:end));
% R1 = 1/2 * conj(IQ(:,:,:,1:end-1)-IQhalf) .* (IQ(:,:,:,2:end)-IQhalf);
% R1x = 1/4 * (IQ(:,:,:,2:end) - IQ(:,:,:,1:end-1)).* conj(IQ(:,:,:,1:end-1) - IQ(:,:,:,2:end));
R1 = IQ(:,:,:,2:end) .* conj(IQ(:,:,:,1:end-1)); % Easiest!, IQ2 * conj(IQ1)

% S3 - Moving avg spatial and temporal
R1 = movmean(movmean(movmean(R1, wsz1, 1), wsz1, 2),k4sz, 4);

% S4 - Phase Angle
PHI = angle(R1);

% S5.1 - SWV
SWV = PHI ./ (2*pi)*V_nyq;

% S5.2 - Power 
Power = log10(real(R1).^2 + imag(R1).^2);
end

