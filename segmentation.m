clc;clear; close all;

dir = 'Img/';
folder = 'queens/';
imFormat = '.png';
imRefName = 1;
imTarName = 5;



refI = strcat(dir,folder,num2str(imRefName),imFormat);
tarI = strcat(dir,folder,num2str(imTarName),imFormat);

I1=rgb2gray(imread(refI));
I2=rgb2gray(imread(tarI));
pieceHeight = 2;
pieceWidth = 3;
piece = pieceHeight*pieceWidth;
imsize = size(I1);
im1 = {};
im2 = {};
imSize = size(I1);
sizeHeight = floor(imSize(1)/pieceHeight);
sizeWidth = floor(imSize(2)/pieceWidth);
imref = [];
imtar = [];
%% split the image
parfor index = 1:piece
    xPos = floor((index-1)/pieceWidth)*sizeHeight;
    yPos = mod((index-1),pieceWidth)*sizeWidth;
    for i = xPos+1:xPos+sizeHeight
        for j = yPos+1:yPos+sizeWidth
            tempX = mod(i,sizeHeight);
            if tempX == 0
                tempX = sizeHeight;
            end
             tempY = mod(j,sizeWidth);
            if tempY == 0
                tempY = sizeWidth;
            end
            imref(tempX,tempY,:) = I1(i,j,:);
            imtar(tempX,tempY,:) = I2(i,j,:);
        end
    end
    im1{index} =imref;
    im2{index} = imtar;
    imref = [];
    imtar = [];
end

I3 = findSeg(im1{2});
I4 = findSeg(im2{2});