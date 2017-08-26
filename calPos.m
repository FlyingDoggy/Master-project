function [location] = calPos(matrix)

imsize = size(matrix);
xPos = [];
yPos = [];
for j = 1:imsize(1)
    for i = 1:imsize(2)
        tbf = matrix(j,i);
        if tbf ~=0
            xPos = horzcat(xPos,j);
            yPos = horzcat(yPos,i);
        end
    end    
end
 location = [mean(xPos),mean(yPos)];
end