function Trans = initializeTransducer(transName, maxHighVoltage)
%% Initialize transucer
Trans.name = transName;
Trans.units = 'wavelengths'; % Explicit declaration avoids warning message when selected by default
Trans = computeTrans(Trans);    % GEM5ScD transducer is 'known' transducer so we can use computeTrans.
Trans.maxHighVoltage = maxHighVoltage;

end

