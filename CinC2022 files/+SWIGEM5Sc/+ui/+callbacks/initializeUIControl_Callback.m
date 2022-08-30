function initializeUIControl_Callback()

    % UI = Vars.get('UI');
    handle_VSX_Control = Vars.get('f');
    handle_VSX_Control.CloseRequestFcn{1} = @SWIGEM5Sc.ui.custom_VSX_close_func;

    % Correct Focus!
    SWIGEM5Sc.func.focusCorrection()

    SWIGEM5Sc.ui.setFirstVideoReplay()
    
    UI = Vars.get('UI');
    val = find(strcmpi(UI(SWIGEM5Sc.lut.get('UI','changeTXRXMode')).handle(1).SelectedObject.String,{'Flash','SWI','ARFI'}));
    
    SWIGEM5Sc.ui.callbacks.changeTXRXModeSWI_Callback(-1,-1,val)
    
%     SWIGEM5Sc.ui.updateROIandFocus()
    
    
end
