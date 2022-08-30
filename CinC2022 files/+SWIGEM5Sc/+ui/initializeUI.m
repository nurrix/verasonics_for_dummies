function UI = initializeUI(P)
%% Initializes UI

	%% User specified UI Control Elements
    import vsv.seq.uicontrol.VsSliderControl;
    import vsv.seq.uicontrol.VsButtonControl;
    import vsv.seq.uicontrol.VsButtonGroupControl;
	import vsv.seq.uicontrol.VsToggleButtonControl;

	lut_tbl = SWIGEM5Sc.VarNames.UI;
	SWIGEM5Sc.lut.initializeLookupTable(lut_tbl);
    idx_new = 0;
	
	
    % - Range Change
	depthMax = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables,'depthMax');
	depthEnd = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables,'depthEnd');
	
	
    MinMaxVal = [depthMax/2, depthEnd, depthEnd] * P.ratio2mm; % default unit is wavelength
    AxesUnit = P.units;

    idx_new = idx_new + 1;
    UI(idx_new).Control = VsSliderControl('LocationCode','UserA1','Label',['Range (',AxesUnit,')'],...
        'SliderMinMaxVal',MinMaxVal,'SliderStep',[10/MinMaxVal(2),10/MinMaxVal(2)],'ValueFormat','%3.0f', ...
        'Callback', @SWIGEM5Sc.ui.callbacks.changeRange_Callback);
	SWIGEM5Sc.lut.append(lut_tbl, 'rangeChange', length(UI))

    
    

    % ROI Height Adjustment
    idx_new = idx_new + 1;
	ROIHeight = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROIHeight');
    UI(idx_new).Control = VsSliderControl('LocationCode','UserB1','Label','ROI Height',...
        'SliderMinMaxVal',[20,depthMax,ROIHeight]*P.ratio2mm,...
        'SliderStep',[10/(depthMax*P.ratio2mm),10/(depthMax*P.ratio2mm)],'ValueFormat','%3.0f',...
        'Callback', @SWIGEM5Sc.ui.callbacks.changeROIHeigth_Callback );
	SWIGEM5Sc.lut.append(lut_tbl, 'changeROIHeight', length(UI))

        % ROI adjustment
	ROIWidth = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROIWidth');
    idx_new = idx_new + 1;
    UI(idx_new).Control = VsSliderControl('LocationCode','UserB2','Label','ROI Width deg',...
        'SliderMinMaxVal',[10,P.fov_deg,rad2deg(ROIWidth)],...
        'SliderStep',[5/P.fov_deg,5/P.fov_deg],'ValueFormat','%3.0f',...
        'Callback', @SWIGEM5Sc.ui.callbacks.changeROIWidth_Callback );
	SWIGEM5Sc.lut.append(lut_tbl, 'changeROIWidth', length(UI))
    
        % Change PushCycles
	pushCycle = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'numPushCycles');
    idx_new = idx_new + 1;
    UI(idx_new).Control = VsSliderControl('LocationCode', 'UserB3', 'Label', 'Push cycles',...
        'SliderMinMaxVal',[50, 2000, pushCycle],...
        'SliderStep', [0.05,0.25], 'ValueFormat','%3.0f',...
        'Callback', @SWIGEM5Sc.ui.callbacks.changeNumPushCycles_Callback );
	SWIGEM5Sc.lut.append(lut_tbl, 'changeNumPushCycles', length(UI))
    
    % NumPushElem
    idx_new = idx_new + 1;
	maxPushElm = Vars.get('P').transNumElmTheta;
	numPushElm = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'numPushElements');
    UI(idx_new).Control = VsSliderControl('LocationCode','UserB4','Label','Push Elements',...
        'SliderMinMaxVal',[20,maxPushElm,numPushElm],...
        'SliderStep',[1/80,5/80],'ValueFormat','%3.0f',...
        'Callback', @SWIGEM5Sc.ui.callbacks.changeNumPushElem_Callback );
	SWIGEM5Sc.lut.append(lut_tbl, 'changeNumPushElem', length(UI))
    
    % - Focus Adjustment, off: move Focus = 1, on: move ROI = 2
    idx_new = idx_new + 1;	
    UI(idx_new).Control = vsv.seq.uicontrol.VsButtonGroupControl('LocationCode','UserB5','Title','move Focus/ROI',...
        'PossibleCases',   {'move Focus','move ROI'},...
        'Callback', @SWIGEM5Sc.ui.callbacks.chooseSWIMoveFocusOrMoveROI_Callback);
	SWIGEM5Sc.lut.append(lut_tbl, 'chooseSWIMoveFocusOrMoveROI', length(UI))

    % Change TX/RX Mode between 'Flash'|'SWI'|'ARFI'
    idx_new = idx_new + 1;
    UI(idx_new).Control = VsButtonGroupControl('LocationCode', 'UserB6'...
        , 'Title', 'TX/RX Mode' ...
        , 'PossibleCases', {'Flash', P.SYS_MODE} ... , 'ARFI' ...
        , 'SelectedIndex',1 ...
        , 'Callback', @SWIGEM5Sc.ui.callbacks.changeTXRXModeSWI_Callback);
	SWIGEM5Sc.lut.append(lut_tbl, 'changeTXRXMode', length(UI))

    % - Sensitivity Cutoff
    idx_new = idx_new + 1;
	senscutoff = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables,'sens_cutoff');
    UI(idx_new).Control = VsSliderControl('LocationCode','UserB7','Label','Sens. Cutoff',...
        'SliderMinMaxVal',[0,1.0,senscutoff],...
        'SliderStep',[0.025,0.1],'ValueFormat','%1.3f', ...
        'Callback', @SWIGEM5Sc.ui.callbacks.changeSensCutoff_Callback );
	SWIGEM5Sc.lut.append(lut_tbl, 'changeSensCutoff', length(UI))
    
    % save Raw SWI data. Not sure if this works well.
    idx_new = idx_new + 1;
    UI(idx_new).Control  = VsButtonControl( 'LocationCode', 'UserC8', 'Label', 'SAVE SWI', ...
        'Callback', @(obj,evt) SWIGEM5Sc.ui.callbacks.saveRawSWIData_Callback );
	SWIGEM5Sc.lut.append(lut_tbl, 'saveRawSWIData', length(UI))
	
    % Replay button
    idx_new = idx_new + 1;
    UI(idx_new).Control = VsToggleButtonControl('Label','Replay',...
        'LocationCode','UserC1',...
        ... %'FontUnits','normalized','FontSize',0.5, ...
		'Callback', @SWIGEM5Sc.ui.callbacks.replayVideo_Callback);
	SWIGEM5Sc.lut.append(lut_tbl, 'replayVideo', length(UI))

    % - IQ loop fps adjustment, only works at freeze and replay status
	gui_loopfps = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables,SWIGEM5Sc.VarNames.gui_loopfps);
    idx_new = idx_new + 1;
    UI(idx_new).Control = VsSliderControl('LocationCode','UserC2','Label','IQ loop fps',...
        'SliderMinMaxVal',[1,31,gui_loopfps],...
        'SliderStep',[1/30,5/30],'ValueFormat','%3.0f',...
        'Callback', @SWIGEM5Sc.ui.callbacks.changeIQLoopFps_Callback );
	SWIGEM5Sc.lut.append(lut_tbl, 'changeIQLoopFps', length(UI))
    
    idx_new = idx_new + 1;
    UI(idx_new).Control = VsSliderControl('LocationCode','UserC3','Label','TX1 focus [mm]',...
        'SliderMinMaxVal',[-300,300,-10],...
        'SliderStep',[1/30,0.1],'ValueFormat','%3.0f',...
        'Callback', @SWIGEM5Sc.ui.callbacks.changeTX1LenseFocus_Callback );
	SWIGEM5Sc.lut.append(lut_tbl, 'changeTX1LenseFocus', length(UI))
    
    % Correct velocity image
	gui_velocity_max = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables,'gui_velocity_max');
	
    idx_new = idx_new + 1;
    UI(idx_new).Control = VsSliderControl('LocationCode','UserC4','Label','Velocity Max',...
        'SliderMinMaxVal',[gui_velocity_max/300,gui_velocity_max,gui_velocity_max/300],...
        'SliderStep',[1/100,0.1],'ValueFormat','%3.2f',...
        'Callback', @SWIGEM5Sc.ui.callbacks.changeMaxVelocity_Callback );
	SWIGEM5Sc.lut.append(lut_tbl, 'changeMaxVelocity', length(UI))

    

    % The follow UIs are not using User##

	
end

