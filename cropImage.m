clc;clear all;
s0 = 'habour';
files = dir(strcat('Img/',s0,'/*.png'));
s1 = strcat('Img/',s0,'/');

for file = files'
    I = imread(strcat(s1,file.name));
    I = imcrop(I,[0,0,1800,800]);
    imwrite(I,strcat(s1,file.name));
    % output image size: 1318*808;
end