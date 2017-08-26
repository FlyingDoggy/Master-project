function [ averageDis, allDis ] = evaluation( Pos1,Pos2 )
allDis = [];
for i = 1: length(Pos1)
    avgDis = sqrt((Pos1(i,1)-Pos2(i,1))^2+((Pos1(i,2)-Pos2(i,2))^2));
    allDis = vertcat(allDis, avgDis);
end
averageDis = mean(allDis);
end

