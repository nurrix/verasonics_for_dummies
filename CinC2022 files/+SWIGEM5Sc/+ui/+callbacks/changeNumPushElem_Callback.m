
function changeNumPushElem_Callback(~,~,UIValue)
%PushElements adjustment
P = Vars.get('P');

oldValue = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'numPushElements');
if ~strcmpi(P.SYS_MODE, 'ARFI') || Vars.get(Vars.Names.freeze)
    ui_idx = SWIGEM5Sc.lut.get('UI', 'changeNumPushElem');
    UI = Vars.get('UI');
    objHandle = UI(ui_idx);
    warning('Not Running ARFI')
    set(objHandle.handle(2),'Value',oldValue);
    set(objHandle.handle(3),'String',oldValue);
    UI(ui_idx) = objHandle;
    Vars.update('UI', UI)
    if ~strcmpi(P.SYS_MODE, 'ARFI')
        fprintf('P.SYS_MODE should be "ARFI", was : "%s"\n', P.SYS_MODE)
        
    end
    
    if Vars.get(Vars.Names.freeze)
        fprintf('System is paused, so you cant change number of push Elements....\n')
    end
    return
end

newValue = round(UIValue); %(get(UI(ui_idx_push_elm).handle(2),'Value'));

if  oldValue == newValue
	return
end

SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo,'numPushElements', newValue);

% on, focussCorrection and TXupdate


SWIGEM5Sc.func.focusCorrection();

msg = sprintf('Change push elements to %u elements...', newValue);
SWIGEM5Sc.func.updateTX(msg);

SWIGEM5Sc.ui.updateROIandFocus()

SWIGEM5Sc.ui.setFirstVideoReplay()
end
