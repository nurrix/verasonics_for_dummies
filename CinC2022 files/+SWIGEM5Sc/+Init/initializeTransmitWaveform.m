function TW = initializeTransmitWaveform(frequency, drivetime, numHalfCycles,  polarity)
%% Initialize transmit waveforms
% frequency : frequency  of the transmit pulse and sets the half cycle period of our waveform. 
%
% drivetime : time that the transmit drivers are active in the half cycle period. We can
% set this value to between 0.1 and 1.0 to control the amount of power delivered by a
% transmitter. 0.67 can be used to generate a digital drive waveform that
% approximates a sine wave. 
% 
% numHalfCycles : the number of half cycles in the transmit waveform. 2 providing a single cycle burst. 
%
% polarity : the initial polarity of the first half cycle, with -1 indicating a negative
% polarity.  
%
% Standard value could be 
% initializeTransmitWaveform(Trans.frequency, 0.67, 2,  1)

TW(1).type = 'parametric';
TW(1).Parameters = [frequency, drivetime, numHalfCycles, polarity];

end

