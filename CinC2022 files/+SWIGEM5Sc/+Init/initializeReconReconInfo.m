function [Recon, ReconInfo, k] = initializeReconReconInfo(P, rcv_buffer_end)
%% Initialize Reconstruction parameters
% Specify Recon structure arrays.
% - We need a Recon structure for the 2D image which will be used for each frame.
% Recon(1) is used in regular flash imaging
% Recon(2) is used in Bmode imaging after SWI on
% - 10 IQData frames will be stored after Recon(3) to Recon(12)
numCC = P.numCoherentComp;

if numCC == 1
    txnum = 1;
else
    txnum = floor((numCC+1)/2);
end
senscutoff = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables,'sens_cutoff');
Recon = repmat(struct(...
    'senscutoff', senscutoff, ...
    'pdatanum', 1, ...
    'rcvBufFrame',-1, ...
    'IntBufDest', [], ...
    'ImgBufDest', [], ...
    'RINums',1),1,3);

% flash image reconstruction
Recon(1).IntBufDest = [1,1];	% [interbuffer#, frame#]
Recon(1).ImgBufDest = [1,-1];	% [imgbuffer#, frame#]
Recon(1).RINums = 1;

% SWI image reconstruction
Recon(2).pdatanum = 1;
Recon(2).IntBufDest = [1,1];	% [interbuffer#, frame#]
Recon(2).ImgBufDest = [1,-1];	% [imgbuffer#, frame#]
Recon(2).RINums = 2;

% SWI swi
Recon(3).pdatanum = 2;
Recon(3).IntBufDest = [2,1];	% [interbuffer#, frame#]
Recon(3).ImgBufDest = [0,0];	% [imgbuffer#, frame#]
Recon(3).RINums = 3:P.np(2)+2; %% WARNING< THIS IS HARDCODED> UFF

% Define ReconInfo structures.
% - ReconInfo for 2D frame.
ReconInfo(1) = struct('mode','replaceIntensity', ...  % intensity output.
    'txnum',txnum, ...
    'rcvnum',numCC, ...
    'regionnum',1);

ReconInfo(2) = struct('mode','replaceIntensity', ...  % intensity output.
    'txnum',txnum, ...
    'rcvnum',rcv_buffer_end+numCC, ...                % the first Acq will be shown in the display window
    'regionnum',1);

k = length(ReconInfo); % k keeps track of index of last ReconInfo defined
% We need P.na ReconInfo structures for IQ reconstructions.

ReconInfo((k+1):(k+P.na(2)*P.np(2))) = repmat( ...
	struct('mode', 'WTF', ... % IQ output 'accumIQ' | ‘replaceIQ‘
    'txnum', txnum, ...
    'rcvnum', [], ...
    'regionnum', 1), 1,  P.na(2)*P.np(2));

% - Set specific ReconInfo attributes.
for i = 1:P.np(2)
	ind1 = P.na(2) * (i-1);
    for j = 1:P.na(2)  % For each row in the column
        ReconInfo(k+ind1+j).rcvnum = rcv_buffer_end+(ind1+j)*numCC;
        ReconInfo(k+ind1+j).pagenum = i;
        ReconInfo(k+ind1+j).mode = 'replaceIQ';
    end
end

end