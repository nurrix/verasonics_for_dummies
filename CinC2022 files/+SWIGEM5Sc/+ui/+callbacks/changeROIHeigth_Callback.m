
function changeROIHeigth_Callback(~,~,HeightMm)
%% ROI Height change
ratio = Vars.ratioFromWls();
P = Vars.get(SWIGEM5Sc.VarNames.P);


ROICenterZ = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterZ');
depthStart = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables, 'depthStart');
depthEnd = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables, 'depthEnd');

Height = floor(HeightMm / ratio / 2 * P.dR) * 2 / P.dR;
if Height> depthEnd
	HeightMm = depthEnd * ratio;
	Height = floor(HeightMm / ratio);
	UI = Vars.get(SWIGEM5Sc.VarNames.UI);
    ui_idx = SWIGEM5Sc.lut.get('UI','changeROIHeight');
	h = UI(ui_idx);
	
    set(h.handle(2), 'Value', HeightMm);
    set(h.handle(3), 'String', HeightMm);
    UI(ui_idx) = h;
    Vars.update(SWIGEM5Sc.VarNames.UI, UI);
end
SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'ROIHeight', Height)

if ROICenterZ < depthStart +  Height/2
	ROICenterZ = depthStart + Height/2;
	SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterZ', ROICenterZ)
elseif ROICenterZ > depthEnd - Height/2
	ROICenterZ = depthEnd - Height/2;
	SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterZ', ROICenterZ)
end

r1 = ROICenterZ - Height/2;
r2 = ROICenterZ + Height/2;

n = 2;

PData = Vars.get(SWIGEM5Sc.VarNames.PData);


PData(n).Size = [ceil((depthEnd - depthStart)/P.dR) ... % z data size
    ceil(P.fov_rad / P.dTheta) ... % theta size
    1];
PData(n).Region.Shape = SWIGEM5Sc.func.updateDPataRegionShape(PData(n).Region.Shape,r1,r2,[],[]);
PData(n).Region = computeRegions(PData(n));

Vars.update(SWIGEM5Sc.VarNames.PData, PData)

Vars.updateControl('',{ SWIGEM5Sc.VarNames.PData,SWIGEM5Sc.VarNames.PData })

SWIGEM5Sc.ui.updateROIandFocus()

end
