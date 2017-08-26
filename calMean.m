function [ array,avg ] = calMean( array )
avg =  mean(array(array~=0));
[sorted,~] = sort(array);
if abs(sorted(1)-avg)>abs(sorted(end)-avg)
    for i = 1:length(array)
        if array(i)<avg
            array(i) = 0;
        end
    end
else
    for i = 1:length(array)
        if array(i)>avg
            array(i) = 0;
        end
    end
end
avg = mean(array(array~=0));
end



