clc;clear; close all;
run('SetPathLocal.m');
% Load images
I1=im2double(imread('Img/zone_d/85.28_27.696_85.281_27.697_0.jpg'));
% I1 = imcrop(I1,[0,70,1800,800]);
I2=im2double(imread('Img/zone_d/85.28_27.696_85.281_27.697_10.jpg'));
% I2 = imcrop(I2,[0,70,1800,800]);
dir = 'Img/';
folder = 'queens/';
imFormat = '.png';
refI = strcat(dir,folder,'1',imFormat);
tarI = strcat(dir,folder,'5',imFormat);

I1=im2double(imread(refI));
I2=im2double(imread(tarI));
numOfStrongesrt = 150;
piece = 4;
imsize = size(I1);
im1 = {piece};
im2 = {piece};
diff = [];
rmse = [];
parfor  i = 1:piece
    pieceSize = floor(imsize(2)/piece);

    for j = (i-1)*pieceSize+1:(i)*pieceSize-1
        imref(:,mod(j,pieceSize),:) = I1(:,j,:);
        imtar(:,mod(j,pieceSize),:) = I2(:,j,:);
    end
%     for j = (i-1)*imsize(1)/piece+1:(i)*imsize(1)/piece-1
%         imref(mod(j,imsize(1)/piece),:,:) = I1(j,:,:);
%         imtar(mod(j,imsize(1)/piece),:,:) = I2(j,:,:);
%     end
    im1{i} =imref;
    im2{i} = imtar;
    imref = [];
    imtar = [];
end
Pos1 = {piece};
Pos2= {piece};
nPos1 = {piece};
nPos2= {piece};
M ={piece};

M2 = {piece};
I2_warped = {piece};
I2_warped2 = {piece};
allDis = {piece};
diffm = (piece);
rmsem = (piece);
diffm2 = (piece);
rmsem2 = (piece);
parfor i = 1:piece
    i
    [Pos1{i},Pos2{i}] = extractFeature(im1{i},im2{i},numOfStrongesrt);
    
    %     showImg(im1{i},im2{i},Pos1{i},Pos2{i});
    
    %% reject outliers
    [Pos1{i},Pos2{i}] = rejectOutlier(Pos1{i},Pos2{i},numOfStrongesrt);
    
    showImg(im1{i},im2{i},Pos1{i},Pos2{i});
    M2{i} = fitgeotrans(Pos2{i}, Pos1{i},'affine');
    
    for j = 1:length(Pos1{i})
        Pos1{i}(j,3)=1; Pos2{i}(j,3)=1;
    end
    M{i}=Pos2{i}'/Pos1{i}';
    % Add subfunctions to Matlab Search path
    functionname='OpenSurf.m';
    functiondir=which(functionname);
    functiondir=functiondir(1:end-length(functionname));
    addpath([functiondir '/WarpFunctions'])
    % Warp the image
    I2_warped{i}=affine_warp(im2{i},M{i},3);
    I2_warped2{i}=affine_warp(im2{i},M2{i}.T,3);
    
    %% Show the result
    
    
    % figure;
    % imshowpair(I1_warped3,I2,'checkerboard');
    %
    %     figure;
    %     imshowpair(I2_warped{i},im1{i},'falsecolor');
    %
    % figure;
    % imshowpair(I1_warped3,I2,'diff');
    
    [ allDis{i},diffm(i),rmsem(i) ] = evaResult(im1{i},I2_warped{i},numOfStrongesrt);
    [~, diffm2(i),rmsem2(i) ] = evaResult(im1{i},I2_warped2{i},numOfStrongesrt);
    
    
end
imOutRef = [];
imOutTar = [];
imOutTar2 = [];
imOriTar = [];
for i = 1:piece
    imOutRef = horzcat(imOutRef,im1{i});
    imOutTar = horzcat(imOutTar,I2_warped{i});
    imOutTar2 = horzcat(imOutTar2,I2_warped2{i});
    imOriTar = horzcat(imOriTar,im2{i});
%     
%     imOutRef = vertcatsp,im1{i});
%     imOutTar = vertcat(imOutTar,I2_warped{i});
%     imOutTar2 = vertcat(imOutTar2,I2_warped2{i});
end
[initDis,initDiff,initRMSE,gt1,gt2] = evaResult(imOutRef,imOriTar,numOfStrongesrt);

[allDisM, diffM,rmseM,test1,test2 ] = evaResult(imOutRef,imOutTar,numOfStrongesrt);
% [ diffM2,rmseM2 ] = evaResult(imOutRef,imOutTar2,numOfStrongesrt);
figure;
imshowpair(imOutTar,imOutRef,'falsecolor');
% figure;
% imshowpair(imOutTar2,imOutRef,'falsecolor');

