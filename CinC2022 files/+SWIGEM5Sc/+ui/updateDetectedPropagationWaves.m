function updateDetectedPropagationWaves( Time, Loc, swi_temporal_duration, swi_spatial_width)
%% Plot detected propagation waves.
% warning('fixme')

figTemporalSWIHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figTemporalSWIHandle);
hList = Vars.handles.get_handle_base('hList');
tList = Vars.handles.get_handle_base('tList');

if ~ishandle(figTemporalSWIHandle)
    return
end

YLIMS = [0,swi_spatial_width];
ax = gca(figTemporalSWIHandle);

len = 2;
for i = 1:len
    if i > length(Time)
        Time{i} = [nan,nan];
        Loc{i} = [nan,nan];
    end
end

if ~all(ishandle(hList))
    delete(hList)
    delete(tList)
    evalin('base', 'clear hList tList')
    msg = '';
    X = [nan,nan];
    Y = [nan,nan];
    hold(ax,'on')
    for i = 1:len
        hList(i) = plot(ax,X,Y,'w','LineWidth',3);
        tList(i) = text(ax,nan,nan, msg, 'Color','w');
        
    end
    hold(ax,'off')
    Vars.handles.set_handle_base('hList', hList);
    Vars.handles.set_handle_base('tList', tList);
    
end


tenpy = 0.1 * swi_spatial_width;
for i = 1:len
    
    [~, idx] = max(Time{i});
    X = Time{i};
    Y = Loc{i};
    
    if ~ishandle(hList(i))
        return
    end
    msg = sprintf('v = %4.2f m/s', abs((Loc{i}(2)-Loc{i}(1))/(Time{i}(2)-Time{i}(1))));
    
    set(hList(i), 'XData',X, 'YData',Y)
    x = min([swi_temporal_duration-1, X(idx)]);
    y = max(YLIMS(1) + tenpy, min(swi_spatial_width, Y(idx) - tenpy));
    set(tList(i),'Position', [x, y, 0], 'String', msg)
end
end

