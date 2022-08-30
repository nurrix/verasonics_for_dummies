function append(tbl_name, fld, value)
%% APPEND Data to DataTable defined by tbl_name in 'base' workspace.
% Saves to 'base' workspace (not to function workspace)
%    append(tbl_name [string], name [string], idx [cell])

% Get lookup table
dt_name = sprintf('%s_%s',SWIGEM5Sc.DT.prefix,tbl_name);
% Get lookup table
dt = Vars.get(dt_name);

% ensure that new values are unique (we dont overwrite data)
assert(~isfield(dt, fld), sprintf('name must be unique. : %s',fld))

% assign new data to data table
dt.(fld) = value;

% Save data to base
Vars.update(dt_name, dt);

end

