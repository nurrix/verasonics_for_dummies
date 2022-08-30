
clear all %#ok<CLALL>

tmp_SystemName = 'Vantage256'; % What Vantage system (so we know how many Receive and Transmit channels).
tmp_transducer_name =  'GEM5ScD'; % 'GEM5ScD' | 'GE11LD' are currently implemented.
tmp_Coord = 'polar'; % 'polar' | 'rectangular'. Only Polar works right now.
tmp_SYS_MODE = 'ARFI'; % 'ARFI' | 'SWI'.
tmp_swi_FPS = 10e3; % opt: [1e3 2e3, 5e3, 10e3], Frame rates.

tmp_simulateMode = 0; % 1 forces simulation mode | 2 stops sequence and processes RcvData continuously
tmp_numCoherentComp = 1; % Number of coherent compounding used (still need to be implemented correctly).
tmp_numBuffers = 2; % We need two buffers, for Display Image, and for SWI-array.
tmp_numFrames = [10, 2]; % We need a frame buffer, Vantage will do a form of ping-pong when writing to it.
tmp_np = [1, 50]; % Numbere of pages.
tmp_na = [1, 1]; % Number of acquisitions (we are required to use pages, to use SWI).
tmp_maxHighVoltage = 30; % Peak voltage for transducer.
tmp_depthStartMm = 0; % minimum depth in mm.
tmp_depthMaxMm = 53; % Maximum Depth in mm.
tmp_fov_deg = 90; % Field of View in degrees (system will generally work with radians, but this is easier to understand).
tmp_RFsamplesPerWave = 4; % RF data sampling.

tmp_numPushCycles = 1000; % # of ARFI push waves
tmp_numPushElements = 42; % # of transducer elements for ARFI push

%% Do not change below here!

% Loading json file containing information about transducer + system
tmp_p = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'information.json');
jsonData = jsondecode(fileread(tmp_p)); % 
lambda = 1.54 / jsonData.DefinedTransducers.(tmp_transducer_name).default_frequency;
tmp_depthMax = ceil(tmp_depthMaxMm / lambda);
tmp_depthStart = ceil(tmp_depthStartMm / lambda);
tmp_depthEnd = tmp_depthMax ;
tmp_depthEndMm = tmp_depthEnd * lambda;
tmp_mwPDelta = tmp_depthEnd  / (1440 / 2 - 150); % Resolution of live image.

tmp_numTransElmTheta = jsonData.DefinedTransducers.(tmp_transducer_name).numTransElmTheta;
tmp_numTransElmAzi = jsonData.DefinedTransducers.(tmp_transducer_name).numTransElmAzi;
tmp_numTransmitChannels = jsonData.ValidVantageSystems.(tmp_SystemName).TXChannels;      % number of transmit channels.
tmp_numRcvChannels = jsonData.ValidVantageSystems.(tmp_SystemName).RXChannels;    % number of receive channels.
tmp_PRF_time = 1e6/tmp_swi_FPS; % 1000 000 ns / swi_FPS : Pulse Repetition Time.
filename = sprintf('SetUp_%s_%s_%s_%usubframes', tmp_transducer_name, tmp_SYS_MODE, tmp_Coord,tmp_np(2));

assert(tmp_depthMax >= tmp_depthEnd, 'depthMax must be bigger or equal to depthEnd')


SWIGEM5Sc.DT.initializeDataTable(SWIGEM5Sc.VarNames.Variables)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.Variables, 'depthStart', tmp_depthStart)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.Variables, 'depthStartMm', tmp_depthStartMm)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.Variables, 'depthEnd', tmp_depthEnd)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.Variables, 'depthEndMm', tmp_depthEndMm)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.Variables, 'depthMax', tmp_depthMax)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.Variables, 'depthMaxMm', tmp_depthMaxMm)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.Variables, 'sens_cutoff', 0.6)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.Variables, SWIGEM5Sc.VarNames.gui_loopfps, 15)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.Variables, SWIGEM5Sc.VarNames.TXRX_mode, 'FLASH')
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.Variables, SWIGEM5Sc.VarNames.firstVideoReplay, 0)

P = SWIGEM5Sc.Init.initializeP(tmp_transducer_name ...
	, filename ...
	, tmp_numTransElmTheta ...
	, tmp_numTransElmAzi ...
	, tmp_numTransmitChannels ...
	, tmp_numRcvChannels ...
	, tmp_numBuffers ...
	, tmp_na ...
	, tmp_numFrames ...
	, tmp_maxHighVoltage ...
	, tmp_fov_deg ...
	, tmp_np ...
	, tmp_PRF_time ...
	, tmp_SYS_MODE ...
    , tmp_numCoherentComp ...
	, tmp_mwPDelta ...
	, tmp_RFsamplesPerWave ...
	, tmp_Coord);


% Define system parameters.
Resource.Parameters = SWIGEM5Sc.Init.initializeResourceParameter(...
	P.speedofsound, P.numRcvChannels, P.numTransmitChannels, tmp_simulateMode);


% Specify Trans structure array.
Trans = SWIGEM5Sc.Init.initializeTransducer(P.transName, P.maxHighVoltage);

P.transElmSpacing = Trans.spacing;
P.transElmSpacingMm = Trans.spacingMm;
P.transFrequency = Trans.frequency;
P.ratio2mm = strcmpi(P.units, 'mm') * P.speedofsound / 1000 / P.transFrequency + ~strcmpi(P.units, 'mm') * 1;
P.Vnyq = P.speedofsound/ 2 / Trans.frequency / P.PRF_time;
P.apature = Trans.ElementPos(end, 1) -  Trans.ElementPos(1, 1);
P.apatureMm = P.apature * Vars.ratioFromWls();


SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.Variables ...
	, SWIGEM5Sc.VarNames.gui_velocity_max, floor(P.Vnyq / 0.1 + 1) * 0.1)
% SWI info


tmp_focusZ = 30/lambda;
tmp_focusX = 0;
tmp_ROIHeight = 30;
tmp_arrowInfo.slope = 0;
tmp_arrowInfo.l2r = 1;
tmp_ROIWidth = deg2rad(tmp_fov_deg);
tmp_pushCenterElm = P.transNumElmTheta/2;
tmp_pushStartElm = tmp_pushCenterElm - tmp_numPushElements / 2 + 1;
SWIGEM5Sc.DT.initializeDataTable(SWIGEM5Sc.VarNames.SWIInfo)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.SWIInfo, 'focusX', tmp_focusX)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.SWIInfo, 'focusZ', tmp_focusZ)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.SWIInfo, 'arrowInfo', tmp_arrowInfo)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterX', tmp_focusX)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterZ', tmp_focusZ)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.SWIInfo, 'ROIWidth', tmp_ROIWidth)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.SWIInfo, 'ROIHeight', tmp_ROIHeight)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.SWIInfo, 'numPushCycles', tmp_numPushCycles)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.SWIInfo, 'numPushElements', tmp_numPushElements)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.SWIInfo, 'ElementsPos', Trans.ElementPos(:,1))
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.SWIInfo, 'pushStartElm', tmp_pushStartElm)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.SWIInfo, 'pushStartElmPos', Trans.ElementPos(tmp_pushStartElm,1))


tmp_a = P.apature / 2;
tmp_b = tmp_depthMax;
tmp_C = P.fov_deg / 2 + 90;
tmp_singletripMax =  sqrt(tmp_a^2 + tmp_b^2 - 2*tmp_a * tmp_b * cosd(tmp_C));
tmp_roundtripMax = 2 * tmp_singletripMax;
tmp_roundtripMaxMm = tmp_roundtripMax * Vars.ratioFromWls();

SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.Variables,'roundtripMax', tmp_roundtripMax)
SWIGEM5Sc.DT.append(SWIGEM5Sc.VarNames.Variables,'roundtripMaxMm', tmp_roundtripMaxMm)

% define the max buffer length to prevent writing too much data
tmp_maxBufSizePerAcq = 128 * ceil(SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables, 'roundtripMax') ...
	* P.rfSamplesPerWave * 2 / 128);
P.maxBufSizePerAcq = tmp_maxBufSizePerAcq;

tmp_lambda = 1; % 1 wavelength
tmp_dthetaNQ =  asind(tmp_lambda / P.apature) / 2; % NyQuvist Frequency
P.lambda = tmp_lambda;
P.dTheta = deg2rad(floor(tmp_dthetaNQ * 4) / 4); % Round down 0.25 deg... Cant use wls.. we are talking degrees
P.dthetaNQ = tmp_dthetaNQ;
P.dR = 0.5; % range resolution in wls

% Specify PData structure array.

tmp_depthStart = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables, 'depthStart');
tmp_depthEnd = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables, 'depthEnd');


PData = repmat(struct('Origin',[0,0,0], ...
					'Coord', 'polar', ...
					'PDelta', [P.dTheta, P.dR, 0], ...
					'Size',   round([2 * ceil(1 / 2 * (tmp_depthEnd - tmp_depthStart) / P.dR), P.fov_rad / P.dTheta, 1]), ...
	'Region', struct( ...
	'Shape', struct( ...
	'Name', 'Sector' ...
	, 'Position', [0, 0, 0] ...
	, 'r1', tmp_depthStart ...
	, 'r2', tmp_depthEnd ...
	, 'angle', P.fov_rad ...
	, 'steer', 0 ...Re
	, 'andWithPrev', 0 ...
	))), 1, 2);

c = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,	'ROICenterZ');
h = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,	'ROIHeight');

tmp_Width = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'ROIWidth');
tmp_r1 = c - h / 2;
tmp_r2 = c + h / 2;
tmp_steer = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'ROICenterX');



PData(2).Region.Shape = SWIGEM5Sc.func.updateDPataRegionShape( ...
    PData(2).Region.Shape, tmp_r1, tmp_r2, tmp_steer, tmp_Width);

%% Specify Media object. 'pt1.m' script defines array of point targets.
pt1;
Media.attenuation = -0.5;
Media.function = 'movePoints';


%% Specify RcvBuffer Resources.
N = 1;
Resource.RcvBuffer(N) = SWIGEM5Sc.Init.initializeResourceRcvBuffer( ...
	P.np(N), P.na(N), P.maxBufSizePerAcq, P.numRcvChannels, P.numFrames(N));
Resource.InterBuffer(N) = SWIGEM5Sc.Init.initializeResourceInterBuffer(1, 1);
Resource.ImageBuffer(N) = SWIGEM5Sc.Init.initializeResourceImageBuffer(30);

N = 2;
Resource.RcvBuffer(N) = SWIGEM5Sc.Init.initializeResourceRcvBuffer( ...
	P.np(N), P.na(N), P.maxBufSizePerAcq, P.numRcvChannels, P.numFrames(N));
Resource.InterBuffer(N) = SWIGEM5Sc.Init.initializeResourceInterBuffer(1, P.np(N));

clear N
Resource.DisplayWindow(1) = SWIGEM5Sc.Init.initializeResourceDisplayWindow(P.mwPDelta, ...
	P.filename, P.numFrames(1), P.units ...
	,tmp_depthStart, tmp_depthEnd, P.fov_rad);

clear tmp_*

% Specify Transmit waveform structure.
TW(1) = SWIGEM5Sc.Init.initializeTransmitWaveform(P.transFrequency, 0.67, 2, 1);
if SWIGEM5Sc.ui.with_arfi()
    TW(2) = SWIGEM5Sc.Init.initializeTransmitWaveform(P.transFrequency, 0.67 ...
		, SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'numPushCycles') * 2, 1); % ARFI push

end

% Specify TX structure array.
TX = SWIGEM5Sc.Init.initializeTX(P.transNumElmAzi, P.transNumElmTheta, P.numCoherentComp, P.fov_rad);% );
if SWIGEM5Sc.ui.with_arfi()

    % Set TPC profile 5 high voltage limit.
    TPC(5).maxHighVoltage = Trans.maxHighVoltage;

    TX(2) = SWIGEM5Sc.Init.initializeTX(P.transNumElmAzi, P.transNumElmTheta, P.numCoherentComp, P.fov_rad);% );

	% - Set event specific TX attributes for push.
    TX(2).waveform = 2;
    TX(2).focus = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'focusZ');       % wavelength, can be changed in the GUI
    TX(2).focusX = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'focusX');      % can be changed in the GUI
    TX(2).pushElements = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'numPushElements');       % can be changed in the GUI
    
    TX(2).Apod = SWIGEM5Sc.func.calcApod(P.transNumElmTheta, P.transNumElmAzi...
		, (P.transNumElmTheta - TX(2).pushElements) / 2 + 1, TX(2).pushElements, @(x) ones(1,x));
    
    TX(2).Delay = computeTXDelays(TX(2));
    % - Push Elements Adjustment
    TX(2).oldElements = TX(2).pushElements;
end


% Specify TGC Waveform structure.
tmp_depthMax = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables, 'depthMax');
tmp_depthEnd = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables, 'depthEnd');
tmp_depthStart = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables, 'depthStart');

TGC = SWIGEM5Sc.Init.initializeTGC(tmp_depthEnd);

% Specify Receive structure arrays.
Receive = struct([]);

for N = 1:P.numBuffers
	Receive = [Receive, SWIGEM5Sc.Init.initializeReceive( ...
		P.transNumElmAzi, P.transNumElmTheta, tmp_depthStart, tmp_depthMax ...
		, N,  P.numFrames(N), P.np(N), P.na(N), P.numCoherentComp, P.rfSamplesPerWave)]; %#ok<AGROW>
	
	assignin('base',sprintf('rcv_buffer_end%u',N),length(Receive))
end


% Specify Recon and ReconInfo structures.
[Recon, ReconInfo] = SWIGEM5Sc.Init.initializeReconReconInfo(P, rcv_buffer_end1);


EF(1).Function = vsv.seq.function.ExFunctionDef('UIControlCallback', @SWIGEM5Sc.ui.callbacks.initializeUIControl_Callback);
EF(2).Function = vsv.seq.function.ExFunctionDef('extProcessIQ', @SWIGEM5Sc.func.processIQ);

SWIGEM5Sc.lut.initializeLookupTable(SWIGEM5Sc.VarNames.Process);
clear ans tmp_*
pers = 20;

Process = SWIGEM5Sc.Init.initializeProcessImageDisp(pers, 1);
SWIGEM5Sc.lut.append('Process', 'ImgReconstruct', length(Process))

% Generate image buffer 2
Process = [Process, ...
	SWIGEM5Sc.Init.initializeProcessExtUIControlCallback('UIControlCallback')];
SWIGEM5Sc.lut.append('Process', 'extUIControlCallback', length(Process))

% Generate external processes
Process = [Process, ...
	SWIGEM5Sc.Init.initializeProcessExt( ...
	'extProcessIQ', 'inter',2, 1,'none')];
SWIGEM5Sc.lut.append('Process', 'extProcessIQ', length(Process))



clear tmp_* N


% Specify UI structure
UI = SWIGEM5Sc.ui.initializeUI(P);

% Specify Event structure arrays.
[Event, SeqControl] = SWIGEM5Sc.Init.initializeEvent();

% Save all the structures to a .mat file.
save(fullfile('MatFiles', filename));

%% Automatic VSX Execution:
% Uncomment the following line to automatically run VSX every time you run
% this SetUp script (note that if VSX finds the variable 'filename' in the
% Matlab workspace, it will load and run that file instead of prompting the
% user for the file to be used):

% VSX;