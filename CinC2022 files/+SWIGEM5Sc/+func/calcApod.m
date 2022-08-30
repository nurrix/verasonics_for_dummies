function apod = calcApod(w_apod, rpts, start_elm, w_elm, fun)
%% Function for calculating apod.
% If fun(h,w), i.e. ones(h,w), instead do : @(x) ones(1,x), as input
%
% ex1. calcApod(100,2,36,14,@(x) ones(1,x));
% ex2. calcApod(100,2,36,14,@(x) gauss(x));

assert(w_apod * rpts >= (rpts-1)*w_apod+start_elm+w_elm-1, 'idx cannot exceed w_apod * rpts, check the inputs for "(rpts-1)*w_apod+start_elm+w_elm-1"')
assert(start_elm >= 1, 'Start elm should be larger than 1!!!')

apod = zeros(1, w_apod * rpts);

for i = 0:rpts-1
    apod((i)*w_apod+ start_elm:(i)*w_apod+start_elm+w_elm-1) = fun(w_elm);
end
end

