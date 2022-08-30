function setModeSWI(~, ~)
    %% On setModeSWI, we wish to start shear wave estimations.
    
    %% UPDATE VARIABLES
    
    disp('SWI')
    % change start event
    P = Vars.get(SWIGEM5Sc.VarNames.P);
    Resource = Vars.get(SWIGEM5Sc.VarNames.Resource);
    nStart = SWIGEM5Sc.lut.get(SWIGEM5Sc.VarNames.Event, "SWI_Setup");
    Resource.Parameters.startEvent = nStart;
    Vars.update(SWIGEM5Sc.VarNames.Resource, Resource)
    
    %% MATH
	SWIGEM5Sc.func.focusCorrection()
    
    
    %% UPDATE VARIABLES
    % newIQ is used for check whether new SWI axes is required
    
    
    %% UI update
    UI = Vars.get(SWIGEM5Sc.VarNames.UI); 
    
    figSWIHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figSWIHandle);
    figVelHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figVelHandle);
    figPwrHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figPowerHandle);
    figTemporalSWIHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figTemporalSWIHandle);
        
    % make SWI figure, blue region, and red mark visible
    if ishandle(figSWIHandle); set(figSWIHandle,'Visible',1);end
    if ishandle(figVelHandle);  set(figVelHandle,'Visible',1);end
    if ishandle(figPwrHandle);  set(figPwrHandle,'Visible',1);end
    if ishandle(figTemporalSWIHandle); set(figTemporalSWIHandle,'Visible',1);end
    
    for i = 2:length(UI)
        set(UI(i).handle,'Visible',1);
    end
    
    
    ui_hide_these = {
        'changeNumPushCycles'
        'changeNumPushElem'
        'rangeChange'
        };
    
    for i = 1:length(ui_hide_these)
        set( ...
            UI(SWIGEM5Sc.lut.get(SWIGEM5Sc.VarNames.UI, ui_hide_these{i})...
            ).handle,'Visible', 0)
    end
    
    Vars.update('UI', UI)
        
    % make P1 slider unvisible and P5 slider visible
    SWIGEM5Sc.ui.ControlGUIshowP1orP5(P.SYS_MODE)
    
    Control = Vars.get(SWIGEM5Sc.VarNames.Control);
	n = length(Control) + ~isempty(Control(1).Command);
	s.Command ='set&Run';
	s.Parameters = {'Parameters',1,'startEvent',nStart};
    Control(n) = s;
    
    Vars.update(SWIGEM5Sc.VarNames.Control,Control);
    

end
