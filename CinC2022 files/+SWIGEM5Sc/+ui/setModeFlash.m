function setModeFlash(~, ~)
    %% Function if we turn SWI off!
    disp('Flash')
    % if the movie is replay, no response
    is_replay = SWIGEM5Sc.ui.is_replay();
    if is_replay
        msgbox('please stop reply first');
        return
    end
    % make related UI controls unvisible
    figSWIHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figSWIHandle);
	figVelHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figVelHandle);
    figTemporalSWIHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figTemporalSWIHandle);

    UI = Vars.get(SWIGEM5Sc.VarNames.UI);
    for i = 1:length(UI),set(UI(i).handle,'Visible',0),end
    
    
    ui_show_these = {'changeTXRXMode'
        'rangeChange'
        'chooseSWIMoveFocusOrMoveROI'
        'changeROIHeight'
        'changeROIWidth'
        'changeTX1LenseFocus'
        'changeSensCutoff'
		};
   
	for i = 1:length(ui_show_these)
		set( ...
			UI(SWIGEM5Sc.lut.get(SWIGEM5Sc.VarNames.UI, ui_show_these{i})...
			).handle,'Visible', 1)
	end
	
	if ishandle(figSWIHandle),set(figSWIHandle,'Visible',0),end
    if ishandle(figVelHandle),set(figVelHandle,'Visible',0),end
    if ishandle(figTemporalSWIHandle),set(figTemporalSWIHandle,'Visible',0),end

    % make P1 slider visible and P5 slider unvisible
    SWIGEM5Sc.ui.ControlGUIshowP1orP5('Flash')
%     Vars.update(SWIGEM5Sc.VarNames.SWI_initialized, 0)

    % change the start event
    nStart = SWIGEM5Sc.lut.get(SWIGEM5Sc.VarNames.Event, "Flash_Setup");
    Control = evalin('base','Control');
    if isempty(Control(1).Command)
        n=1;
    else
        n=length(Control)+1;
    end
    Control(n).Command = 'set&Run';
    Control(n).Parameters = {'Parameters',1,'startEvent',nStart};

    Resource = Vars.get(SWIGEM5Sc.VarNames.Resource);
    Resource.Parameters.startEvent = nStart;
    Vars.update(SWIGEM5Sc.VarNames.Resource, Resource)
    assignin('base','Control',Control);


end
