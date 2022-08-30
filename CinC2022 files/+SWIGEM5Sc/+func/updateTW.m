function updateTW(finalMsg)
%% Update the Transmit waveform.

TX = Vars.get('TX');
TW = Vars.get('TW');
numPushCycles = SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'numPushCycles');

assert(length(TX)>1, 'TX MUST BE LARGER THAN 1, as a push system must be implemented')
assert(length(TW)>1, 'TW MUST BE LARGER THAN 1, as a push system must be implemented')

% Location.newX won't be assigned if new focus is not determined
TW(2).Parameters(3) = numPushCycles * 2; % number of cycles * 2!!!
[~,~,~,~,TW(2)] = computeTWWaveform(TW(2));
TX(2).Bdur = TW(2).Bdur;

Vars.update('TW',TW)
Vars.update('TX', TX)

fprintf('%s\n', finalMsg);


Vars.updateControl('',{'TW', 'TX'})


end