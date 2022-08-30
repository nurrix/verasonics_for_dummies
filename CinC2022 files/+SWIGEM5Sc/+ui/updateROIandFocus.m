function updateROIandFocus()
% Plot ROI and focus point on primary figure
assert(nargout == 0, sprintf('No output variables defined. However, attempted nargout=%u ', nargout))

if Vars.get(SWIGEM5Sc.VarNames.vsExit)
    return
end
% We then set the flag to be ignored, if called again!
P = Vars.get('P');
numPushElements = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,	'numPushElements');
transElmSpacing = P.transElmSpacing;
pushStartElmPos = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'pushStartElmPos');
ratio = Vars.ratioFromWls();

theta = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,	'focusX');
r = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,	'focusZ');
[focusZ_wls, focusX_wls] = pol2cart(theta, r);

elmPos = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ElementsPos') * ratio;
rectHeight = 2;
elmEdgePos = elmPos([1,end]);
roi = SWIGEM5Sc.ui.getROIPositionInformation();
transPos = [elmEdgePos(1), -rectHeight, diff(elmEdgePos),rectHeight];
transPushElmPos = [pushStartElmPos * ratio...
    , -rectHeight...
    , numPushElements*transElmSpacing * ratio...
    , rectHeight];
pos_center_trans_wls = pushStartElmPos + numPushElements/2*transElmSpacing;


% ROIpos = ratio * ROIpos_wls;
focus_x = ratio * focusX_wls;
focus_z = ratio * focusZ_wls;
transPushCenter = pos_center_trans_wls * ratio;
% Initialize if neccessary

Init(roi, transPos, transPushElmPos);

Draw(focus_x, focus_z, transPushCenter, transPushElmPos, roi)

SWIGEM5Sc.ui.setFirstVideoReplay()
% drawnow;

    function Draw(focus_x, focus_z, transPushCenter, transPushElmPos, roi)
        %% Draw the rectangle if w ehave a change!
        ROIHandle_name = SWIGEM5Sc.VarNames.primROIHandle();
        ROICenterHandle_name = SWIGEM5Sc.VarNames.primROICenterHandle()	;
        TransHandle_name = SWIGEM5Sc.VarNames.primTransHandle();
        markHandle_name = SWIGEM5Sc.VarNames.primMarkHandle();
        
        ROIHandle = Vars.handles.get_handle_base(ROIHandle_name);
        ROICenterHandle = Vars.handles.get_handle_base(ROICenterHandle_name);
        TransHandle = Vars.handles.get_handle_base(TransHandle_name);
        markHandle = Vars.handles.get_handle_base(markHandle_name);
        drawRegionOutline(ROIHandle,1,2,1);
        
        
        
        if SWIGEM5Sc.ui.with_arfi()
            set(markHandle,'XData',[transPushCenter,focus_x],'YData',[0, focus_z]);
            set(TransHandle,'Position', transPushElmPos);
        else
            markHandle.Visible = 'off';
            TransHandle.Visible = 'off';
        end
        set(ROICenterHandle,'Position',roi.center* ratio);
        SWIGEM5Sc.ui.updateQuiver()
        
        
    end

    function Init(roi, transPos, transPushPos)
        % Grab main figure handle
        bmodeFigHandle = Vars.handles.get_primary_figure_handle;
        if ~ishandle(bmodeFigHandle)
            % if figure handle is not valid, we just return
            return
        end
        
        ROICenterHandle_name = SWIGEM5Sc.VarNames.primROICenterHandle();
        TransHandle_name = SWIGEM5Sc.VarNames.primTransHandle();
        markHandle_name = SWIGEM5Sc.VarNames.primMarkHandle();
        ROIHandle_name = SWIGEM5Sc.VarNames.primROIHandle();
        ROICenterHandle = Vars.handles.get_handle_base(ROICenterHandle_name);
        
        if  ishandle(ROICenterHandle)
            return
        end
        UI = Vars.get(SWIGEM5Sc.VarNames.UI);
        selected_focus = UI(SWIGEM5Sc.lut.get('UI', 'chooseSWIMoveFocusOrMoveROI')).handle(2).Value;
        if selected_focus
            current_interaction = 'none';
        else
            current_interaction = 'translate';
        end
        
        ax = gca(bmodeFigHandle);
        hold(ax,'on')
        % Plot locations of all elements

        with_arfi = SWIGEM5Sc.ui.with_arfi();
        
        rectangle(ax, 'Position',    transPos ... % Position will be updated later
            ,'EdgeColor', 'y', 'FaceColor', 'm','HitTest','off');
        
        ROICenterHandle = drawpoint(ax, 'Position',roi.center*ratio ...
            , 'InteractionsAllowed',current_interaction, ...
            'Deletable', false, 'Color', 'm');
        ROICenterHandle.addlistener('ROIMoved', @SWIGEM5Sc.ui.callbacks.changeROI_Callback);
        
        
        
        recTrans  = rectangle(ax, 'Position',    transPushPos ... % Position will be updated later
            ,'EdgeColor', 'r', 'FaceColor', 'r', 'Visible', with_arfi,'HitTest','off');
        markHandle = plot(ax, nan, nan, 'r', 'MarkerFaceColor', 'r', 'Marker','*', 'MarkerSize', 12, 'Linewidth', 0.5, 'LineStyle', '--','HitTest','off');
        
        roiOutlineHandle = drawRegionOutline(1,2,1);
        set(roiOutlineHandle,'HitTest','off')
        
        % Set handles in 'base' workspace. So we can find them again.
        Vars.handles.set_handle_base(TransHandle_name, recTrans)
        Vars.handles.set_handle_base(ROICenterHandle_name, ROICenterHandle)
        Vars.handles.set_handle_base(markHandle_name, markHandle)
        Vars.handles.set_handle_base(ROIHandle_name, roiOutlineHandle)
        
        
        
        valueMoveFocusOrROI = UI(SWIGEM5Sc.lut.get('UI', 'chooseSWIMoveFocusOrMoveROI')).handle(2).Value;
        SWIGEM5Sc.ui.callbacks.chooseSWIMoveFocusOrMoveROI_Callback(-1,-1, valueMoveFocusOrROI)
    end


end

