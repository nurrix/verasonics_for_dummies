function tf = with_arfi()
%IS_REPLAY Summary of this function goes here
%   Detailed explanation goes here
P = Vars.get(SWIGEM5Sc.VarNames.P);
tf = strcmpi(P.SYS_MODE,'ARFI');
end

