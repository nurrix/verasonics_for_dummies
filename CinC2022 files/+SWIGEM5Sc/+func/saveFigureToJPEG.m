function saveFigureToJPEG(fig, figure_info_string, full_path)
%% Save Video to file

if nargin < 3

    P = CustomSWI.Vars.var_get(CustomSWI.Vars.Names.P);

    defname = fullfile('C:\Users\Administrator\Desktop\savefiles' ...
            , sprintf('%s-%s' ...
                , P.filename ... % 
                , erase(sprintf('%s' ...
                            ,datetime('now')... % print this date
                            ) ...
                    ,{':', '.'}) ... % Erase this
                ) ...
            );
    pathfilt = {'*.jpeg'};
    dlg_ttl = sprintf('Save %s as', figure_info_string);


    [fn,pn, ~] = uiputfile(pathfilt, dlg_ttl, defname);




    if isequal(fn,0) 
        % fn will be zero if user hits cancel
        fprintf('User pressed Cancel, so file not saved!')
        return
    end

    % Get full file name
    full_path = strrep(fullfile(pn,fn), '''', '''''');
end
full_path = sprintf('%s-%s', full_path, figure_info_string);
saveas(fig, full_path, 'jpeg')

fprintf('The %s Figure has been saved at %s \n', figure_info_string, full_path);


end

