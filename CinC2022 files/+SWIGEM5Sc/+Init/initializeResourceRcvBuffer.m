function RcvBuffer = initializeResourceRcvBuffer(np, na, maxBufSizePerAcq, numRcvChannels, numFrames)
% Specify Receive Buffer Resources
    RcvBuffer.datatype     = 'int16';
    RcvBuffer.rowsPerFrame = np*na*maxBufSizePerAcq; % this size allows for maximum range (RF data)
    RcvBuffer.colsPerFrame = numRcvChannels;
    RcvBuffer.numFrames    = numFrames;    % 30 frames stored in RcvBuffer.


end

