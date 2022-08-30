
function changeIQLoopFps_Callback(obj,evt,UIValue)
% fps adjustment for replay shearwave imaging
loopfps = round(UIValue);
if Vars.get('freeze')
    fprintf('NOTE! LOOPFPS only affects replay mode...\n')
end
SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.Variables,SWIGEM5Sc.VarNames.gui_loopfps, loopfps)




end
