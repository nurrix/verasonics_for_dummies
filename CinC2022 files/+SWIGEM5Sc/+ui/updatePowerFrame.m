function updatePowerFrame(pwrFigHandle, ith_frame)
axVel = gca(pwrFigHandle);
title(axVel,sprintf('Power Visualization with 11LD time:%03.1f ms' ...
    , (ith_frame-1) * evalin('base','P.PRF_time * P.numCoherentComp')/1000))

pwrHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.imgPowerHandle);
buffer_pol = evalin('base',sprintf("MoviePower(:,:,%u)",ith_frame));
[~, ~, buffer] = SWIGEM5Sc.func.scanConversion(buffer_pol);
set(pwrHandle,'CData',buffer);
end

