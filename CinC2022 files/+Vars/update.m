function update(var_name, value)
%% update variable in 'base' workspace
base = 'base';
assert(isa(var_name,'char'), 'input is func(value, var_name)')
assert(evalin(base,sprintf('exist("%s","var")',var_name)), sprintf('Variable %s does not exist in "Base"!', var_name))
assert(strcmp(class(value),evalin(base,sprintf('class(%s)',var_name))), sprintf('tried to update %s to a different class. NOT OK!!', var_name))

assignin(base,var_name, value)

end


