clc;clear all;close all;
I1 = imread('landscape_ref.png');
I1 = uint8(rgb2gray(I1)) ;
I2 = imread('landscape_tar.png');
I2 = uint8(rgb2gray(I2)) ;
[r,f] = vl_mser(I1,'MinDiversity',0.7,...
                'MaxVariation',0.2,...
                'Delta',10) ;
f = vl_ertr(f) ;
vl_plotframe(f) ;
M = zeros(size(I1)) ;
for x=r'
 s = vl_erfill(I1,x) ;
 M(s) = M(s) + 1;
end
figure(2) ;
clf ; imagesc(I1) ; hold on ; axis equal off; colormap gray ;
[c,h]=contour(M,(0:max(M(:)))+.5) ;
set(h,'color','y','linewidth',3) ;
% regions1 = detectMSERFeatures(I1);
% figure; imshow(I1); hold on;
% plot(regions1,'showPixelList',true,'showEllipses',false);
% regions2 = detectMSERFeatures(I2);
% figure; imshow(I2); hold on;
% plot(regions2,'showPixelList',true,'showEllipses',false)