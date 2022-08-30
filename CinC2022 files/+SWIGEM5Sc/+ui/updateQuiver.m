function updateQuiver()
%% Update Quiver handle

% if ~CustomSWI.Vars.var_get(CustomSWI.Vars.Names.flagUpdateArrows)
% 	return
% end
ratio = Vars.ratioFromWls();
[X_wls,Y_wls] = SWIGEM5Sc.func.getPosAlongLine();

X = X_wls * ratio;
Y = Y_wls * ratio;
handle_line_names = {SWIGEM5Sc.VarNames.handleQuiverPrim, SWIGEM5Sc.VarNames.handleQuiverPwr, SWIGEM5Sc.VarNames.handleQuiverVel};

Figures(1) = Vars.handles.get_primary_figure_handle();
Figures(2) = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figVelHandle);
Figures(3) = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figPowerHandle);

for i = 1:length(Figures)
    
    if ~ishandle(Figures(i))
        continue
    end
    line_name = handle_line_names{i};
    handle_line = Vars.handles.get_handle_base(line_name);
    if ~ishandle(handle_line)
        handle_line = set_q(Figures(i), X, Y);
        Vars.handles.set_handle_base(line_name, handle_line)
        continue
    end
    update_q(handle_line, X, Y)
end


    function h = set_q(f, X, Y)
        ax = gca(f);
        hold(ax, 'on')
		h = quiver(ax , X(1), Y(1), diff(X), diff(Y), 'AutoScale',0, 'LineWidth', 2, 'HitTest','off');
        h.MaxHeadSize = 0.3;
        h.MarkerSize = 10;
		hold(ax, 'off')
    end

    function update_q(h,X,Y)
		set(h, 'XData', X(1), 'YData', Y(1),'UData', diff(X), 'VData', diff(Y) )
        
    end
end

