function RLCs = locateRLC(im,holes,flag)
warning('off','all');
disp('Locating the RLCs on the Breadboard...');
if flag == 1
imgR = im2double(rgb2gray(imread('blueRR.png')));
bwR = imgR > 0.6;
szR = size(imgR); %%%%[h,w]
bwR = (bwR == 0);
[BR,LR] = bwboundaries(bwR,'noholes');
end
%bwR = imbinarize(imgR,'adaptive','ForegroundPolarity','dark','Sensitivity',0.3);
%img = imread('board.png');
img = im2double(rgb2gray(im));
%bw = img > 0.6;
bw = imbinarize(img, 'adaptive','ForegroundPolarity', 'dark', 'Sensitivity',0.5);
%img = imbinarize(img,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);
sz = size(img);

bw = (bw == 0);
mask = bw&0;
mask(min(holes(:,2)):max(holes(:,2)),min(holes(:,1)):max(holes(:,1))) = mask(min(holes(:,2)):max(holes(:,2)),min(holes(:,1)):max(holes(:,1)))+1;
bw = bw&mask;
[B,L] = bwboundaries(bw,'noholes');
% imshow(label2rgb(LR, @jet, [.5 .5 .5]));
% imshow(label2rgb(L, @jet, [.5 .5 .5]));
if flag == 1
figure(1);
imshow(bwR,[]);
hold on;
for k = 1:length(BR)
   boundary = BR{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end
figure(2);
imshow(bw,[]);
hold on;
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end
end

area = zeros(sz);
%z = numel(B{2,1}(:,1)); %%%% multiindexing
%areaR = zeros(szR);
if flag == 1
    zR = numel(BR{2,1}(:,1));
else
    zR = 215;
end

%bw(B{1,1}) = 0;
num = numel(B);
id = 0;
for i = 1:num
    if numel(B{i,1}(:,1)) > 4*(zR-50) && numel(B{i,1}(:,1)) < 4*(zR+100)
        id = id + 1;
        for idx = 1:numel(B{i,1}(:,1))
            pos_x = B{i,1}(idx,1);
            pos_y = B{i,1}(idx,2);
            area(pos_x, pos_y) = 1;
%             Res{id,1}(idx,1) = pos_x;
%             Res{id,1}(idx,2) = pos_y;
        end
    end
end
areafull = imfill(area, 'holes');
%areafull = (areafull == 0);
arealabel = bwlabel(areafull);

%[r,c] = find(arealabel == 8);
% areadata = regionprops('table',arealabel, 'Centroid', 'MajorAxisLength',...
%                         'MinorAxisLength', 'Orientation', 'PixelList');
areadata = regionprops('table',arealabel,'MinorAxisLength','PixelList');
if flag == 1
figure(3);
imshow(areafull,[]);
end
% amt = numel(Res);
areanew = areafull;
%test = numel(areadata.PixelList{8,1}(:,1));
ix = 0;
for i = 1:id
    if areadata.MinorAxisLength(i) < 80
        ix = ix + 1;
        for idx = 1:numel(areadata.PixelList{i,1}(:,1))
        xpos = areadata.PixelList{i,1}(idx,1); %Pixellist outputs [w,h]
        ypos = areadata.PixelList{i,1}(idx,2);
        areanew(ypos, xpos) = 0;
%         Resup{ix,1}(idx,1) = xpos;
%         Resup{ix,1}(idx,2) = ypos;
        end
    end
end
if flag == 1
figure(4);
imshow(areanew,[]);
end
areanewlabel = bwlabel(areanew);
%[r,c] = find(arealabel == 7);
areanewdata = regionprops('table',areanewlabel, 'Centroid', 'MajorAxisLength',...
                        'MinorAxisLength', 'Orientation', 'PixelList');
%x = areanewdata.Centroid(
%mark = insertMarker(areanew,areanewdata.Centroid(1));
% x = areanewdata.Centroid(3);
% y = areanewdata.Centroid(10);
% hold on; % Prevent image from being blown away.
% plot(x,y,'r+', 'MarkerSize', 10);
amtup = id - ix;
topholes = zeros(amtup,2);
botholes = zeros(amtup,2);
for i = 1:amtup
%     if i ~= 3
%         continue;
%     end
    xcen = areanewdata.Centroid(i);
    ycen = areanewdata.Centroid(i+amtup);
    a = areanewdata.MajorAxisLength(i)/2;
    b = areanewdata.MinorAxisLength(i)/2;
    theta = pi*areanewdata.Orientation(i)/180;
    if theta >= 0
       topholes(i,1) = xcen + a*cos(theta);
       topholes(i,2) = ycen - a*sin(theta);
       botholes(i,1) = xcen - a*cos(theta);
       botholes(i,2) = ycen + a*sin(theta);
    else
       topholes(i,1) = xcen - a*cos(theta);
       topholes(i,2) = ycen + a*sin(theta);
       botholes(i,1) = xcen + a*cos(theta);
       botholes(i,2) = ycen - a*sin(theta);
    end
    
    [idx,~] = knnsearch(areanewdata.PixelList{i},[topholes(i,1:2);botholes(i,1:2)]);
    
    topholes(i,1:2) = areanewdata.PixelList{i}(idx(1),1:2);
    botholes(i,1:2) = areanewdata.PixelList{i}(idx(2),1:2);
end

if flag == 1
figure(5);
imshow(im);
hold on;
for i = 1:amtup
    plot(topholes(i,1),topholes(i,2),'r+', 'MarkerSize', 10);
    plot(botholes(i,1),botholes(i,2),'r+', 'MarkerSize', 10);
end
end

RLCs = [topholes botholes];
disp(strcat("Successfully Located ",num2str(size(RLCs,1))," RLCs !"));
end