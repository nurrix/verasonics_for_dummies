function updateVelocityFrame(velFigHandle, ith_frame)
axVel = gca(velFigHandle);
title(axVel,sprintf('Shear Wave Velocity Visualization with 11LD time:%03.1f ms' ...
    , (ith_frame-1) * evalin('base','P.PRF_time * P.numCoherentComp')/1000))

velocityHandle = Vars.handles.get_handle_base(SWIGEM5Sc.VarNames.imgVelHandle);
buffer_pol = evalin('base',sprintf("MovieVelocity(:,:,%u)",ith_frame));
[~, ~, buffer] = SWIGEM5Sc.func.scanConversion(buffer_pol);
set(velocityHandle,'CData',buffer);
end

