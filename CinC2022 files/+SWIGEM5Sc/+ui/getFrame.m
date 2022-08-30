function frame = getFrame(fig_handle)
frame = getframe(fig_handle);
% padding to a multiple of two for MPEG-4 format
[row,col,~]=size(frame.cdata);
if ~isequal(mod(row,2),0)
    frame.cdata(end,:,:) = [];
end
if ~isequal(mod(col,2),0)
    frame.cdata(:,end,:) = [];
end