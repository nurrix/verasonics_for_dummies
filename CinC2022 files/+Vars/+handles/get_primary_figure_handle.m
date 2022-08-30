function bmodeFigHandle = get_primary_figure_handle()
%% Get graphical object of the main figure
bmodeFigHandle = evalin('base','Resource.DisplayWindow(1).figureHandle');
end

