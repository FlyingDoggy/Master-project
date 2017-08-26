function [ index ] = checkGtLocation( sizeWidth,sizeHeight,posWidth,posHeight,pieceWidth)
%CHECKLOCATION Summary of this function goes here
index = floor(posHeight/sizeHeight)*pieceWidth+floor(posWidth/sizeWidth+1);

end

