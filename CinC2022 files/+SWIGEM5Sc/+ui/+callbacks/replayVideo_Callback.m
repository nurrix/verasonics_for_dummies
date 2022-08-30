function replayVideo_Callback(obj, ~)
    if ~Vars.get('freeze')
		set(obj,'Value', 0);
        msgbox('Replay only works if we freeze button!')
        return
    end

    figVelHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figVelHandle);
    figPwrHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figPowerHandle);
    if  ~ishandle(figVelHandle)
        msgbox('You must have SWIon!')
        return
    end
    
    if SWIGEM5Sc.ui.is_replay()
        disp('replay shearwave imaging...');
    else
        disp('Stopped replay...');
    end

    SWIGEM5Sc.ui.setFirstVideoReplay()
    while SWIGEM5Sc.ui.is_replay()
        % Continue to replay video while replay button is 1
        SWIGEM5Sc.ui.replayVideoOnce(figVelHandle ...
            , figPwrHandle,SWIGEM5Sc.DT.get( ...
            SWIGEM5Sc.VarNames.Variables,'gui_loopfps'));     
        drawnow
    end
    
end