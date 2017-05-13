% This Function Find all the wire sections in the Figure
% Input is the image and flag
% Output is the wire endpoint locations
function wires = locateWires(im,holes,flag)

warning('off','all');
disp('Locating the Wires on the Breadboard...');
%% Preprocessing Section: Take the Raw Image, Filter and Crop

% Convert to Gray Scale
im_gray = rgb2gray(im);
% Create BW Image using adaptive localization: https://www.mathworks.com/help/images/ref/imbinarize.html
im_bit = imbinarize(im_gray, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.5);
im_bw = uint8(im_bit*255);
mask = im_bit&0;
mask(min(holes(:,2)):max(holes(:,2)),min(holes(:,1)):max(holes(:,1))) = mask(min(holes(:,2)):max(holes(:,2)),min(holes(:,1)):max(holes(:,1)))+1;
im_bit = (~im_bit)&mask;
im_bwf = bwareafilt(im_bit,100);
im_bwf = bwareafilt(im_bwf,[2000,1000000]);

% Start Cutting Upper Part
boundUx = [holes(421,1),holes(455,1)];
boundUy = [holes(421,2)+40, holes(455,2)+40];
boundLx = [holes(421,1), holes(455,1)];
boundLy = [(holes(421,2)+holes(386,2))/2, (holes(455,2)+holes(420,2))/2];

% Scan Through Upper Region
for col = round(max(boundLx(1),boundUx(1))+1):round(min(boundLx(2),boundUx(2))-1)
    rowUp = round(interp1(boundUx,boundUy,col));
    rowLow = round(interp1(boundLx,boundLy,col));
    if sum(im_bwf(rowUp:rowLow,col))<30
        im_bwf(rowUp:rowLow,col) = 0;
    end
end

% Start Cutting Lower Part
boundUx = [holes(71,1), holes(105,1)];
boundUy = [(holes(36,2)+holes(71,2))/2-100, (holes(70,2)+holes(105,2))/2-100];
boundLx = [holes(36,1),holes(70,1)];
boundLy = [holes(36,2)-40, holes(70,2)-40];

% Scan Through Lower Region
for col = round(max(boundLx(1),boundUx(1))+1):round(min(boundLx(2),boundUx(2))-1)
    rowUp = round(interp1(boundUx,boundUy,col));
    rowLow = round(interp1(boundLx,boundLy,col));
    if sum(im_bwf(rowUp:rowLow,col))<50
        im_bwf(rowUp:rowLow,col) = 0;
    end
end

% Some Further Filtering
im_bwf = bwareafilt(im_bwf,[10000,1000000]);
% Fill the Bounded Areas
im_bwf = imfill(im_bwf,'holes');
if flag == 1
    figure; imshowpair(im_bw, im_bwf, 'montage');
    title('Area Filtered Image for Wires');
end
%% Wire Locating Section
% Label the Connected Components
im_label = bwlabel(im_bwf);
im_perim = bwlabel(bwperim(im_label));

% Number of Connected Regions
itemNum = max(max(im_label));
% Extrac Information
areastats = regionprops(logical(im_label),'Centroid','MajorAxisLength','Area','Perimeter','Orientation');
boundary = regionprops(logical(im_perim),'PixelList');
wires = zeros(0,4);
for idx = 1:itemNum
    % Check Rough Shape
    if areastats(idx).Area/areastats(idx).Perimeter > 30
        continue
    end
    % Check Rough Length
    if areastats(idx).MajorAxisLength < 400
        continue
    end
    % Considered as Wire and Get Index
    bounds =  boundary(idx).PixelList - areastats(idx).Centroid;
    % Compute Dot Prodect
    project = bounds(:,1) - bounds(:,2).*tan(areastats(idx).Orientation/180*pi );
    % Get Largest and Smallest
    [~,maxidx] = max(project);
    [~,minidx] = min(project);
    % Store x,y Location
    wires(end+1,1) = boundary(idx).PixelList(maxidx,1);
    wires(end,2) = boundary(idx).PixelList(maxidx,2);
    wires(end,3) = boundary(idx).PixelList(minidx,1);
    wires(end,4) = boundary(idx).PixelList(minidx,2);
end
if flag == 1
    figure;imagesc(im);hold on;
    plot(wires(:,1),wires(:,2),'r+');
    plot(wires(:,3),wires(:,4),'r+');
    title('Breadboard Wires Endpoint Locations');
end
disp(strcat("Successfully Located ",num2str(size(wires,1))," Wires !"));
end