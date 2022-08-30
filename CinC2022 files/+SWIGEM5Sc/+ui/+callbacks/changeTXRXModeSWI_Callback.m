function changeTXRXModeSWI_Callback(src,evt,val)
	%% System for Changing between different TX/RX profiles.
    SWIGEM5Sc.ui.updateROIandFocus()
	switch val
		case 1
			SWIGEM5Sc.ui.setModeFlash(src,evt)
			sVal = 'FLASH';
		case 2
            SWIGEM5Sc.ui.setModeSWI(src,evt)
            P = Vars.get('P');
            sVal = P.SYS_MODE;

		otherwise
			warning('%u not defined', val)
	end

	SWIGEM5Sc.DT.update(SWIGEM5Sc.VarNames.Variables, SWIGEM5Sc.VarNames.TXRX_mode, sVal)
    SWIGEM5Sc.ui.setFirstVideoReplay()
end