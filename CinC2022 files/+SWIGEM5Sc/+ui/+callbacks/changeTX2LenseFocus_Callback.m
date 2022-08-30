function changeTX2LenseFocus_Callback(obj,evt,value)
%% ROI Width change
P = Vars.get('P');
TX = Vars.get('TX');
for i = P.numCoherentComp+1 : length(TX)
    TX(i).focus = value / Vars.ratioFromWls();
    TX(i).Delay = computeTXDelays(TX(i));
end
% Update TX in base.
Vars.update(SWIGEM5Sc.VarNames.TX, TX)
Vars.updateControl('',{'TX'})
end