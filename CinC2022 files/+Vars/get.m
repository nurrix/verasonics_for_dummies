function v = get(var_name)
%% get variable from 'base' workspace

base = 'base';
assert(isa(var_name,'char'), 'input is func(var_name)')
assert(evalin(base,sprintf('exist("%s","var")',var_name)), sprintf('Variable "%s" does not exist in "Base"!',var_name))
v = evalin(base,var_name);
end

