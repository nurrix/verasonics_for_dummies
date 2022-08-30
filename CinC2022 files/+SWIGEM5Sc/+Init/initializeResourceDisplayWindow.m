function DisplayWindow = initializeResourceDisplayWindow(mwPDelta, ttl, numFrames, units ...
	, startDepth, endDepth, fov_rad)
%% Initialize Resources for Display Window
DisplayWindow.Title = ttl;
DisplayWindow.pdelta = mwPDelta;

ScrnSize = get(0,'ScreenSize');

[DwWidth,DwHeight, ReferencePt] = SWIGEM5Sc.func.calcHeightWidthMainWindowPolar( ...
	mwPDelta, startDepth, endDepth, fov_rad );
DisplayWindow.ReferencePt = ReferencePt;

DisplayWindow.Position = [250,(ScrnSize(4)-(DwHeight+150))/2, ...
    DwWidth, DwHeight];  % lower left corner position
DisplayWindow.Colormap = gray(256);
DisplayWindow.numFrames = numFrames;
DisplayWindow.Type = 'Matlab';
DisplayWindow.AxesUnits = units;
end

