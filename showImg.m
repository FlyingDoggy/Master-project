function showImg( I1,I2,Pos1,Pos2 )

figure, imshowpair(I1,I2,'montage'); hold on;

% Show the best matches
plot([Pos1(:,2) Pos2(:,2)+size(I1,2)]',[Pos1(:,1) Pos2(:,1)]','-');
plot([Pos1(:,2) Pos2(:,2)+size(I1,2)]',[Pos1(:,1) Pos2(:,1)]','o')

hold off;

end

