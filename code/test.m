%% Image Pre-processing
% Freshing Begining
clc; clear all; close all;

% Load Raw Image
im_raw = imread('5.JPG');

% Locate the Holes
holes = locateHoles(im_raw,0);

%% Function to Convert (X,Y) to (1~35,1~14)
figure();
imagesc(im_raw);
title('Convert Coordinate to Index');
hold on;
while(1)
    [x,y,button] = ginput(1);
    if button ~= 1
        break
    end
    [num,char,idx,dist] = xy2index([x,y],holes,0);
    if num ~= -1
        disp(strcat(char,'; ',num2str(num(2))));
        plot(holes(idx,1),holes(idx,2),'r+');
    end
end
clear x y button char num idx


