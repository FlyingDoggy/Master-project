function [ Pos1,Pos2 ] = rejectOutlier( PosA,PosB,numOfStrongesrt )
%% reject the outliers
disBet1and2 = zeros(numOfStrongesrt,1);
ang1and2 = zeros(numOfStrongesrt,1);
results = rejectMismatch( PosA,PosB );

for i = 1:length(PosA)
    if results.CS(i) ==0
        PosA(i,:) = 0;
        PosB(i,:) = 0;
    end

end

for i = 1:length(PosA)
disBet1and2(i) = sqrt((PosA(i,1)-PosB(i,1))^2+((PosA(i,2)-PosB(i,2))^2));
ang1and2(i) =radtodeg(atan((PosB(i,2)-PosA(i,2))/(PosB(i,1)-PosA(i,1))));

end

for i = 1:length(ang1and2)
if isnan(ang1and2(i)) == 1
    ang1and2(i) = 0;
end
end

PosA = PosA(any(PosA,2),:);
PosB = PosB(any(PosB,2),:);

% ang1and2 = ang1and2(ang1and2~=0);
disBet1and2 = disBet1and2(disBet1and2~=0);


 %% slope rejection
% [~,index] = sort(ang1and2);
% [~,avgAng] = bestMean(ang1and2);
% ang1and2(index(length(index)/2))
% for i = 1:length(Pos1)
%     if ang1and2(i)  >(ang1and2(index(length(index)/2))+10) || ang1and2(i)  < (ang1and2(index(length(index)/2))-10)
% %     if ang1and2(i)  >(avgAng+4) || ang1and2(i)<(avgAng - 4)
%         Pos1(i,:) = 0;
%         Pos2(i,:) = 0;
%     end
% 
% end

 %% distance rejection
[~,index] = sort(disBet1and2);
[array,~] = calMean(disBet1and2);
% [array,avgDis] = calMean(array);

% disBet1and2(index(length(index)/2))
for i = 1:length(PosA)
%     if disBet1and2(i)  >(disBet1and2(index(length(index)/2))+10) || disBet1and2(i)  < (disBet1and2(index(length(index)/2))-10)
%     if disBet1and2(i)  >(avgDis+5) || disBet1and2(i)<(avgDis -5)
    if array(i) ==0
        PosA(i,:) = 0;
        PosB(i,:) = 0;
    end

end
Pos1 = PosA(any(PosA,2),:);
Pos2 = PosB(any(PosB,2),:);
end

