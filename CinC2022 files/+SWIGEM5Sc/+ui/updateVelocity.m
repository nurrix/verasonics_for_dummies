function updateVelocity()
% warning('Fixme')
% The original plotting function for the shear waves
%         return
persistent pltDot pltROI ax

with_arfi = SWIGEM5Sc.ui.with_arfi();

MovieVelocity = Vars.get(SWIGEM5Sc.VarNames.MovieVelocity);
Resource = Vars.get(SWIGEM5Sc.VarNames.Resource);
P = Vars.get(SWIGEM5Sc.VarNames.P);

ratio = Vars.ratioFromWls();

if Vars.get(SWIGEM5Sc.VarNames.vsExit)
    return
end
imHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.imgVelHandle);

buffer =  MovieVelocity(:,:,1);


roi_theta = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterX');
roi_rho_wls = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterZ');
roi_height_wls = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROIHeight');
roi_width = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROIWidth');

[y_pltdot, x_pltdot] = pol2cart([0, SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'focusX')] ...
    , [0, SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'focusZ')*ratio]);

Angles = [abs(roi_theta)+ roi_width/2, 0];
Depths = [cos(abs(roi_theta)+roi_width/2)* (roi_rho_wls - roi_height_wls/2), roi_rho_wls + roi_height_wls/2] * ratio;

[YLIM, ~] = pol2cart(Angles, Depths);
XLIM = sin([roi_theta-roi_width/2 ...
    , roi_theta+roi_width/2])*( roi_rho_wls + roi_height_wls/2) * ratio;

[ax, pltDot, pltROI, imHandle] = Init(imHandle, XLIM, YLIM, Resource, P, buffer, pltDot, pltROI, ax);



% The size of IQData here is [nRows, nCols, nFrames, nPages]

% This does not work, we need to only plot it once!
for t = 1%:nTime % for all combinations of 2 pages
    
    [cartXLim, cartYLim, buffer] = SWIGEM5Sc.func.scanConversion(MovieVelocity(:,:,t));
    if ~ishandle(imHandle)
        return
    end
    set(imHandle,'CData',buffer)
    
end
set(imHandle, 'XData', cartXLim , 'YData', cartYLim)

if with_arfi
    set(pltDot, 'XData', x_pltdot, 'YData', y_pltdot)
else
    set(pltDot, 'XData', nan, 'YData', nan)
    
end

primROI = Vars.handles.get_handle_base( SWIGEM5Sc.VarNames.primROIHandle);

if ishandle(primROI) && ishandle(pltROI)
    set(pltROI, 'XData', primROI.XData, 'YData', primROI.YData)
    xlim(ax, cartXLim)
    ylim(ax, cartYLim)
    
    
end


    function [ax, pltDot, pltROI, imHandle] = Init( imHandle, XLIM, YLIM, Resource, P, buffer, pltDot, pltROI,ax)
        %% Initialize
        
        if ishandle(imHandle) || ~ishandle(Vars.handles.get_primary_figure_handle)
            return
        end
        
        TTL = sprintf('Velocity Visualization with %s',P.transName);
        
        
        mainWinPos = Resource.DisplayWindow(1).Position;
        pos = ceil([mainWinPos(1) + 1.2 * mainWinPos(3) ...
            , mainWinPos(2) + mainWinPos(4) ... % bottom
            , mainWinPos(4) * diff(XLIM)/diff(YLIM)...
			, mainWinPos(4)]);
		        
        fig = figure('Name', TTL, 'Position', pos, ...
            'CloseRequestFcn', @SWIGEM5Sc.ui.close_helper_figure);            % width, height
        
        ax = axes(fig);
        imHandle = imagesc(ax, XLIM, YLIM, buffer);
        hold(ax,'on')
        pltROI = plot(ax, nan, nan, 'w', 'Linewidth', 2, 'LineStyle', '--');
        pltDot = plot(ax, nan, nan, 'r', 'Linewidth', 0.5, 'LineStyle', '--');
        hold(ax,'off')
        title(ax, TTL,'FontSize', 14, 'Fontweight', 'bold');
        xlabel(ax, sprintf('Azimuth [%s]', P.units), 'FontSize', 12, 'Fontweight', 'bold');
        ylabel(ax, sprintf('Depth [%s]', P.units), 'FontSize', 12, 'Fontweight', 'bold');
        set(ax, 'FontSize', 12, 'Fontweight', 'bold');
        axis(ax, 'tight', 'equal'),
        colormap(ax, SWIGEM5Sc.ui.fireice)
        
        Vars.handles.set_handle_base(SWIGEM5Sc.VarNames.figVelHandle, fig)
        Vars.handles.set_handle_base(SWIGEM5Sc.VarNames.imgVelHandle, imHandle)
        
        plt_velocity_max = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables, 'gui_velocity_max');
        SWIGEM5Sc.ui.callbacks.changeMaxVelocity_Callback(-1, -1, plt_velocity_max);
        SWIGEM5Sc.ui.updateQuiver()
        
    end
end