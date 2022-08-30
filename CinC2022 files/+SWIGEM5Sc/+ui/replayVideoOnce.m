function another_replay_possible = replayVideoOnce(figVelHandle, figPrwHandle, max_FR)
%REPLAYVELOCITYONCE Summary of this function goes here
%   Detailed explanation goes here
    if nargin == 1
        error('forgot to use figP')
    end
    nframes = evalin('base',"size(MovieVelocity, 3)");

    first = SWIGEM5Sc.ui.isThisFirstVideoReplay();
    if first
        VidFramesVelocity(nframes) = struct('cdata', [], 'colormap', []);
        VidFramesPower(nframes) = struct('cdata', [], 'colormap', []);
    end

    another_replay_possible = false;
    for i = 1:nframes

        if ~ishandle(figVelHandle) || ~ishandle(figPrwHandle) || Vars.get('vsExit') || ~Vars.get('freeze') || (~SWIGEM5Sc.ui.is_replay() && nargin == 1)
            return
        end

        my_tic = tic;
        SWIGEM5Sc.ui.updateVelocityFrame(figVelHandle, i)
        SWIGEM5Sc.ui.updatePowerFrame(figPrwHandle, i)
        drawnow
        loopfps = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables, SWIGEM5Sc.VarNames.gui_loopfps);
        pause(1/loopfps-toc(my_tic)-max_FR);
        

        if ~ishandle(figVelHandle) || ~ishandle(figPrwHandle) || Vars.get('vsExit') || ~Vars.get('freeze') || (~SWIGEM5Sc.ui.is_replay() && nargin == 1)
            return
        end
        
        if first
            VidFramesVelocity(i) = SWIGEM5Sc.ui.getFrame(figVelHandle);
            VidFramesPower(i) = SWIGEM5Sc.ui.getFrame(figPrwHandle);
        end
    end

    another_replay_possible = SWIGEM5Sc.ui.is_replay();
    
    if first
        Vars.force_set(SWIGEM5Sc.VarNames.VidFramesVelocity, VidFramesVelocity);
        Vars.force_set(SWIGEM5Sc.VarNames.VidFramesPower, VidFramesPower);
    end
    
end

