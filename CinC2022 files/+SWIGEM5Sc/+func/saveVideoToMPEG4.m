function saveVideoToMPEG4(video_array, video_info_string, fn)
%% Save Video to file
if nargin < 3
    P = Vars.get(SWIGEM5Sc.VarNames.P);
    defname = fullfile('C:\Users\Administrator\Desktop\savefiles' ...
            , sprintf('%s-%s' ...
                , P.filename ... % 
                , erase(sprintf('%s' ...
                            ,datetime('now')... % print this date
                            ) ...
                    ,{':', '.'}) ... % Erase this
                ) ...
            );
    pathfilt = {'*.mp4'};
    dlg_ttl = sprintf('Save %s as', video_info_string);


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
end
fn = sprintf('%s-%s', fn, video_info_string);
loopfps = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables,SWIGEM5Sc.VarNames.gui_loopfps);
vidObj = VideoWriter(fn,'MPEG-4');
vidObj.Quality = 100;
vidObj.FrameRate = loopfps;
open(vidObj);
writeVideo(vidObj, video_array);
close(vidObj);

fprintf('The %s has been saved at %s \n', video_info_string, fn);


end

