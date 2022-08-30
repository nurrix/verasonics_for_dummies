function [Event, SeqControl] = initializeEvent()
%% INITIALIZE EVENT objects

with_arfi = SWIGEM5Sc.ui.with_arfi();
sLUT_Event = SWIGEM5Sc.VarNames.Event;
slut_SqC = SWIGEM5Sc.VarNames.SeqControl;
SWIGEM5Sc.lut.initializeLookupTable(sLUT_Event);
SWIGEM5Sc.lut.initializeLookupTable(slut_SqC);
% Generate UI Control initialization Event

prcUIControlProcess = SWIGEM5Sc.lut.get(SWIGEM5Sc.VarNames.Process, 'extUIControlCallback');
prcExtProcessIQData = SWIGEM5Sc.lut.get(SWIGEM5Sc.VarNames.Process, 'extProcessIQ');
prcImgReconstruct = SWIGEM5Sc.lut.get(SWIGEM5Sc.VarNames.Process, 'ImgReconstruct');


P = Vars.get('P');
PRF_time = P.PRF_time;

numCC = P.numCoherentComp;


for sqControlitr = 1
    % Sequence Control for Setting TPC profile 1
    SeqControl(1) = templates.seqControl('setTPCProfile', 'immediate', 1);
    SWIGEM5Sc.lut.append(slut_SqC, 'Prof1', length(SeqControl))

    % Sequence Control for Setting TPC profile 5
    SeqControl(length(SeqControl)+1) = templates.seqControl('setTPCProfile', 'immediate', 5);
    SWIGEM5Sc.lut.append(slut_SqC, 'Prof5', length(SeqControl))

    if with_arfi
        % Sequence Control for wait after EB!
        SeqControl(length(SeqControl)+1) = templates.seqControl('timeToNextAcq',[] , 600);
        SWIGEM5Sc.lut.append(slut_SqC, 'waitAfterPush', length(SeqControl))
        sqWaitAfterPush = SWIGEM5Sc.lut.get(slut_SqC,'waitAfterPush');

    end
    % Sequence Control for 500ms no operations
    SeqControl(length(SeqControl)+1) = templates.seqControl('noop',[] , 500e3);
    SWIGEM5Sc.lut.append(slut_SqC, 'noop500', length(SeqControl))

    % Sequence Control for 250ms no operations
    SeqControl(length(SeqControl)+1) = templates.seqControl('noop',[] , 250e3);
    SWIGEM5Sc.lut.append(slut_SqC, 'noop250', length(SeqControl))

    % Sequence Control for Flash Pulse Repetition Time delay
    SeqControl(length(SeqControl)+1) = templates.seqControl('timeToNextAcq', [], PRF_time);
    SWIGEM5Sc.lut.append(slut_SqC, 'PRF', length(SeqControl))

    % Sequence Control for Sync
    SeqControl(length(SeqControl)+1) = templates.seqControl('sync', [], []);
    SWIGEM5Sc.lut.append(slut_SqC, 'sync', length(SeqControl))

    % Sequence Control for Return to Matlab
    SeqControl(length(SeqControl)+1) = templates.seqControl('returnToMatlab', [], []);
    SWIGEM5Sc.lut.append(slut_SqC, 'rtm', length(SeqControl))

    % Sequence Control for Return to Matlab
    SeqControl(length(SeqControl)+1) = templates.seqControl('triggerOut', [], []);
    SWIGEM5Sc.lut.append(slut_SqC, 'trigger_out', length(SeqControl))

end

sqRTM = SWIGEM5Sc.lut.get(slut_SqC,'rtm');
sqNOOP500 = SWIGEM5Sc.lut.get(slut_SqC,'noop500');
sqNOOP250 = SWIGEM5Sc.lut.get(slut_SqC,'noop250');
sqPRF = SWIGEM5Sc.lut.get(slut_SqC,'PRF');
sqSync = SWIGEM5Sc.lut.get(slut_SqC,'sync');
sqTOut = SWIGEM5Sc.lut.get(slut_SqC,'trigger_out');
sqProf1 = SWIGEM5Sc.lut.get(slut_SqC,'Prof1');
sqProf5 = SWIGEM5Sc.lut.get(slut_SqC,'Prof5');

Event(1) = templates.Event('ext func for UI control', 0, 0, 0, prcUIControlProcess, 0);

for flashitr = 1

    % Generate Flash Setup
    Event(length(Event)+1) = templates.Event('Flash - noop after charging TPC Profile', 0, 0, 0, 0, sqNOOP250);
    SWIGEM5Sc.lut.append(sLUT_Event,'Flash_Setup', length(Event))
    Event(length(Event)+1) = templates.Event('Flash - Switch to profile 1', 0, 0, 0, 0, sqProf1);
    Event(length(Event)+1) = templates.Event('Flash - noop after charging TPC Profile', 0, 0, 0, 0, sqNOOP500);

    % Generate Flash Events
    SWIGEM5Sc.lut.append(sLUT_Event,'Flash_StartAcq', length(Event)+1)

    StartAcq = SWIGEM5Sc.lut.get(sLUT_Event, 'Flash_StartAcq');

    N = 1;
    rcvinit = 0;
    for z = 1:P.numFrames(N)
        ind(1) = P.np(N) * P.na(N) * numCC * (z - 1);

        stmp = sprintf('Flash - Sync [%u]',z);
        Event(length(Event)+1) = templates.Event(stmp,0,0,0,0, [sqSync]);

        for i = 1:P.np(N)
            ind(2) = P.na(N) * numCC * (i - 1);

            for j = 1:P.na(N)
                ind(3) = numCC * (j - 1);

                for k = 1:numCC
                    ind(4) = k;
                    rcvnum = rcvinit + sum(ind);
                    % Transmit Receive Event
                    Event(length(Event)+1) = templates.Event(sprintf('Flash - TX/RX [%u,%u,%u,%u]',z,i,j,k), ...
                        k,... % tx
                        rcvnum, ... % rcv
                        0, 0, sqPRF);

                end
            end
        end

        Event(end).seqControl = sqSync;

        % Transfer to host
        % - Generate sq
        SeqControl(length(SeqControl)+1) = templates.seqControl('transferToHost', [], []);
        % generate transfer event
        Event(length(Event)+1) = templates.Event( sprintf('Flash - Transfer2Host [%u]', z), 0, 0, 0, 0, length(SeqControl));

        Event(length(Event)+1) = templates.Event( sprintf('Flash - recon and process [%u]', z), 0, 0, 1, prcImgReconstruct, [sqRTM,sqSync]);

    end
    rcvinit = rcvnum;
end

% Jump back to nStartAcqFlash Event
% gen sq
SeqControl(length(SeqControl)+1) = templates.seqControl('jump', [], StartAcq);
% gen event
Event(length(Event)+1) = templates.Event('Flash - Restart Loop', 0, 0, 0, 0, length(SeqControl));



for swiitr = 1

    % Generate SWI Setup
    Event(length(Event)+1) = templates.Event('SWI - noop after charging TPC Profile', 0, 0, 0, 0, sqNOOP250);
    SWIGEM5Sc.lut.append(sLUT_Event,'SWI_Setup', length(Event))
    Event(length(Event)+1) = templates.Event('SWI - Switch to profile 5', 0, 0, 0, 0, sqProf5);
    Event(length(Event)+1) = templates.Event('SWI - noop after charging TPC Profile', 0, 0, 0, 0, sqNOOP500);

    N = 2;

    % Generate SWI Events
    SWIGEM5Sc.lut.append(sLUT_Event,'SWI_StartAcq', length(Event)+1)

    StartAcq = SWIGEM5Sc.lut.get(sLUT_Event, 'SWI_StartAcq');


    for z = 1:P.numFrames(N)
        ind(1) = P.np(N) * P.na(N) * numCC * (z - 1);

        % Sync!
        Event(length(Event)+1) = templates.Event(sprintf('SWI - Sync New Frame [%u]', z), ...
            0,... % tx
            0, ... % rcv
            0, 0, sqSync);


        if with_arfi
            stmp = sprintf('ARFI PUSH %u', z);
            Event(length(Event)+1) = templates.Event(stmp, 2,0,0, 0, [sqWaitAfterPush, sqTOut]);
        else

        end
        count_na = 0;
        sb_frame = 1;
        for i = 1:P.np(N)
            ind(2) = P.na(N) * numCC * (i - 1);
            for j = 1:P.na(N)
                ind(3) = numCC * (j - 1);
                for k = 1:numCC
                    ind(4) = k;

                    rcvnum = rcvinit + sum(ind);
                    % Transmit Receive Event
                    Event(length(Event)+1) = templates.Event(sprintf('SWI - TX/RX [%u,%u,%u,%u]',z,i,j,k), ...
                        k, rcvnum, 0, 0, sqPRF);

                end
                if ind(2)+ind(3)+ind(4) == P.np(N) * P.na(N) * numCC
                    Event(end).seqControl = 0;
                end

                % Create subframe DMA, every 50 frames
                sz_subframe = 50;
                count_na = count_na + 1;
                if mod(count_na,sz_subframe)==0 && count_na < P.np(N) * P.na(N) - sz_subframe
                    sName = sprintf('SWI - Transfer2Host Frame [%u], SF [%u/%u]', z, sb_frame, floor(P.np(N)*P.na(N) / sz_subframe)+1 );
                    [Event, SeqControl] ...
                        = templates.newTransferToHost(sName, [] ,Event, SeqControl);

                    % Itr sb_frame
                    sb_frame = sb_frame + 1;
                end
            end
        end



        % Transfer to host
        sName = sprintf('SWI - Transfer2Host Frame [%u], SF [%u/%u]', ...
            z, sb_frame, floor(P.np(N)*P.na(N) /sz_subframe)+1 );
        [Event, SeqControl] ...
            = templates.newTransferToHost(sName, sqSync, Event, SeqControl);

        % Generate flash image
        Event(length(Event)+1) = templates.Event( sprintf('SWI - Process SWI [%u]', z), 0, 0, [2,3], prcImgReconstruct, 0);
        Event(length(Event)+1) = templates.Event( sprintf('SWI - Process SWI [%u]', z), 0, 0, 0, prcExtProcessIQData, [sqRTM sqSync]);

        % Sync!
        Event(length(Event)+1) = templates.Event(sprintf('SWI - Sync Transfer Finished [%u]', z), ...
            0,... % tx
            0, ... % rcv
            0, 0, [sqSync sqRTM]);

    end


    % Jump back to nStartAcqSWI Event
    % gen sq
    SeqControl(length(SeqControl)+1) = templates.seqControl('jump', [], StartAcq);
    % gen event
    Event(length(Event)+1) = templates.Event('SWI - Restart Loop', 0, 0, 0, 0, length(SeqControl));
end

end

