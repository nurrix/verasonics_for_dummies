function Parameters = initializeResourceParameter(speedofsound, numRcvChannels, numTransmitChannels, simulateMode)
%% Initialize Parameter Resources
Parameters.numTransmit    = numTransmitChannels;   % number of transmit channels.
Parameters.numRcvChannels = numRcvChannels;   % number of receive channels.
Parameters.speedOfSound   = speedofsound;  % set speed of sound in m/sec before calling computeTrans
Parameters.verbose        = 2;
Parameters.initializeOnly = 0;
Parameters.simulateMode   = simulateMode;
Parameters.waitForProcessing = 0;

end

