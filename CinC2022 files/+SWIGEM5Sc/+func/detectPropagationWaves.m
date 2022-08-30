function [Time,Loc] = detectPropagationWaves(SWIArray, dt, toffset,dy, yoffset, with_DetectedPropagationWaves)
%% Identify propagation of waves in the temporal shear wave image


if ~with_DetectedPropagationWaves
    Time = [];
    Loc = [];
	return
end
im = imfilter(SWIArray,fspecial('average',[7,7]));
im(isnan(im)) = 0;
BW = edge(im, 'Canny');
% figure(9991),imagesc(BW)

maxvelocity = 8; % m/s or mm/ms
% angMax = ceil( ...
%             rad2deg( ...
%                 angle( ...
%                     complex(dt, maxvelocity*dy) ...
%                     )));
                
% theta = -angMax:0.5:angMax; 
[H,theta,rho] = hough(BW);
num_peaks = 100;
% hough_val_thr = ceil(0.8*max(H(:)));
fillgap = 15;
minlen = 20;

P = houghpeaks(H,num_peaks);%, 'threshold', hough_val_thr);
lines = houghlines(BW, theta, rho, P, 'FillGap', fillgap, 'MinLength', minlen);


Time = arrayfun(@(l) [l.point1(1), l.point2(1)]* dt + toffset, lines, 'UniformOutput', false);
Loc = arrayfun(@(l) [l.point1(2), l.point2(2)]* dy + yoffset, lines, 'UniformOutput', false);
TF = arrayfun(@(l,t) calcVel(l, t, maxvelocity) , Loc, Time);

Time = Time(TF);
Loc = Loc(TF);

    function TF = calcVel(l, t, maxvelocity)
        TF = abs(diff(l{1}) / diff(t{1})) < maxvelocity;
    end
% for i = 1:length(Loc);diff(Loc{i}) / diff(Time{i}),end
end