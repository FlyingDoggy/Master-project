clc;clear; close all;

% Load images
I1=im2double(imread('Img/land_ref.png'));
I1 = imcrop(I1,[0,70,1800,800]);
I2=im2double(imread('Img/land_tar.png'));
I2 = imcrop(I2,[0,70,1800,800]);
I1g = rgb2gray(I1);
I2g = rgb2gray(I2);

regions1 = detectMSERFeatures(I1g,'RegionAreaRange',[300,200000],'ThresholdDelta',3);
regions2 = detectMSERFeatures(I2g,'RegionAreaRange',[300,200000],'ThresholdDelta',3);
figure; imshow(I1); hold on;
plot(regions1,'showPixelList',true,'showEllipses',false);
plot(regions1);
figure; imshow(I2); hold on;
plot(regions2,'showPixelList',true,'showEllipses',false);
plot(regions2);
Pos1 = regions1.Location;
Pos2 = regions2.Location;
% matrix = zeros(abs(length(Pos1)-length(Pos2)),2);
% 
% if length(Pos1)>length(Pos2)
%     Pos2 = vertcat(Pos2,matrix);
% else
%     Pos1 = vertcat(Pos1,matrix);
% end

    
%  results = rejectMismatch( Pos1,Pos2 );
