function Process = initializeProcessExt(method, srcbuffer,srcbufnum, srcframenum, dstbuffer)
%% Initialize external process
Process.classname = 'External';
Process.method = method;
Process.Parameters = {'srcbuffer',srcbuffer,... % name of buffer to process.
    'srcbufnum',srcbufnum,...
    'srcframenum',srcframenum,...
    'dstbuffer',dstbuffer};

end

