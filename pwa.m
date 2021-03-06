clc;clear; close all;
run('SetPathLocal.m');
dir = 'Img/';
folder = 'queens/';
imFormat = '.png';
imRefName = 1;
imTarName = 5;



refI = strcat(dir,folder,num2str(imRefName),imFormat);
tarI = strcat(dir,folder,num2str(imTarName),imFormat);

I1=im2double(imread(refI));
I2=im2double(imread(tarI));
numOfStrongesrt = 100;
pieceHeight = 2;
pieceWidth = 5;
piece = pieceHeight*pieceWidth;
imsize = size(I1);
im1 = {};
im2 = {};
imSize = size(I1);
sizeHeight = floor(imSize(1)/pieceHeight);
sizeWidth = floor(imSize(2)/pieceWidth);
imref = [];
imtar = [];

%% load GT
%queens
switch(folder)
    case 'queens/'
        format = '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d';
        allGT = loadGT(dir,folder,15,format);


%House
    case 'house/'
        format = '%d %d %d %d %d %d %d %d %d %d %d %d %d';
        allGT = loadGT(dir,folder,13,format);

end

refGT = allGT{imRefName};
tarGT = allGT{imTarName};
newRefGT = refGT;
newTarGT = tarGT;
newRefGT(:,1) =  mod(refGT(:,1),sizeHeight);
newTarGT(:,1) = mod(tarGT(:,1),sizeHeight);
newRefGT(:,2) =  mod(refGT(:,2),sizeWidth);
newTarGT(:,2) = mod(tarGT(:,2),sizeWidth);
whiteImage = {};
for i = 1:length(newTarGT)
    indexOfPatch(i) = checkGtLocation(sizeWidth,sizeHeight,tarGT(i,2),tarGT(i,1),pieceWidth);
%     estimatedTar(i,:) = transformPointsForward(M2{index(i)},[newTarGT(i,1),newTarGT(i,2)]);
%     estimatedTar(i,:) = Mtest{index(i)}*tarGT(i,:)';
temp =  zeros(sizeHeight,sizeWidth);
temp(newTarGT(i,1),newTarGT(i,2)) = 255;
whiteImage{i}(:,:,1) = temp;
whiteImage{i}(:,:,2) = temp;
whiteImage{i}(:,:,3) = temp;

end
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

Pos1 = {piece};
Pos2= {piece};
nPos1 = {piece};
nPos2= {piece};
M ={piece};
Mtest = {piece};
M2 = {piece};
my_M = {piece};
I2_warped = {piece};
I2_warped2 = {piece};
diffm = (piece);
rmsem = (piece);
diffm2 = (piece);
rmsem2 = (piece);

%% detect, extract, calcuate affine and warp
parfor i = 1:piece
    [Pos1{i},Pos2{i}] = extractFeature(im1{i},im2{i},numOfStrongesrt);
    
    %     showImg(im1{i},im2{i},Pos1{i},Pos2{i});
    
    %% reject outliers
    [Pos1{i},Pos2{i}] = rejectOutlier(Pos1{i},Pos2{i},numOfStrongesrt);
    M2{i} = fitgeotrans(Pos2{i}, Pos1{i},'affine');
    for j = 1:length(Pos1{i})
        Pos1{i}(j,3)=1; Pos2{i}(j,3)=1;
    end
    M{i}=Pos2{i}'/Pos1{i}';
    Mtest{i}=Pos1{i}'/Pos2{i}';
   
    % Add subfunctions to Matlab Search path
    functionname='OpenSurf.m';
    functiondir=which(functionname);
    functiondir=functiondir(1:end-length(functionname));
    addpath([functiondir '/WarpFunctions'])
    % Warp the image

    I2_warped{i}=affine_warp(im2{i},M{i});
%     I2_warped{i}=imresize(imwarp(im2{i},M2{i}),[sizeHeight,sizeWidth]);

%     I2_warped{i}=affine_warp(im2{i},M2{i}.T);
  
%     [ allDis{i},diffm(i),rmsem(i) ] = evaResult(im1{i},I2_warped{i},numOfStrongesrt);
%     [~, diffm2(i),rmsem2(i) ] = evaResult(im1{i},I2_warped2{i},numOfStrongesrt);
    
    i
end

%% combine the images
imout1 = cell(pieceHeight,pieceWidth);
imout2 = cell(pieceHeight,pieceWidth);
maxLoop = length(im1)/pieceWidth;
for i = 1:maxLoop
    temp = (i-1)*pieceWidth;
    imout1(i,:) = im1(temp+1:temp+pieceWidth);
    imout2(i,:) = I2_warped(temp+1:temp+pieceWidth);

end
imOutRef = [];
imOutTar = [];
for i = 1:length(imout1(:,1))
    temp1 = [];
    temp2 = [];
    for j = 1:length(imout1(1,:))
        temp1 = horzcat(temp1,imout1{i,j});        
        temp2 = horzcat(temp2,imout2{i,j});

    end
    imOutRef = vertcat(imOutRef,temp1);
    imOutTar = vertcat(imOutTar,temp2);

    temp1 = [];
    temp2 = [];
end
%% evaluation

for i = 1:length(whiteImage)
    whiteImage{i} = Copy_of_affine_warp(whiteImage{i},M{indexOfPatch(i)});
    estimatedTar(i,:) = calPos(whiteImage{i});  
    estimatedTar2(i,:) = Mtest{indexOfPatch(i)}*newTarGT(i,:)';

end
[diffGTAffine,allDisAffine] = evaluation(newRefGT,estimatedTar2);
rmseGTAffine = sqrt(immse(newRefGT,estimatedTar2));
newRefGT(:,3) = [];
[ diffGT, allDis ] = evaluation( newRefGT,estimatedTar );

rmseGT = sqrt(immse(newRefGT,estimatedTar));

[allDisM, diffM,rmseM,test1,test2 ] = evaResult(imOutRef,imOutTar,numOfStrongesrt);
figure;
imshowpair(imOutTar,imOutRef,'falsecolor');