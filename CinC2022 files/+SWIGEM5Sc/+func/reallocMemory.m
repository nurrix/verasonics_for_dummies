function [Power, velocityData, MoviePower, MovieVelocity] = reallocMemory(IQ_seg)
% Reallocate memory for calculations
sz_IQ = size(IQ_seg);
sz_z1 = sz_IQ; 
sz_z1(end) = sz_z1(end)-1;
sz_movie = sz_z1([1,2,4]);

%     z1 = zeros(sz_z1,'like',IQ_seg);
%     z1filt = z1;
%     PhaseAngle = z1;
    Power = zeros(sz_z1);
    velocityData = zeros(sz_z1);
    MoviePower = zeros(sz_movie);
    MovieVelocity = zeros(sz_movie);


end

