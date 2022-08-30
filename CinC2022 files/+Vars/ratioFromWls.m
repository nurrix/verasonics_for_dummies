function ratio = ratioFromWls()
%% Get the ratio of the to convert from wavelengths, to whatever unit we spefified!

P = Vars.get(SWIGEM5Sc.VarNames.P);
ratio = P.ratio2mm;
end

