function Process = initializeProcessExtUIControlCallback(method)
%% Initialize the external process for initializing the UI settings
% This must be done at runtime, which is why we do this here.
Process.classname = 'External';
Process.method = method;
Process.Parameters = {'srcbuffer', 'none'};
end

