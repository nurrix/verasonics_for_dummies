function changeNumPushCycles_Callback(~,~,UIValue)
%pushCycle change
P = Vars.get('P');
TW = Vars.get('TW');
TX = Vars.get('TX');


oldValue = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'numPushCycles');

if ~strcmpi(P.SYS_MODE, 'ARFI')
    UI = Vars.get('UI');
    ui_idx = SWIGEM5Sc.lut.get('UI', 'changeNumPushCycles');
    objHandle = UI(ui_idx);
	warning('Not Running ARFI')
    set(objHandle.handle(2),'Value',oldValue);
    set(objHandle.handle(3),'String',oldValue);
    UI(ui_idx) = objHandle;
    Vars.update('UI', UI)
	return
	
	
end
assert(length(TX)>1, 'TX MUST BE LARGER THAN 1, as a push system must be implemented')
assert(length(TW)>1, 'TW MUST BE LARGER THAN 1, as a push system must be implemented')

newValue = round(UIValue);
% TW(2).oldCycles = OldnumPushCycles;

if newValue == oldValue
	return
end
	
% TW(2) is used for push
if strcmp(TW(2).type,'parametric') || strcmp(TW(2).type,'envelop')
	SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'numPushCycles', newValue)
else
    UI = Vars.get('UI');
    ui_idx = SWIGEM5Sc.lut.get('UI', 'changeNumPushCycles');
    objHandle = UI(ui_idx);
    set(UI(ui_idx).handle(2),'Value',oldValue);
    set(UI(ui_idx).handle(3),'String',oldValue);
    UI(ui_idx) = objHandle;
    Vars.update('UI', UI)
	return
	
end

msg = sprintf('Change push cycles to %4.0f cycles...',newValue);

SWIGEM5Sc.func.updateTW(msg,'TW');

SWIGEM5Sc.ui.setFirstVideoReplay()
end