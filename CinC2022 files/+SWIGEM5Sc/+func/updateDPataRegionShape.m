function Shape = updateDPataRegionShape(Shape, r1, r2, steer, angle)
%% Update the Pixel Data region shape.
	if ~isempty(angle)
		Shape.angle = angle;
	end
	if ~isempty(steer)
		Shape.steer = steer;
	end
	switch Shape.Name
		case 'SectorFT'
			if ~isempty(r1)
				Shape.z = r1;
			end
			if ~isempty(r2)
				Shape.r = r2;
			end
		case 'Sector'
			if ~isempty(r1)
				Shape.r1 = r1;
			end
			if ~isempty(r2)
				Shape.r2 = r2;
			end
		otherwise
			error('name not defined for Shape : %s', name)
	end


end

