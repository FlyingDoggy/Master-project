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

im1 = strcat(dir,folder,'1',imFormat);
im2 = strcat(dir,folder,'2',imFormat);

I1=im2double(imread(im1));
I2=im2double(imread(im2));
numOfStrongesrt = 150;



%% extract matched pairs
[Pos1,Pos2] = extractFeature(I1,I2,numOfStrongesrt);

showImg(I1,I2,Pos1,Pos2);

%% reject outliers
[Pos1,Pos2] = rejectOutlier(Pos1,Pos2,numOfStrongesrt);

showImg(I1,I2,Pos1,Pos2);

%%adding additional matched pairs by randomly generating matched pairs
%%using existing pairs information

% Calculate affine matrix
% diff= mean(Pos2)-mean(Pos1);
% % offset = sqrt(diff(1)^2+diff(2)^2)+5;
% offset = 0;
% imSize = size(I1);
% posX = imSize(1);
% posY = imSize(2);
% additionPair1 = zeros(30,2);
% additionPair2 = zeros(30,2);
% for i = 1:100   
%     additionPair1(i,:) = [offset+rand()*(posX-offset),offset+rand()*(posY-offset)];
%     additionPair2(i,1) =  additionPair1(i,1)+diff(1);
%     additionPair2(i,2) =  additionPair1(i,2)+diff(2);
% end
%% Show both images
% showImg(I1,I2,Pos1,Pos2);
    M2 = fitgeotrans(Pos2, Pos1,'affine');

for i = 1:length(Pos1)
    Pos1(i,3)=1; Pos2(i,3)=1;
end
M=Pos2'/Pos1';
% M = M';
% M(1,3) = 0;
% M(2,3) = 0;
% M(3,3) = 1;
% M2.T = M;

% Add subfunctions to Matlab Search path
functionname='OpenSurf.m';
functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
addpath([functiondir '/WarpFunctions'])

% Warp the image
% I2_warped3=affine_warp(I2,M);
I2_warped3=imwarp(I2,M);

%% Show the result


% figure;
% imshowpair(I1_warped3,I2,'checkerboard');
% 
figure;
imshowpair(I2_warped3,I1,'falsecolor');
% 
% figure;
% imshowpair(I1_warped3,I2,'diff');

[nPos1,nPos2] = extractFeature(I1,I2_warped3,numOfStrongesrt);

[nPos1,nPos2] = rejectOutlier(nPos1,nPos2,numOfStrongesrt);

showImg(I1,I2_warped3,nPos1,nPos2);
diff = evaluation(nPos1,nPos2);
rmse = sqrt(immse(nPos1, nPos2));
%% load gt
formatSpec = '%d %d %d %d %d %d %d %d %d';
xPos = fopen(strcat(dir,folder,'/gtWidth.txt'),'r');
yPos = fopen(strcat(dir,folder,'/gtHeight.txt'),'r');
arraySize = [8 Inf];
allX = fscanf(xPos,formatSpec, arraySize);
allY = fscanf(yPos,formatSpec, arraySize);

gt1(:,2) = allX(:,1);
gt1(:,1) = allY(:,1); 
gt2(:,2) = allX(:,2);
gt2(:,1) = allY(:,2); 

for i = 1:length(gt2)
    gt2(i,3)=1;
end

gt2 = gt2*M';
for i = 1:length(gt2)
gt2(i,1) = gt2(i,1)/gt2(i,3);
gt2(i,2) = gt2(i,2)/gt2(i,3);
end
gt2(:,3) = [];
[diffGT,allDis] = evaluation(gt1,gt2);
rmseGT = sqrt(immse(gt1, gt2));

