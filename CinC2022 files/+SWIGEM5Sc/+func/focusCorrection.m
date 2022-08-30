function focusCorrection()
	%% change focus of ARFI system
	% Also change sfocus of TX/RX

	TX =  Vars.get(SWIGEM5Sc.VarNames.TX);
    P = Vars.get(SWIGEM5Sc.VarNames.P);
	ElementsPos = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ElementsPos');
	with_arfi = SWIGEM5Sc.ui.with_arfi();
	if with_arfi 
        % If we are not using ARFI, this function is pointless, so just return.

		if isempty(SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'pushStartElm'))
			Ind = find(TX(2).Apod == 1);
			
			SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'Elements', TX(2).focusX)
			SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'focusX', TX(2).focusX)
			SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'focusZ', TX(2).focus)
			SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'pushStartElm', Ind(1))
			
		end

		pushElements = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'numPushElements');
		hard_limits = [1, P.transNumElmTheta];
        if strcmpi(P.Coord, 'polar')
            theta = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'focusX');
            r = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'focusZ');
		    [~,x] = pol2cart(theta,r);
        else
            x = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'focusX');
        end
		
		[~,idx] = min(abs(x - ElementsPos));     % Find closest xposition to push focus
		idx_bdr = idx + floor([-pushElements/2, pushElements/2 - 1]); % Find

		idx_bdr = idx_bdr + max(hard_limits(1)-idx_bdr(1),0) - max(idx_bdr(2)-hard_limits(2),0);
		pushStartEle = idx_bdr(1);
		pushStartElmPos = ElementsPos(pushStartEle);
		SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'pushStartElm', pushStartEle)
		SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.SWIInfo, 'pushStartElmPos', pushStartElmPos)
		
	end
end
