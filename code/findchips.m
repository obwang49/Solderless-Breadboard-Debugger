function chips = findchips(im,flag) 
% clear;
% clc;
% close all

% im = imread('test.jpg');
[height, width, channel] = size(im);

if channel > 1
	img_gray = im(:,:,2);
else
	% It's already a gray scale image.
	img_gray = im;
end
% img_gray = rgb2gray(im);
img_smooth = medfilt2(img_gray);
img_smooth = wiener2(img_smooth, [5,5]);
%img_contrast = histeq(img_smooth);
% img_binary = imbinarize(img_gray,'adaptive','ForegroundPolarity','dark','Sensitivity',0.2);
img_binary = img_gray > 120;
if flag == 1
figure(1)
imshow(img_binary)
title('processed binary image')
end
img_crop = imbinarize(img_smooth,'adaptive','ForegroundPolarity','dark','Sensitivity',0.2);

img_binary = bwareaopen(~img_binary,800);
img_binary = bwareaopen(~img_binary,400);
% SE1=strel('line',10,90); 
% SE2=strel('rectangle',[20 20]);
% SE3=strel('rectangle',[30 30]);
% img_binary=imdilate(img_binary,SE1);
% img_binary=imdilate(img_binary,SE2);
% img_binary=imerode(img_binary,SE3);
img_lol = imfill(~img_binary,'holes');
img_binary = ~img_lol;
SE=strel('rectangle',[80 80]);
img_binary=imclose(img_binary,SE);

[img_label,num] = bwlabel(~img_binary,8);
% h_mask = fspecial('sobel');
% img_edge = imfilter(img_binary, h_mask');
% figure(4)
% imshow(label2rgb(img_label));

% ref: https://www.mathworks.com/matlabcentral/answers/uploaded_files/8433/shape_recognition.m
stats = regionprops(img_label, 'Perimeter','Area','Perimeter','FilledArea', 'Centroid','BoundingBox');

% perimeters = [stats.Perimeter];
% areas = [stats.Area];
% filledAreas = [stats.FilledArea];
% solidities = [stats.Solidity];
% ratio = perimeters .^2 ./ (4 * pi * areas);
if flag == 1
figure(2)
imshow(label2rgb(img_label));
title('labeled image')

figure(3)
imshow(im)
title('detected image')
hold on;
end

shape = zeros([1,num]);
chips = zeros([5,0]);
for idx = 1 : num
	% Outline the object so the user can see it.
	% Determine the shape.
% 	if circularities(idx) < 1.2
% 		shape(idx) = 0;%'circle';
% 	elseif circularities(idx) < 1.6
% 		shape(idx) = 1;%'square';
%         rectangle('Position',stats(idx).BoundingBox)
% 	elseif circularities(idx) > 1.6 && circularities(idx) < 1.8
% 		shape(idx) = 2;%'triangle';
%     else
% 		shape(idx) = 3;%'something else';
%     end
%     if (areas(idx)>2000) & (ratio(idx)<1.7)
%         shape(idx) = 1;
%         rectangle('Position',stats(idx).BoundingBox);
%     end
    w = stats(idx).BoundingBox(3);
    h = stats(idx).BoundingBox(4);
    if w/h <=10 || h/w <= 10 
        diffArea = abs( stats(idx).FilledArea-w*h );
        ratio = diffArea / stats(idx).Area;
        if ratio < 0.2 && stats(idx).FilledArea>20000 && w/h>1 %&& stats(idx).FilledArea > 10000
            shape(idx) = 1;
            if flag == 1
            rectangle('Position',stats(idx).BoundingBox,'EdgeColor','r'); hold on;
            plot(stats(idx).BoundingBox(1)+w/2,stats(idx).BoundingBox(2),'+');
            plot(stats(idx).BoundingBox(1)+w/2,stats(idx).BoundingBox(2)+h,'+'); hold on;
            end
            newcut = img_crop(stats(idx).BoundingBox(2):stats(idx).BoundingBox(2)+h, stats(idx).BoundingBox(1):stats(idx).BoundingBox(1)+w);
            [names, flag] = is_inversed(newcut);
            if flag == 0 % not inversed
                chips(1:4,end+1) = [stats(idx).BoundingBox(1),stats(idx).BoundingBox(2)+h,stats(idx).BoundingBox(1)+w,stats(idx).BoundingBox(2)]';
            elseif flag == 1
                chips(1:4,end+1) = [stats(idx).BoundingBox(1)+w,stats(idx).BoundingBox(2),stats(idx).BoundingBox(1),stats(idx).BoundingBox(2)+h]';
            end
            
            % Check For Chip Type
            if strfind(names,'LC') > 0
                chips(5,end) = 2;
            elseif strfind(names,'H5CCTE1K12EE') > 0
                chips(5,end) = 3;
            else
                chips(5,end) = 1;
            end
%             filename = strcat('chip',int2str(idx),'.jpg');
%             imwrite(newcut,filename);
        end     
    end
end

chips = chips';
%% straight line detection
% h_mask = fspecial('sobel');
% img_edge = imfilter(img_binary, h_mask');
% img_edge = edge(img_binary,'canny');
% [H,theta,rho]=hough(img_edge);                                    
% P=houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
% lines=houghlines(img_edge,theta,rho,P,'FillGap',50,'MinLength',100);
% figure(4)
% imshow(img_binary);
% title('straight line detection')
% hold on
% for i=1:length(lines)
%     plot([lines(i).point1(1), lines(i).point2(1)],[lines(i).point1(2), lines(i).point2(2)],'-o');
% end

% idx_all = find(shape==1);
% mask = ones(size(img_binary));
% for k = 1:length(idx_all)
%     mask_new = (img_label == idx_all(k));
%     mask = imoverlay(mask, mask_new,'red');
% end
% figure(4)
% imshow(mask,[0,255])
% title('mask image')

end
