function [allDis, diff,rmse,nPos1,nPos2 ] = evaResult( I1,I2,numOfStrongesrt )
[nPos1,nPos2] = extractFeature(I1,I2,numOfStrongesrt);

[nPos1,nPos2] = rejectOutlier(nPos1,nPos2,numOfStrongesrt);

[diff,allDis]= evaluation(nPos1,nPos2);
rmse = sqrt(immse(nPos1,nPos2));
end

