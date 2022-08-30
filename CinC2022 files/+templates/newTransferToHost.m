function [Event,SeqControl] = newTransferToHost(sName, SeqCommands, Event, SeqControl )
%% Generate new transfer to host
SeqControl(end+1) = templates.seqControl('transferToHost', [], []);
Event(end+1) = templates.Event( sName, 0, 0, 0, 0, [length(SeqControl), SeqCommands]);
end

