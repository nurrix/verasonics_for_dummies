function TGC = initializeTGC(endDepth)
%% INITIALIZE Transmit Gain Control
Trans = Vars.get('Trans'); %#ok<NASGU> % This call is useed for computTGCWaveform(*)
TGC.CntrlPts = round(linspace(150,910, 8));
TGC.rangeMax = endDepth;
TGC.Waveform = computeTGCWaveform(TGC);
end

