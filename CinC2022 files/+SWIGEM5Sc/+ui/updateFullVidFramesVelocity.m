function updateFullVidFramesVelocity()
%% Update the entiree videoframe
UI = Vars.get('UI');
ui_idx = SWIGEM5Sc.lut.get('UI','replayVideo');
ui1 = UI(ui_idx);
set(ui1.handle,'Visible', 0, 'Value', 1);
UI(ui_idx) = ui1;
Vars.update('UI', UI)
figVelHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figVelHandle);
figPwrHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figPowerHandle);
SWIGEM5Sc.ui.setFirstVideoReplay()
SWIGEM5Sc.ui.replayVideoOnce(figVelHandle,figPwrHandle, 1)

UI = Vars.get('UI');
ui1 = UI(ui_idx);
set(ui1.handle,'Visible', 1, 'Value', 0);
UI(ui_idx) = ui1;
Vars.update('UI', UI)
end

