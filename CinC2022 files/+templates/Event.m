function event = Event(information, tx, rcv, recon, process, seqControl)
%% Returns an EVENT using an Event template
% 
%   event [struct] = Event(information [str], tx [double], rcv [double], recon [double], process [double], seqControl [double])
%     information: can be any text, or empty
%     tx: transmit number in TX(tx)
%     rcv: receive number in Receive(rcv)
%     recon: recon number in recon(recon) (thats how its named in Verasonics)
%     process: process number in Process(process)
%     secControl: sequency control number in SeqControl(seqControl)  

event = struct('info', information ...
	, 'tx', tx ...
	, 'rcv', rcv ...
	, 'recon', recon ...
	, 'process', process ...
	, 'seqControl', seqControl );
end

