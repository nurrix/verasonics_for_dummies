function DT = initializeDataTable(tbl_name)
%% INITIALIZELOOKUPTABLE initializes lookup table in 'base' workspace

dt_name = sprintf('%s_%s',SWIGEM5Sc.DT.prefix,tbl_name);

% DT = table('Size', [0,2] ...
% 	, 'VariableTypes', {'string', 'cell'} ...
% 	, 'VariableNames', {'name','value'});

Vars.set(dt_name, struct())
end

