
function saveIQ_Callback(varargin)

    freeze = Vars.get(CustomSWI.VarNames.freeze);
    velocityFigHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figVelHandle);
    if  ~ishandle(velocityFigHandle)% || ~ishandle(SWIfigHandle)
        disp('You must have SWIon!')
        return
    end
    if ~freeze
        msgbox('Freeze Acquisition first!');
        return
    end


    
    if evalin('base','~exist(SWIGEM5Sc.VarNames.VidFramesVelocity,''var'')')
        msgbox('replay is not finished! generating video. This will take a little bit of time.');
        SWIGEM5Sc.ui.updateFullVidFramesVelocity()
    end



    P = CustomSWI.Vars.get(CustomSWI.VarNames.P);
    defname = fullfile('C:\Users\Administrator\Desktop\savefiles' ...
            , sprintf('%s-%s' ...
                ,P.filename ... % 
                , erase(sprintf('%s' ...
                            ,datetime('now')... % print this date
                            ) ...
                    ,{':', '.'}) ... % Erase this
                ) ...
            );
    pathfilt = {'*.mp4'};
    dlg_ttl = sprintf('Save %s as', 'figure and images');


    [fn,pn, ~] = uiputfile(...
         pathfilt, dlg_ttl...
        , defname);


    if isequal(fn,0) 
        % fn will be zero if user hits cancel
        fprintf('User pressed Cancel, so file not saved!')
        return
    end

    % Get full file name
    fn = strrep(fullfile(pn,fn), '''', '''''');
    [flr, fname, ~] = fileparts(fn);
    fn = fullfile(flr,fname);
    % CustomSWI.Func.saveVideoToMPEG4(CustomSWI.Vars.get(CustomSWI.Vars.Names.IQPowerMovie), 'Shearwave Power Movie')
    CustomSWI.func.saveVideoToMPEG4(Vars.get(SWIGEM5Sc.VarNames.VidFramesVelocity), 'Shearwave Velocity Movie', fn)
    CustomSWI.func.saveFigureToJPEG(Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figTemporalSWIHandle), 'Shearwave Propagation Image', fn)
    CustomSWI.func.saveFigureToJPEG(Vars.handles.get_primary_figure_handle, 'BMode Image', fn)

end
