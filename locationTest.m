function [ ptsOut ] = locationTest( Iin,M,pts )


% Make all x,y indices
[x,y]=ndgrid(1:size(Iin,1),1:size(Iin,2));

xd=x;
yd=y;

% Calculate the Transformed coordinates
Tlocalx = M(1,1) * xd + M(1,2) *yd + M(1,3) * 1;
Tlocaly = M(2,1) * xd + M(2,2) *yd + M(2,3) * 1;
ptsOut(1,1) = Tlocalx(pts(1,1),pts(1,2));
ptsOut(1,2) = Tlocaly(pts(1,1),pts(1,2));

end

