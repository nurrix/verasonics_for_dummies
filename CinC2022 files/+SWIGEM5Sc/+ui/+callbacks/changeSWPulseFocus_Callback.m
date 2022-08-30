
function changeSWPulseFocus_Callback(~, ~)
%% Update Shear Wave Pules Focus

freeze = Vars.get(SWIGEM5Sc.VarNames.freeze);
vsExit = Vars.get(SWIGEM5Sc.VarNames.vsExit);
if freeze == 1 || vsExit == 1  % no response if freeze or exit
	return
end


P = Vars.get(SWIGEM5Sc.VarNames.P);
ratio = Vars.ratioFromWls();

bmodeFigHandle = Vars.handles.get_primary_figure_handle();

% Get new location information
bmodeAxes = gca(bmodeFigHandle);
currentPos = get(bmodeAxes,'CurrentPoint');

depthEnd = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables,'depthEnd');
switch get(bmodeFigHandle, 'SelectionType')
	case 'normal' % Left click
		x0 = currentPos(1);
		z0 = currentPos(3);
		
		[theta, r] = cart2pol(z0,x0);
		r=r/ratio;
		if r > depthEnd-1
			r = depthEnd-1;
		elseif r < 1
			r = 1;
		end
		
		if abs(theta) > P.fov_rad/2 - P.dTheta*5
			theta = sign(theta) * P.fov_rad/2 - P.dTheta*5;
		end
		
		SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo,'focusX',theta)
		SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo,'focusZ',r)
		
		
	case 'alt' % right click
		theta = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'focusX');
		r = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'focusZ')*ratio;
		x1 = currentPos(1);
		z1 = currentPos(3);
		[z0,x0] = pol2cart(theta,r);
		arrowInfo.slope = (z1 - z0) / (x1 - x0); % Note that WLS or mm doesnt matter here, as it is a 1x1 ratio.
		arrowInfo.l2r = x1 >= x0;
		SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo,'arrowInfo',arrowInfo)
		
end
% Update focus
SWIGEM5Sc.func.focusCorrection();

theta = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'focusX');
z0 = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'focusZ')*ratio;

[y,x0] = pol2cart(theta,z0);

% Get the updated Location variable
msg = sprintf('Move focus to (%3.2f,%3.2f) [%s]....',x0, y, P.units);

if SWIGEM5Sc.ui.with_arfi()
	SWIGEM5Sc.func.updateTX(msg);
end
% Update Quiver
SWIGEM5Sc.ui.updateROIandFocus()
% SWIGEM5Sc.ui.updateVelocity()

end
