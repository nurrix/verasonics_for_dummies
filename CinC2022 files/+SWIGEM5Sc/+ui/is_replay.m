function tf = is_replay()
%IS_REPLAY Summary of this function goes here
%   Detailed explanation goes here
    UI = Vars.get(SWIGEM5Sc.VarNames.UI);
    obj = UI(SWIGEM5Sc.lut.get(SWIGEM5Sc.VarNames.UI,'replayVideo')).handle;
    try
        tf = obj.Value;
    catch
        tf = false;
    end
end

