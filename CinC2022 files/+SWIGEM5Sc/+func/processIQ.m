function processIQ(I, Q)
%% processIQFunction: Computes power estimates from IQData
% This function requires an interbuffer (That is already IQ data, and not
% RF!)

%		Power = sqrt(Im*Im + Re*Re);

% phaseAngle = arctan(Im ./ Re)
% v = c * FR / 4 / pi / f0 * phaseAngle     mm / (mu s) * 1 / s / 1 / 1 / (M / s)
%     persistent recHandle markHandle  recTrans

% funenv = @(I,Q) sqrt(squeeze(I.^2 + Q.^2));

persistent Power SWV MoviePower MovieVelocity 
with_arfi = SWIGEM5Sc.ui.with_arfi();
P = Vars.get('P');

sz = size(I);

swi_dtMs = P.PRF_time * P.numCoherentComp * 1e-3;

frames_swi = sz(4);
swi_temporal_duration = (frames_swi - 1) * swi_dtMs;


ratio = Vars.ratioFromWls();


[x_wls, y_wls] = SWIGEM5Sc.func.getPosAlongLine();
valid_arrow_coord = all(isfinite(x_wls) & isfinite(y_wls));
X = ratio * x_wls;
Y = ratio * y_wls;
swi_spatial_width = sqrt((X(2) - X(1))^2 + (Y(2) - Y(1))^2);

%% Find locations of propagation waves
[I_seg, Q_seg, realloc_mem] = SWIGEM5Sc.func.segmentSWI(I, Q);

if realloc_mem
	[Power, SWV, ...
        MoviePower, MovieVelocity] = SWIGEM5Sc.func.reallocMemory(I_seg);
end

 % PRF_time is in \mu s. So to get it to s er multiply by 1 million
[Power(:,:,:,:), SWV(:,:,:,:)] = SWIGEM5Sc.func.calcShearWaveVelocity(I_seg, Q_seg);

MoviePower(:,:,:) = squeeze(Power(:, :, 1, :));
MovieVelocity(:,:,:) = squeeze(SWV(:, :, 1, :));

shearwavetime = calcShearwaveTime(MovieVelocity, x_wls, y_wls ...
    , size(MovieVelocity,3), valid_arrow_coord, P.dTheta, P.dR);


swi_dyMm = swi_spatial_width / size(shearwavetime, 1);

[Time, Loc] = SWIGEM5Sc.func.detectPropagationWaves(shearwavetime ...
	, swi_dtMs, 0, swi_dyMm, 0, with_arfi);


%% Update Handles and variables in 'base' workspace
Vars.force_set(SWIGEM5Sc.VarNames.MoviePower, MoviePower)
Vars.force_set(SWIGEM5Sc.VarNames.MovieVelocity, MovieVelocity)

%% primary bmode figure handle update

SWIGEM5Sc.ui.updateDetectedPropagationWaves(Time, Loc, ...
    swi_temporal_duration, swi_spatial_width);
SWIGEM5Sc.ui.updateVelocity()
SWIGEM5Sc.ui.updatePower()
SWIGEM5Sc.ui.updateTemporalShearWaveVelocity(shearwavetime,swi_spatial_width, swi_temporal_duration)

	function shearwavetime ...
            = calcShearwaveTime(MovieSWV, X, Z, frames_swi, valid_arrow_coord, dTheta, dR)	
		
		if ~valid_arrow_coord
			leny = 100;
			shearwavetime = zeros(leny, frames_swi);
			return
		end
		leny = 160; % height of shearwavetime
		roi_center_theta = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterX');
		roi_center_rho_wls = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROICenterZ');
		roi_height_wls = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROIHeight');
		roi_width = SWIGEM5Sc.DT.get(SWIGEM5Sc.VarNames.SWIInfo, 'ROIWidth');
		
		
		Xcart = linspace(X(1), X(2), leny);
		Zcart = linspace(Z(1), Z(2), leny);
		[theta, rho] = cart2pol(Zcart, Xcart);
		
		theta_ref = [roi_center_theta - roi_width/2 + dTheta/2, roi_center_theta + roi_width/2 - dTheta/2];
		rho_ref = [roi_center_rho_wls - roi_height_wls/2 + dR/2, roi_center_rho_wls + roi_height_wls/2 - dR/2];
		
		Img = squeeze(MovieSWV(:, :, 1));
		shearwavetime = zeros(leny, frames_swi);
		
		for i = 1:frames_swi
			Img(:, :) = squeeze(MovieSWV(:, :, i));
			shearwavetime(:,i) ...
                = mean(impixel(theta_ref, rho_ref, Img, theta, rho), 2);
			
		end
		
	end

end