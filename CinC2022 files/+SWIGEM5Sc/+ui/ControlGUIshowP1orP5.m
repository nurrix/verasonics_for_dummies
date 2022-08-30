function ControlGUIshowP1orP5(set_mode_val)

switch set_mode_val
    case {'Flash'}
        TF = [true, false];
    case {'SWI', 'ARFI'}
        TF = [false, true];
        
    otherwise
        error('The input is not defined for showP1orP5')
end

% make P1 slider unvisible and P5 slider visible
hv1Handle(1) = findobj('String',    'High Voltage P1');
hv1Handle(2) = findobj('tag',       'hv1Sldr');
hv1Handle(3) = findobj('tag',       'hv1Value');
set(hv1Handle,'Visible',            TF(1));

hv2Handle(1) = findobj('String',    'High Voltage P5');
hv2Handle(2) = findobj('tag',       'hv2Sldr');
hv2Handle(3) = findobj('tag',       'hv2Value');
hv2Handle(4) = findobj('tag',       'hv2Actual');
set(hv2Handle,'Visible',            TF(2));

end

