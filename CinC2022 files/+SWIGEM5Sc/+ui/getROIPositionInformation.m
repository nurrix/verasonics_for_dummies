function roi = getROIPositionInformation()
%% Calculate the roi information from dt_SWIInfo
% returns roi,
%  - Struct containing: center, perimiter of ROI

% ratio = Vars.ratioFromWls();
w = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'ROIWidth');
h = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'ROIHeight');
cw = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,	'ROICenterX');
ch = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,	'ROICenterZ');
t = ch - h/2;
l = cw - w/2;

LEN = 15;

% Center of ROI
[roi.center(2), roi.center(1)] = pol2cart(cw, ch);

% Perimeter of ROI
[roi.perimiter(:,2),roi.perimiter(:,1)] ...
	= pol2cart([linspace(l,l+w,LEN),  linspace(l+w,l,LEN), l]', ...
	[linspace(t,t,LEN), linspace(t+h,t+h,LEN), t]');

end

