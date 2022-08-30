function value = get(tbl_name, name)
%% Get value from table

lut_name = sprintf('%s_%s',SWIGEM5Sc.lut.prefix,tbl_name);

lut = Vars.get(lut_name);
idx = strcmp(lut.name, name);

if ~any(idx)
	disp({'Possibilities', lut.name'})
	disp({'Input', name})
	error('Value not found')
end

value = lut.idx(idx);

end

