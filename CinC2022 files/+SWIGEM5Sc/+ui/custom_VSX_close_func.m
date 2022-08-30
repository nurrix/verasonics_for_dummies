function custom_VSX_close_func(source,~,hvTimer)
assignin('base', 'vsExit', 1);

% VTS-1306 If hvTimer has been initialized as a timer (script using TPC
% Profile 5), it will be an object with class name timer so the
% lines below will stop and delete it.  For all other scripts,
% "hvTimer" will have been created as a placeholder graphics object
% with no properties so the expression "isa(hvTimer, 'timer')" will
% evaluate to false and the stop, delete commands will be skipped.
if isa(hvTimer, 'timer')
	stop(hvTimer);
	delete(hvTimer);
end
if ishandle(source)
	delete(source);
end
hFigures = findobj('Type','figure'); % find all open figures

if isempty(hFigures)
	return
end

for i = 1:length(hFigures)
	if ~ishandle(hFigures(i))
		continue
	end
	try
		close(hFigures(i));
	catch
	end
end

end