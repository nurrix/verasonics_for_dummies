function updateTX(finalMsg)
%% update the Transmit object.
TX = Vars.get('TX');
assert(length(TX)>1, 'TX MUST BE LARGER THAN 1, as a push system must be implemented')


% Location.newX won't be assigned if new focus is not determined

if ~isempty(SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'pushStartElm'))
    Ind = find(TX(2).Apod == 1);
    SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'pushStartElm', Ind(1))
end

P = Vars.get(SWIGEM5Sc.VarNames.P);
pushStartElm = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'pushStartElm');
numPushElements = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'numPushElements');

numCC = P.numCoherentComp;
apod = SWIGEM5Sc.func.calcApod(P.transNumElmTheta...
    , P.transNumElmAzi, pushStartElm, numPushElements, @(n) ones(1,n));

for ix = numCC+1 :length(TX)
    TX(ix).Apod = apod;

    TX(ix).Steer(1) = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'focusX');
    TX(ix).focusX = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'focusX');
%     TX(ix).Origin = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'focusX');
    TX(ix).focus = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'focusZ');

    TX(ix).oldElements = TX(ix).pushElements;
    TX(ix).Delay = computeTXDelays(TX(ix));

end

fprintf('%s\n', finalMsg);
% Update TX in base.
Vars.update(SWIGEM5Sc.VarNames.TX, TX)

Vars.updateControl('',{'TX'})

end