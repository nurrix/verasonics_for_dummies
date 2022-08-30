function chooseSWIMoveFocusOrMoveROI_Callback(~,~,UIState)

SWIGEM5Sc.ui.updateROIandFocus()

primROICenterHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.primROICenterHandle);
fh = Vars.handles.get_primary_figure_handle;
switch UIState
    case 1
		% Change Focus
        set(fh,'WindowButtonDownFcn',@SWIGEM5Sc.ui.callbacks.changeSWPulseFocus_Callback);
        primROICenterHandle.InteractionsAllowed = 'none';
		primROICenterHandle.Visible = false;
	otherwise
		% Move ROI
        set(fh,'WindowButtonDownFcn',[]);
        primROICenterHandle.InteractionsAllowed = 'translate';
		primROICenterHandle.Visible = true;
end
SWIGEM5Sc.ui.setFirstVideoReplay()

end