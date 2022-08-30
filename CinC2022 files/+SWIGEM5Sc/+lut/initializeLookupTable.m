function lut = initializeLookupTable(tbl_name)
%% INITIALIZELOOKUPTABLE initializes lookup table in 'base' workspace
lut_name = sprintf('%s_%s',SWIGEM5Sc.lut.prefix,tbl_name);

lut = table('Size', [0,2] ...
	, 'VariableTypes', {'string', 'double'} ...
	, 'VariableNames', {'name','idx'});

Vars.set(lut_name, lut)
end

