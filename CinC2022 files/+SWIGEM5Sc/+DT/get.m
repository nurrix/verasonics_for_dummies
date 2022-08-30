function value = get(tbl_name, fld)
%% Get value from table

dt_name = sprintf('%s_%s',SWIGEM5Sc.DT.prefix,tbl_name);

DT = Vars.get(dt_name);
if ~isfield(DT, fld)
	error('Value not found in %s: %s',tbl_name, fld)
end

value = DT.(fld);

end

