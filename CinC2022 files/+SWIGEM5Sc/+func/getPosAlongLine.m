function [x_wls,z_wls] = getPosAlongLine()
	%% Get spatial corrdinates for temporal SWI line.

	% Find slope and direction
	ratio = Vars.ratioFromWls();
	arrowInfo = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'arrowInfo');
	slope = arrowInfo.slope;
	l2r = arrowInfo.l2r;
	if isinf(slope)
		slope = sign(slope) * 1e9;
	end
	[z0_wls, x0_wls] = pol2cart(SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'focusX'), SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'focusZ'));
    
    % y = a*x + b >> b = y - a * x
    b = z0_wls - slope * x0_wls;
    
    xx_wls =[-1000, 1000]; % some large initial values
    zz_wls = b + slope * xx_wls;
    
    hROI = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.primROIHandle);
    
    if ~ishandle(Vars.handles.get_primary_figure_handle)
        
        x_wls = nan(1,2);
        z_wls = nan(1,2);
        return
    end
    % generate a poly of the ROI boundaries
    poly1 = polyshape([hROI.XData/ratio; hROI.YData/ratio]', 'SolidBoundaryOrientation','cw', 'Simplify', false);
    % fild where our line intersect the boundaries
    [in,~] = intersect(poly1,[xx_wls',zz_wls']);
    if isempty(in)
        % If line does not intersect ROI, just return nan(1,2) for both x and y.
        x_wls = nan(1,2);
        z_wls = nan(1,2);
    else

        x_wls = in(1:2,1)';
        z_wls = in(1:2,2)';

        % Arrange arrow correctly.
		if l2r
			[x_wls,I] = sort(x_wls);
			
		else
			[x_wls,I] = sort(x_wls, 'descend');
			
		end
		
		z_wls = z_wls(I);
    end
    


end

