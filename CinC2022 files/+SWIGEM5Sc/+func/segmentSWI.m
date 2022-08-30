function [I_seg, Q_seg, realloc_mem] = segmentSWI(I, Q)
%% Segment IQ data

persistent rc_old
PData = Vars.get(SWIGEM5Sc.VarNames.PData);

sz = size(I);
% Find where in array ROI is!
[row, col] = ind2sub(sz(1 : 2), (PData(2).Region.PixelsLA([1, end]) + 1));
rows = row(1) : row(2);
cols = col(1) : col(2);

I_seg = I(rows, cols, :, :); % VTS-1142 separate I and Q buffers
Q_seg = Q(rows, cols, :, :);
rc_new = [row(:); col(:)]';

if isempty(rc_old)
	rc_old = nan(size(rc_new));
end

realloc_mem = ~all(rc_old == rc_new);
rc_old = rc_new;


end

