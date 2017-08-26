clc;clear; close all;
run('SetPathLocal.m');
path = 'habour';
I1=im2double(imread('Img/habour/1.png'));
I2=im2double(imread('Img/habour/2.png'));
formatSpec = '%d %d %d %d %d %d %d %d %d';
xPos = fopen(strcat('Img/',path,'/gtWidth.txt'),'r');
yPos = fopen(strcat('Img/',path,'/gtHeight.txt'),'r');
arraySize = [9 Inf];
allX = fscanf(xPos,formatSpec, arraySize);
allY = fscanf(yPos,formatSpec, arraySize);

Pos1(:,2) = allX(:,1);
Pos1(:,1) = allY(:,1); 
Pos2(:,2) = allX(:,2);
Pos2(:,1) = allY(:,2); 

for i = 1:length(Pos1)
    Pos1(i,3)=1; Pos2(i,3)=1;
end
M=Pos2'/Pos1';
functionname='OpenSurf.m';
functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
addpath([functiondir '/WarpFunctions'])

% Warp the image
I2_warped3=affine_warp(I2,M,3);

    

