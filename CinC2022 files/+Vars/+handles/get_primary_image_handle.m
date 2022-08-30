function bmodeFigHandle = get_primary_image_handle()
%% Get graphical object of the main image
bmodeFigHandle = evalin('base','Resource.DisplayWindow(1).imageHandle');
end

