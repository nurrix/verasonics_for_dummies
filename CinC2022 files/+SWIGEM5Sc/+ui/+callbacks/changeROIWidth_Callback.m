function changeROIWidth_Callback(~,~,UIValue)
%% ROI Width change

PData = Vars.get(SWIGEM5Sc.VarNames.PData);
P = Vars.get(SWIGEM5Sc.VarNames.P);
% SWIROI = Vars.get(SWIGEM5Sc.VarNames.SWIROI);
% primROIHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.primROIHandle);


% ratio = SWIGEM5Sc.Func.ratioFromWls();


Width = floor(deg2rad(UIValue)/2/P.dTheta)*2*P.dTheta;

ROICenterX = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterX');

if ROICenterX + Width/2 > P.fov_rad/2
	ROICenterX = (P.fov_rad - Width) / 2;
	SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterX', ROICenterX);
elseif ROICenterX - Width/2 < -P.fov_rad/2
	ROICenterX = (-P.fov_rad + Width) / 2;
	SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterX', ROICenterX);
	
end

SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'ROIWidth', Width)


% SWIROI.width = Width;
PData(2).Region(1).Shape.angle = Width;
PData(2).Region(1).Shape.steer = ROICenterX;
PData(2).Region(1) = computeRegions(PData(2));

% Vars.update(SWIGEM5Sc.VarNames.ROIpos, ROIpos_wls)
% Vars.update(SWIGEM5Sc.VarNames.SWIROI, SWIROI)
Vars.update(SWIGEM5Sc.VarNames.PData, PData)


Vars.updateControl('',{SWIGEM5Sc.VarNames.PData,SWIGEM5Sc.VarNames.Recon})
% Vars.force_set('action', 'displayChange')

SWIGEM5Sc.ui.updateROIandFocus()
end