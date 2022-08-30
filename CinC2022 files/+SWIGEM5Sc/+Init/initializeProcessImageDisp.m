function Process = initializeProcessImageDisp(pers, N)
%% Initialize a process for updating Image
Process.classname = 'Image';
Process.method = 'imageDisplay';
Process.Parameters = {'imgbufnum',N,...   % number of buffer to process.
	'framenum',-1,...   % (-1 => lastFrame)
	'pdatanum',1,...    % number of PData structure to use
	'pgain',1.0,...            % pgain is image processing gain
	'reject',2,...      % reject level
	'persistMethod','simple',...
	'persistLevel',pers,...
	'interpMethod','4pt',...
	'grainRemoval','none',...
	'processMethod','none',...
	'averageMethod','none',...
	'compressMethod','power',...
	'compressFactor',40,...
	'mappingMode','full',...
	'display',1,...      % display image after processing
	'displayWindow',1};
end

