function v = speedofsound_mmmicrosec()
%% get speed of sound in mm/ \mu sec

P = Vars.get(SWIGEM5Sc.VarNames.P);
v = P.speedofsound/1000;
end

