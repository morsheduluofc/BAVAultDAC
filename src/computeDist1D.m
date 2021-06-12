function dist = computeDist1D(points,pt,field)
% COMPUTEDIST() computes the minimum distance of a point 'x' from
% any point in a point-set [ x ] ~ N x 1.
% All measurement takes place in a finite field of order specified in
% the argument `field`.

% define vector to hold distances:
dists = zeros(size(points,1),1);

%pointsx = points.x;
pointsx = points;
ptx = pt.x;

% compute distance of `pt` to each point in `points`:
for idx=1:size(points,1)
	if(pointsx(idx,1)>= ptx)
        dists(idx) = pointsx(idx,1) - ptx;
     else
        dists(idx) = ptx-pointsx(idx,1);
    end
    %dists(idx) = abs(pointsx(idx,1) - ptx);
end

% return minimum distance:
dist = min(dists);

end