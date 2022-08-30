function P = initializeP(transducer_name, filename, numTransElmTheta ...
	, numTransElmAzi, numTransmitChannels,numRcvChannels, numBuffers, na, numFrames ...
	, maxHighVoltage, fov_deg,  np, PRF_time, SYS_MODE, numCoherentComp, mwPDelta, rfSamplesPerWave, Coord)
%% Initialize P Structure
	P.na= na;      % Set P.na = number of detect acquisitions. % 50=5ms
	P.np = np;
	P.numBuffers   = numBuffers;
	P.numFrames = numFrames;
	P.units = 'mm';
	P.Coord = Coord; % 'rectangular' (default) | 'polar'
	P.filename = filename;
	P.speedofsound = 1540;
	P.maxHighVoltage = maxHighVoltage;
	P.mwPDelta = mwPDelta;

	P.transName = transducer_name; % 'GEM5ScD', 'GE11LD'
	P.transNumElmTheta = numTransElmTheta;
	P.transNumElmAzi = numTransElmAzi;
	P.numTransmitChannels = numTransmitChannels;      % number of transmit channels.
	P.numRcvChannels = numRcvChannels;    % number of receive channels.
    P.numCoherentComp = numCoherentComp; % Number of coherent compoundings
	P.rfSamplesPerWave = rfSamplesPerWave;
	P.fov_rad = deg2rad(fov_deg);
	P.fov_deg = fov_deg;
	P.PRF_time = PRF_time;
	P.SYS_MODE = SYS_MODE;
end

