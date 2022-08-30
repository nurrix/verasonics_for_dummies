function  Trans = CustomTransArrayGE11LD(units,fc)
%% Trans for GE11LD
% This function will generate the information for the Trans object, if the
% user wishes to use the custom transducer: GE11LD.


v = 1.54; % mm / mu sec
if nargin == 0
    error('Must define units.')
elseif nargin == 1
    fc = 7.3; % Default MHz Central Frequency 7.3
    
end
assert(isa(units,'char'), sprintf('units MUST BE of class "char", but was a "%s"',class(units)))
assert(strcmpi(units,'mm')|strcmp(units,'wavelengths'), sprintf('units MUST BE "mm"|"wavelengths"'))
lampda = v/fc;

n = 192; % Number of elements
FOVmm = 38; % FOV in mm 38
Theta = linspace(-pi/2, pi/2, 101);
spacingmm = FOVmm / (n-1); % Spacing between elements in mm
spacingwls = spacingmm / lampda; % spacing between elements in wls
FOVwls = FOVmm / lampda;
elmWidthMm = 0.2070; % mm

Trans.name = 'GE11L-D';
Trans.units = units; % 'wavelengths' | 'mm'
Trans.lensCorrection = 1;
if strcmpi(Trans.units,'mm')
    Trans.lensCorrection = 1;
elseif strcmpi(Trans.units,'wavelengths')
    Trans.lensCorrection = 1/lampda;
else
    error('units not defined correctly')
end



Trans.id = 2556431;
Trans.frequency = fc;
Trans.Bandwidth = Trans.frequency+Trans.frequency*[-0.4,0.4];
Trans.type = 0;
Trans.connType = 7;
Trans.numelements = n;
Trans.spacingMm = spacingmm;
if strcmpi(Trans.units,'mm')
    Trans.elementWidth = elmWidthMm; % mm
elseif strcmpi(Trans.units,'wavelengths')
    Trans.elementWidth = elmWidthMm/lampda;
else
    error('units not defined correctly')
end
Trans.elevationApertureMm = 6;
Trans.elevationFocusMm = 40;
if strcmpi(Trans.units,'mm')
    Trans.ElementPos = zeros(n,5); Trans.ElementPos(1:end,1) = linspace(-FOVmm/2,FOVmm/2,n);
elseif strcmpi(Trans.units,'wavelengths')
    Trans.ElementPos = zeros(n,5); Trans.ElementPos(1:end,1) = linspace(-FOVwls/2,FOVwls/2,n);
else
    error('units not defined correctly')
end
Trans.impedance = 50;
Trans.maxHighVoltage = 50;
Trans.ConnectorES = (33:224)';
Trans.spacing = spacingwls;

X = Trans.elementWidth*pi*sin(Theta);X(X==0)=eps;
Trans.ElementSens = abs(cos(Theta).*(sin(X)./X));

end
% Trans