function set_handle_base(h_name, H)
    %% Sets handle in base
    
    assert(nargin==2, sprintf('NARGIN should be 2, however it was %u', nargin))
    assert(nargout==0, sprintf('nargout should be 0, however it was %u', nargout))
    
    base = 'base';
    % make sure that the handle and string is not defined already.
    
    
    assert(all(ishandle(H)), 'H is not a valid handle')
    assert(isa(h_name,'char'), sprintf( 'h_name must be a char array! was a %s',class(h_name)))
    
    
    assert(evalin(base,sprintf('~exist("%s","var") || any(~ishandle(%s))',h_name, h_name)), sprintf('ERROR: HANDLE "%s" ALREADY EXIST!!!',h_name))
    
    assert(~isempty(h_name), 'h_name must be larger than length(0)')

    % if assert is apprived, we are good, and can create the handle

    
    assignin(base,h_name, H)
    
    
end