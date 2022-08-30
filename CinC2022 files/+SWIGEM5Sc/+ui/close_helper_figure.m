function close_helper_figure(fig, ~)

% IWORX.CLOSE_DEVICE(CustomSWI.Vars.var_get('sIWORXDAQ'))

    if ~evalin('base','exist("vsExit","var")') || evalin('base','vsExit')
        try 
            delete(fig)
        catch e
            disp(e.message)
        end
    else
        SWIGEM5Sc.ui.setModeFlash(0, 0);
    end

end