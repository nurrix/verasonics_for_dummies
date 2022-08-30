function changeMaxVelocity_Callback(~, ~, plt_velocity_max)
%% Update velocity_max value
% Also, if it exist, update caxis of VelaxHandle
% return
SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.Variables, ...
	SWIGEM5Sc.VarNames.gui_velocity_max, plt_velocity_max)

figVelHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figVelHandle);
if ~ishandle(figVelHandle)
    % Check if variable is defined.
    return
end
caxis(gca(figVelHandle), [-plt_velocity_max, plt_velocity_max])

figTemporalSWIHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figTemporalSWIHandle);
if ~ishandle(figTemporalSWIHandle)
    % Check if variable is defined.
    return
end
caxis(gca(figTemporalSWIHandle), [-plt_velocity_max, plt_velocity_max])

SWIGEM5Sc.ui.setFirstVideoReplay()
end