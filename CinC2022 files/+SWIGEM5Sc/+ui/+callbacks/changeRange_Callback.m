
function changeRange_Callback(hObject,~,UIValue)
%% No range change if in simulate mode 2.
P = Vars.get(SWIGEM5Sc.VarNames.P);
PData = Vars.get(SWIGEM5Sc.VarNames.PData);
Resource = Vars.get(SWIGEM5Sc.VarNames.Resource);
Trans = Vars.get(SWIGEM5Sc.VarNames.Trans);
Receive = Vars.get(SWIGEM5Sc.VarNames.Receive);
TGC = Vars.get(SWIGEM5Sc.VarNames.TGC);
%Range change
simMode = Resource.Parameters.simulateMode;


if simMode == 2
    set(hObject, 'Value', P.endDepth);
    return
end

ratio = Vars.ratioFromWls();
mwPDelta = Resource.DisplayWindow(1).pdelta;

% Update P
depthEnd = UIValue / ratio;
depthEndMm = depthEnd * ratio;

SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.Variables,'depthEnd', depthEnd)
SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.Variables,'depthEndMm', depthEndMm)

depthStart = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables,'depthStart');

% Update PData
switch P.Coord
    case 'polar'
        
		
        PData(1).Size = [ceil((depthEnd - depthStart + 1)/P.dR) ... % z data size
            ceil(P.fov_rad / P.dTheta) ... % theta size
            1];
		PData(1).Region.Shape = SWIGEM5Sc.func.updateDPataRegionShape(PData(1).Region.Shape, ...
			depthStart, depthEnd, [],[]);
        
        
    case 'rectangular'
        PData(1).Size = [  ceil((depthEnd - depthStart) / P.dR) ... % depthStart, depthEnd and pdelta set PData(1).Size.
            , ceil((P.numelements * Trans.spacing) / P.dTheta) ...
            , 1];      % single image page
    otherwise
        error('P.Coord=%Qs, NOT DEFINED', P.Coord)
end


PData(1).Region = computeRegions(PData(1));
% PData(2).Region = computeRegions(PData(2));

[DwWidth, DwHeight, ReferencePt] = SWIGEM5Sc.func.calcHeightWidthMainWindowPolar(...
	mwPDelta, depthStart, depthEnd, P.fov_rad );
Resource.DisplayWindow.ReferencePt = ReferencePt;

% Update Resource
Resource.DisplayWindow(1).Position(3:4) = [DwWidth, DwHeight];


% Update Receive
a = depthEnd;
b = P.apature;
C = P.fov_rad/2;
maxSingleTrip_wls =  ceil(sqrt(a^2 + b^2 - 2*a*b*cos(C + pi/2)));

for i = 1:length(Receive)
    Receive(i).depthEnd = maxSingleTrip_wls;
end

% Update TGC
TGC.rangeMax = depthEnd;
TGC.Waveform = computeTGCWaveform(TGC);


Vars.update(SWIGEM5Sc.VarNames.PData, PData);
Vars.update(SWIGEM5Sc.VarNames.Resource, Resource)
Vars.update(SWIGEM5Sc.VarNames.Receive, Receive)
Vars.update(SWIGEM5Sc.VarNames.TGC, TGC)



Parameters = {'PData','InterBuffer','ImageBuffer','DisplayWindow','Receive','TGC','Recon'};
Vars.updateControl('',Parameters)
Vars.force_set('action', 'displayChange')

UI = Vars.get(SWIGEM5Sc.VarNames.UI);
h = UI(SWIGEM5Sc.lut.get('UI','changeROIHeight'));
HeightMm = get(h.handle(2),'Value');
SWIGEM5Sc.ui.callbacks.changeROIHeigth_Callback(-1,-1,HeightMm)

SWIGEM5Sc.ui.setFirstVideoReplay()

end