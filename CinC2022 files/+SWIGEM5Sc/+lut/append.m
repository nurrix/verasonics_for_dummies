function append(tbl_name, name, idx)
%% APPEND Data to LookupTable defined by tbl_name in 'base' workspace.
% Saves to 'base' workspace (not to function workspace)
%    append(tbl_name [string], name [string], idx [double])

% Get lookup table
lut_name = sprintf('%s_%s',SWIGEM5Sc.lut.prefix,tbl_name);



lut = Vars.get(lut_name);

% ensure that new values are unique (we dont overwrite data)
assert(~any(contains(lut.name, name)), sprintf('name must be unique. : %s',name))
assert(~any(lut.idx == idx), sprintf('idx must be unique. : %u',idx))

% assign new data to lut
lut(end+1,:) = {name, idx};

% Save data to base

Vars.update(lut_name, lut);

end

