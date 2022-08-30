
function changeSensCutoff_Callback(~,~,sens_cutoff)
%Sensitivity cutoff change
Recon = Vars.get(SWIGEM5Sc.VarNames.Recon);
for i = 1:length(Recon)
    Recon(i).senscutoff = sens_cutoff;
end

Recon = Vars.get(SWIGEM5Sc.VarNames.Recon);
Vars.update(SWIGEM5Sc.VarNames.Recon, Recon)

SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.Variables, 'sens_cutoff', sens_cutoff)

Vars.updateControl('',  {SWIGEM5Sc.VarNames.Recon})
SWIGEM5Sc.ui.setFirstVideoReplay()
end