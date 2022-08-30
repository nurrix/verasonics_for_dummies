function TX = initializeTX(transNumElmAzi, transNumElmTheta, numCC, fov_rad)
	%% Initialize Transmit Object structure
	apod = repmat(kaiser(transNumElmTheta, 1)', [1,transNumElmAzi]);
	
	TX = repmat(struct('waveform', 1, ...
		'Origin', [0.0,0.0,0.0], ...
		'Apod', apod, ...
		'focus', -10 / Vars.ratioFromWls(), ...
		'Steer', [0.0,0.0], ...
        'Delay', zeros(size(apod))), 1, numCC);
    
    for n = 1: numCC
%         ang =  fov_rad * ((n-0.5) / numCC - 1/2);
        TX(n).Steer = [0, 0]; % [ang, 0.0]
        TX(n).Delay = computeTXDelays(TX(n));
    end
end

