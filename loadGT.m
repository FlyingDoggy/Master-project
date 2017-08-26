function [gt] = loadGT( dirs,folder,length,format)
files = dir(strcat(dirs,folder,'/*.png'));

%% load gt
formatSpec = format;
xPos = fopen(strcat(dirs,folder,'/gtHeight.txt'),'r');
yPos = fopen(strcat(dirs,folder,'/gtWidth.txt'),'r');
arraySize = [length Inf];
allX = fscanf(xPos,formatSpec, arraySize);
allY = fscanf(yPos,formatSpec, arraySize);
gt = {}; 
i = 1;
for file = files'
gt{i}(:,1) = allX(:,i);
gt{i}(:,2) = allY(:,i); 
gt{i}(:,3) =1; 
% gt{i} = gt{i}';
i = i+1;
end

end

