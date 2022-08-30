function [DwWidth,DwHeight, ReferencePt] = calcHeightWidthMainWindowPolar( ...
    mwPDelta, startDepth, endDepth, fov_rad )
	%% Calculate high and width of main window when resizing.

	DwWidth = ceil((endDepth-startDepth)*sin(fov_rad/2)*2/mwPDelta+2);
    DwHeight = ceil((endDepth-startDepth)/mwPDelta+2);
	% 2D imaging is in the X,Z plane
	ReferencePt = [-DwWidth/2*mwPDelta,0  ,0];
end


