function H = get_handle_base(h_name)
%% Get handle from base workspace
assert(nargin==1, sprintf('NARGIN should be 1, however it was %u', nargin))
assert(nargout==1, sprintf('nargout should be 1, however it was %u', nargout))
% Get handle list
base = 'base';
if ~evalin(base,sprintf('exist("%s","var")',h_name))
    H = gobjects(1);
    return
end

H = evalin(base, h_name);

