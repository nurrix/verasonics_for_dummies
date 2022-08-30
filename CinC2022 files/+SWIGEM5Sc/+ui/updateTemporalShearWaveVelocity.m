function updateTemporalShearWaveVelocity(shearwavetime, swi_spatial_width, swi_temporal_duration)
%% pltTemporalShearWaveVelocity
% warning('fixme')
persistent myImHandle ax

velmax = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables,SWIGEM5Sc.VarNames.gui_velocity_max);

if swi_spatial_width>0
else
    swi_spatial_width = 20;
end


if swi_spatial_width>0
    YLIMS = [0, swi_spatial_width];
else
    YLIMS = [0.5, 1.5];
end


if Vars.get(SWIGEM5Sc.VarNames.vsExit)
    return
end

if isempty(myImHandle) || ~ishandle(myImHandle) && ishandle(Vars.handles.get_primary_figure_handle)
    Resource = Vars.get(SWIGEM5Sc.VarNames.Resource);
	
	mainWinPos = Resource.DisplayWindow(1).Position;
    ttl = 'Temporal Shear Wave Velocity';
    pos = [mainWinPos(1) + 2.4 * mainWinPos(3) ...
            , mainWinPos(2) + mainWinPos(4) ... % bottom
            , mainWinPos(3)...
			, mainWinPos(4)];
    
    fig = figure('Name', ttl, ...
        'Position', pos, ...
        'CloseRequestFcn', @SWIGEM5Sc.ui.close_helper_figure);
    
    
    ax = gca(fig);
    hold(ax,'on')
    XX = linspace(0, swi_temporal_duration, size(shearwavetime,2));
    YY = linspace(0, swi_spatial_width,     size(shearwavetime,1));
    myImHandle = imagesc(ax, XX, YY, shearwavetime);
    hold(ax,'off')
    title(ax, ttl)
    xlim(ax, [0, XX(end)])
    xlabel(ax, 'Time [ms]')
    ylabel(ax, 'Location [mm]')
    caxis(ax,[-velmax, velmax])
    colormap(ax,SWIGEM5Sc.ui.fireice)
    Vars.handles.set_handle_base(SWIGEM5Sc.VarNames.figTemporalSWIHandle, fig)
end



set(myImHandle, 'CData', shearwavetime)
ylim(ax, YLIMS)
caxis(ax, [-velmax, velmax])

if all(myImHandle.YData([1,end]) == YLIMS )
    return
end

YY = linspace(0, swi_spatial_width, swi_spatial_width);
myImHandle.YData = YY;
ax.YLim = YLIMS;

end

