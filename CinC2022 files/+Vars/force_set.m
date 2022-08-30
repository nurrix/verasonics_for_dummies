function force_set(var_name, value)
%% set variable in 'base' workspace (the nuke option!)
base = 'base';
assignin(base,var_name, value)
end

