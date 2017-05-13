%% Image Pre-processing
% Freshing Begining
clc; clear all; close all;

% Load Raw Image
im_raw = imread('ImgB.JPG');

%% Locate the Holes
holes = locateHoles(im_raw,0);

%% Locate the Wires
wiresXY = locateWires(im_raw,holes,0);
[wiresIdx(:,1:2),~,~,~] = xy2index(wiresXY(:,1:2),holes,im_raw,0);
[wiresIdx(:,3:4),~,~,~] = xy2index(wiresXY(:,3:4),holes,im_raw,0);
wiresMap = ones(size(wiresIdx,1),5);
wiresMap(:,2) = wiresIdx(:,2);
wiresMap(:,3) = wiresIdx(:,1);
wiresMap(:,4) = wiresIdx(:,4);
wiresMap(:,5) = wiresIdx(:,3);

%% Locate the RLCs
RLCsXY = locateRLC(im_raw,holes,0);
[RLCsIdx(:,1:2),~,~,~] = xy2index(RLCsXY(:,1:2),holes,im_raw,0);
[RLCsIdx(:,3:4),~,~,~] = xy2index(RLCsXY(:,3:4),holes,im_raw,0);
RLCsIdx(:,5) = findRvalues(im_raw,RLCsXY,0);

RLCsMap = ones(size(RLCsIdx,1),5);
RLCsMap(:,2) = RLCsIdx(:,2);
RLCsMap(:,3) = RLCsIdx(:,1);
RLCsMap(:,4) = RLCsIdx(:,4);
RLCsMap(:,5) = RLCsIdx(:,3);

for i = 1:size(RLCsMap,1)
    if RLCsIdx(i,5) == 5600
        RLCsMap(i,1) = 2;
    elseif RLCsIdx(i,5) == 623
        RLCsMap(i,1) = 3;
    end
end
clear i
%% Locate the Chips
chipsNames = ["DM7496N";"LT1632";"CD74HCT112E"];
[chips8, chips16, chips8Type, chips16Type, chipsBox] = locateChips(im_raw,holes,chipsNames,0);

chips8Map = chips8(:,[2,1,4,3,6,5,8,7,10,9,12,11,14,13,16,15]);
chips16Map = chips16(:,[2,1,4,3,6,5,8,7,10,9,12,11,14,13,16,15,18,17,20,19,22,21,24,23,26,25,28,27,30,29,32,31]);

%% Show Current Results
figure;imshow(im_raw);hold on;
title('Breadboard XY Location Layout');
if exist('holes','var')
    plot(holes(:,1),holes(:,2),'r+','LineWidth',2);
end
if exist('wiresXY','var')
    plot(wiresXY(:,1),wiresXY(:,2),'yo','LineWidth',2);
    plot(wiresXY(:,3),wiresXY(:,4),'yo','LineWidth',2);
end
if exist('RLCsXY','var')
    plot(RLCsXY(:,1),RLCsXY(:,2),'go','LineWidth',2);
    plot(RLCsXY(:,3),RLCsXY(:,4),'go','LineWidth',2);
end
if exist('chipsBox','var')
    for idx = 1 : size(chipsBox,1)
        rectangle('Position', [min(chipsBox(idx,1),chipsBox(idx,3)) min(chipsBox(idx,2),chipsBox(idx,4)) abs(chipsBox(idx,3)-chipsBox(idx,1)) abs(chipsBox(idx,4)-chipsBox(idx,2))],'EdgeColor','m','LineWidth',2 );
    end
end
hold off;
