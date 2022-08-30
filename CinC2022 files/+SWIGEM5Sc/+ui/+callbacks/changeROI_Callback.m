
function changeROI_Callback(SWICenterROI_handle, evt)
	freeze = evalin('base','freeze');
	vsExit = evalin('base','vsExit');

	if freeze == 1 || vsExit == 1  % no response if freeze or exit
		return
	end

	evname = evt.EventName;
	switch(evname)
		case{'MovingROI'}
			moving_callback(evt)

			return
		case{'ROIMoved'}
			moved_callback(SWICenterROI_handle, evt)
	end


    SWIGEM5Sc.ui.setFirstVideoReplay()


	function moving_callback(evt)
		
	end

	function moved_callback(SWICenterROI_handle, evt)
		P = Vars.get('P');
		depthEnd = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.Variables,'depthEnd');
		ratio = Vars.ratioFromWls();
		% Get current pos i theta and depth
		pos_wls = evt.CurrentPosition/ratio;
		w = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'ROIWidth');
		h_wls = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo,'ROIHeight');
		[theta, r] = cart2pol(pos_wls(2), pos_wls(1));
		
		% Check boundaries
		if abs(theta)+w/2 > P.fov_rad/2
			theta = sign(theta) * (P.fov_rad-w)/2;
		end
		
		if r  < h_wls/2
			r = h_wls/2;
		elseif r  > depthEnd - h_wls/2
			r = depthEnd - h_wls/2;
		end
		
		% Update Variables 
		
		SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo,'ROICenterX', theta);
		SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo,'ROICenterZ', r);
		
		% update locations
		[y,x] = pol2cart(theta, r*ratio);
		set(SWICenterROI_handle, 'Position', [x,y])

		% Trans and PData are required for computeRegions
		PData = Vars.get(SWIGEM5Sc.VarNames.PData);
		r1 = r-h_wls/2;
		r2 = r+h_wls/2;
		PData(2).Region.Shape = SWIGEM5Sc.func.updateDPataRegionShape(...
			PData(2).Region.Shape, r1, r2, theta, []);
		
		PData(2).Region = computeRegions(PData(2));
		
		Vars.update(SWIGEM5Sc.VarNames.PData, PData)
		
		
		Vars.updateControl('',{SWIGEM5Sc.VarNames.PData,SWIGEM5Sc.VarNames.Recon})
% 		Vars.force_set('action', 'displayChange')
		
		SWIGEM5Sc.ui.updateROIandFocus()
		
	end

end