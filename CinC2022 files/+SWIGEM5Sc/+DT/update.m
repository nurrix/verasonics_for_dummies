function update(tbl_name, fld, value)
%% Update DT structure

dt_name = sprintf('%s_%s',SWIGEM5Sc.DT.prefix,tbl_name);

DT = Vars.get(dt_name);
assert(isfield(DT, fld), sprintf('field not defined: %s', fld))
DT.(fld) = value;

Vars.update(dt_name,DT)

end

