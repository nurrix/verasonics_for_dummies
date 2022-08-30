function set(var_name, value)
%% set variable in 'base' workspace

base = 'base';
assert(isa(var_name,'char'), 'input is func(value, var_name)')
assert(evalin(base,sprintf('~exist("%s","var")',var_name)), sprintf('Variable "%s" exist in "Base"!',var_name))

assignin(base,var_name, value)
end

