function changeTX1LenseFocus_Callback(~,~,value)
%% ROI Width change
P = Vars.get('P');
TX = Vars.get('TX');
for i = 1:P.numCoherentComp
    TX(i).focus = value / Vars.ratioFromWls();
    TX(i).Delay = computeTXDelays(TX(i));
end
% Update TX in base.
Vars.update(SWIGEM5Sc.VarNames.TX, TX)
Vars.updateControl('',{'TX'})
end