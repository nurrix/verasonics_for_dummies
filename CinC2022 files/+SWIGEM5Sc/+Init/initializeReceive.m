function Receive = initializeReceive(transNumElmAzi, transNumElmTheta, startDepth, depthEnd, N,  numFrames, np, na, numCC, rfSamplesPerWave)
	%% Initialize Receive Objects

	apod = ones(1, transNumElmAzi * transNumElmTheta );
	P = Vars.get('P');
	a = depthEnd;
	b = P.apature;
	C = P.fov_rad/2;
	maxSingleTrip_wls =  ceil(sqrt(a^2 + b^2 - 2*a*b*cos(C+pi/2)));
	% - We need na Receives for every frame.
	Receive = repmat(struct('Apod', apod, ...
		'startDepth', startDepth, ...
		'endDepth', maxSingleTrip_wls,...
		'TGC', 1, ...
		'bufnum', N, ...
		'framenum', [], ...
		'acqNum', 1, ...
		...'demodFrequency', 250/11/8, ...
		...'ADCRate', 250/5, ...
		'sampleMode', 'NS200BW', ... 'BS67BW' | 'BS67BW'
		'mode', 0, ...
		'callMediaFunc', 0) ...
		, 1, na * np * numCC * numFrames);
    
    % - Set event specific Receive attributes for each frame.
    for i = 1:numFrames
        ind1 = np*na * (i-1);
        ix(1) = ind1*numCC;
        
        for k = 1:np
            ind2 = na * (k-1);
            ix(2) = ind2 * numCC;
            for j = 1:na
                ix(3) = numCC * (j-1);
                for z = 1:numCC
                    ix(4) = z;
                    Receive(sum(ix)).framenum = i;
                    Receive(sum(ix)).acqNum = ind2+j;
                    if  z == 1&& j ==1% && k == 1 
                		Receive(sum(ix)).callMediaFunc = 1;
                        Receive(sum(ix)).mode = 0;
                    else
                        Receive(sum(ix)).mode = 1;
                		Receive(sum(ix)).callMediaFunc = 0;
                        
                    end
                end
            end
        end
    end
    
    function b = isnewframe(page, acq, cc)
        warning('b = double(page==1  && acq==1 && cc==1); %does not work')
       b = double(page==1  && acq==1 && cc==1); %does not work
    end
end

