function saveRawSWIData_Callback(~)
freeze = evalin('base','freeze');
% figClose = evalin('base','figClose');

if ~freeze
    disp('Replay only works if we freeze button!')
    return
end


%     SWIfigHandle = CustomSWI.Vars.handles.get_handle_base(CustomSWI.VarNames.SWIfigHandle);
figVelHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figVelHandle);
if  ~ishandle(figVelHandle)% || ~ishandle(SWIfigHandle)
    disp('You must have SWIon!')
    return
end
clear freeze
% assignin('base','replay',1);

% need copyBuffers to access IQData
% Control.Command = 'copyBuffers';
% 
% runAcq(Control); % NOTE:  If runAcq() has an error, it reports it then exits MATLAB.

% Custom Naming>
cn = '_A-H__mm-W__mm-P30V-_';


P = evalin('base','P');

%% Save the 4 datasets in file1
defname = fullfile('C:\Users\Administrator\Desktop\savefiles' ...
		, sprintf('CinC2022-%s-%s' ...
			,P.filename ... % 
			, erase(sprintf('%s' ...
                        ...
						, cn ...,datetime('now')... % print this date
						) ...
				,{':', '.'}) ... % Erase this
			) ...
		);
pathfilt = {'*.jpg'};

ttl = 'Save Temporal Shear Wave Data';

[file,pth] = uiputfile(...
	 pathfilt, ttl...
	, defname);

if ~ischar(file)
    return
end

[~,name_wo_ext,~]=fileparts(file);
% fullpath = fullfile(pth,file);
fp_noext = fullfile(pth,name_wo_ext);


    if evalin('base','~exist(SWIGEM5Sc.VarNames.VidFramesVelocity,''var'')')
        msgbox('replay is not finished! generating video. This will take a bit of time.');
        SWIGEM5Sc.ui.updateFullVidFramesVelocity()
    end


vidVel = Vars.get(SWIGEM5Sc.VarNames.VidFramesVelocity);
vidPwr = Vars.get(SWIGEM5Sc.VarNames.VidFramesPower);
SWIGEM5Sc.func.saveVideoToMPEG4(vidVel, 'Shearwave Velocity Movie', fp_noext)
SWIGEM5Sc.func.saveVideoToMPEG4(vidPwr, 'Shearwave Power Movie', fp_noext)
SWIGEM5Sc.func.saveFigureToJPEG(Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.figTemporalSWIHandle), 'Shearwave Propagation Image', fp_noext)
SWIGEM5Sc.func.saveFigureToJPEG(Vars.handles.get_primary_figure_handle, 'BMode Image', fp_noext)



end

