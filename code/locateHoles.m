% This function detect the holes on the breadboard.
% Input: Im is the rgb image; Flag is the flag indicating showing figure
% Output: holes [x,y,1~14,1~35]

function holes = locateHoles(im,flag)

warning('off','all');
disp('Locating the Holes on the Breadboard...');
% Preprocessing Section: Take the Raw Image, Rotate, Convert to Gray Scale and Bitmap Images
im_smooth = imgaussfilt(im,1);
% Rotate to Correct Angle
im_rot = imrotate(im_smooth, -90);
% Convert to Gray Scale
im_gray = rgb2gray(im_rot);
% Create BW Image using adaptive localization: https://www.mathworks.com/help/images/ref/imbinarize.html
im_bit = imbinarize(im_gray, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.45);
im_bw = uint8(im_bit*255);
% Keep the Largest 1000 connected components
im_bwf = bwareafilt(~im_bit,900);

% Show Step result
if flag==1
    figure; imshowpair(im_rot, im_bwf, 'montage'); title('Rotated and Black White Image');
end

%% Target Text Localization Section: Finding Text 'A' 'E' 'F' 'J'

% Locate the Raw
markerChar = ['A','E','F','J'];
boxTopChar = zeros(4,4);
boxBotChar = zeros(4,4);

% Further Filtering
im_bwft = bwareafilt(im_bwf,[300,3500]);
if flag==1
    figure; imshowpair(im_rot, im_bwft, 'montage'); title('Rotated and Filtered Black White Image');
end


% Loop through Each Marker
for idx = 1:4
    
    marker = markerChar(idx);
    % Perform OCR over Identifier: https://www.mathworks.com/help/vision/examples/recognize-text-using-optical-character-recognition-ocr.html
    ocr_raw = ocr(im_bwft,[1,5,size(im_bwft,2),size(im_bwft,1)/6], 'TextLayout', 'Block', 'CharacterSet', marker);
    % Confidence Value
    [confSort, confIdx] = sort(ocr_raw.CharacterConfidences, 'descend');
    % Keep indices associated with non-NaN confidences values
    topIdx = confIdx( ~isnan(confSort) );
    % Save Result
    boxTopChar(idx,:) = ocr_raw.CharacterBoundingBoxes(topIdx(1), :);
    % Lower Part
    ocr_raw = ocr(im_bwft,[1,size(im_bwft,1)*5/6,size(im_bwft,2),size(im_bwft,1)/6-5], 'TextLayout', 'Block', 'CharacterSet', marker);
    [confSort, confIdx] = sort(ocr_raw.CharacterConfidences, 'descend');
    topIdx = confIdx( ~isnan(confSort) );
    boxBotChar(idx,:) = ocr_raw.CharacterBoundingBoxes(topIdx(1), :);  
end

% Calculate Text Marker Location
textTop = zeros(4,2); textBot = zeros(4,2);
textTop(:,1) = boxTopChar(:,1) + boxTopChar(:,3)./2;
textTop(:,2) = boxTopChar(:,2) + boxTopChar(:,4)./2;
textBot(:,1) = boxBotChar(:,1) + boxBotChar(:,3)./2;
textBot(:,2) = boxBotChar(:,2) + boxBotChar(:,4)./2;
% Show Boxes
if flag == 1
    confBox = insertObjectAnnotation(im_bw, 'rectangle', [boxTopChar; boxBotChar], cellstr(['A';'E';'F';'J';'A';'E';'F';'J']));
    figure; imshow(confBox); hold on; plot(textTop(:,1),textTop(:,2),'r+','LineWidth',2); plot(textBot(:,1),textBot(:,2),'r+','LineWidth',2);
    title('Marker Location');
end

%% Detect Number Marker Around the Text Region: Find '1' '35'

% Store Marker Location
numTL = zeros(1,2); numTR = zeros(1,2);
numBL = zeros(1,2); numBR = zeros(1,2);

% Top Left '1'
roi = [textTop(1,1)-100,textTop(1,2),100,150];
ocr_raw = ocr(im_bwft, roi, 'TextLayout', 'Block', 'CharacterSet', '1');
[confSort, confIdx] = sort(ocr_raw.CharacterConfidences, 'descend');
topIdx = confIdx( ~isnan(confSort) );
numTL(1,1) = ocr_raw.CharacterBoundingBoxes(topIdx(1),1)+ocr_raw.CharacterBoundingBoxes(topIdx(1),3)/2;
numTL(1,2) = ocr_raw.CharacterBoundingBoxes(topIdx(1),2)+ocr_raw.CharacterBoundingBoxes(topIdx(1),4)/2;

% Top Right '1'
roi = [textTop(4,1)+20,textTop(4,2),100,150];
ocr_raw = ocr(im_bwft, roi, 'TextLayout', 'Block', 'CharacterSet', '1');
[confSort, confIdx] = sort(ocr_raw.CharacterConfidences, 'descend');
topIdx = confIdx( ~isnan(confSort) );
numTR(1,1) = ocr_raw.CharacterBoundingBoxes(topIdx(1),1)+ocr_raw.CharacterBoundingBoxes(topIdx(1),3)/2;
numTR(1,2) = ocr_raw.CharacterBoundingBoxes(topIdx(1),2)+ocr_raw.CharacterBoundingBoxes(topIdx(1),4)/2;

% Bottom Left '5'
roi = [textBot(1,1)-100,textBot(1,2)-150,100,150];
ocr_raw = ocr(im_bwft, roi, 'TextLayout', 'Block', 'CharacterSet', '5');
[confSort, confIdx] = sort(ocr_raw.CharacterConfidences, 'descend');
topIdx = confIdx( ~isnan(confSort) );
numBL(1,1) = ocr_raw.CharacterBoundingBoxes(topIdx(1),1)+ocr_raw.CharacterBoundingBoxes(topIdx(1),3)/2;
numBL(1,2) = ocr_raw.CharacterBoundingBoxes(topIdx(1),2)+ocr_raw.CharacterBoundingBoxes(topIdx(1),4)/2;

% Bottom Right '5'
roi = [textBot(4,1)+20,textBot(4,2)-150,100,150];
ocr_raw = ocr(im_bwft, roi, 'TextLayout', 'Block', 'CharacterSet', '5');
[confSort, confIdx] = sort(ocr_raw.CharacterConfidences, 'descend');
topIdx = confIdx( ~isnan(confSort) );
numBR(1,1) = ocr_raw.CharacterBoundingBoxes(topIdx(1),1)+ocr_raw.CharacterBoundingBoxes(topIdx(1),3)/2;
numBR(1,2) = ocr_raw.CharacterBoundingBoxes(topIdx(1),2)+ocr_raw.CharacterBoundingBoxes(topIdx(1),4)/2;

if flag == 1
    plot(numTL(1,1),numTL(1,2),'r+','LineWidth',2); plot(numTR(1,1),numTR(1,2),'r+','LineWidth',2);
    plot(numBL(1,1),numBL(1,2),'r+','LineWidth',2); plot(numBR(1,1),numBR(1,2),'r+','LineWidth',2);
end
%% Sign Marker Detection: Find '+' and '-'

% Store Sign Marker Location
vpTL = [0, 0]; vpTR = [0,0]; vpBL = [0, 0]; vpBR = [0, 0];

% Top Left '+'
roi = [1,1, numTL(1,1)-20,numTL(1,2)];
ocr_raw = ocr(im_bwft, roi, 'TextLayout', 'Block', 'CharacterSet', '+');
[confSort, confIdx] = sort(ocr_raw.CharacterConfidences, 'descend');
topIdx = confIdx( ~isnan(confSort) );
vpTL(1,1) = ocr_raw.CharacterBoundingBoxes(topIdx(1),1)+ocr_raw.CharacterBoundingBoxes(topIdx(1),3)/2;
vpTL(1,2) = ocr_raw.CharacterBoundingBoxes(topIdx(1),2)+ocr_raw.CharacterBoundingBoxes(topIdx(1),4)/2;

% Top Right '+'
roi = [numTR(1,1)+20,1, size(im_bwf,2)-numTR(1,1)-20,numTR(1,2)];
ocr_raw = ocr(im_bwft, roi, 'TextLayout', 'Block', 'CharacterSet', '+');
[confSort, confIdx] = sort(ocr_raw.CharacterConfidences, 'descend');
topIdx = confIdx( ~isnan(confSort) );
vpTR(1,1) = ocr_raw.CharacterBoundingBoxes(topIdx(1),1)+ocr_raw.CharacterBoundingBoxes(topIdx(1),3)/2;
vpTR(1,2) = ocr_raw.CharacterBoundingBoxes(topIdx(1),2)+ocr_raw.CharacterBoundingBoxes(topIdx(1),4)/2;

% Bot Left '+'
roi = [1,numBL(1,2), numBL(1,1)-20,size(im_bwf,1)-numBL(1,2)];
ocr_raw = ocr(im_bwft, roi, 'TextLayout', 'Block', 'CharacterSet', '+');
[confSort, confIdx] = sort(ocr_raw.CharacterConfidences, 'descend');
topIdx = confIdx( ~isnan(confSort) );
vpBL(1,1) = ocr_raw.CharacterBoundingBoxes(topIdx(1),1)+ocr_raw.CharacterBoundingBoxes(topIdx(1),3)/2;
vpBL(1,2) = ocr_raw.CharacterBoundingBoxes(topIdx(1),2)+ocr_raw.CharacterBoundingBoxes(topIdx(1),4)/2;

% Bot Right '+'
roi = [numBR(1,1)+25,numBR(1,2)+20, 100,100];
ocr_raw = ocr(im_bwft, roi, 'TextLayout', 'Block', 'CharacterSet', '+');
[confSort, confIdx] = sort(ocr_raw.CharacterConfidences, 'descend');
topIdx = confIdx( ~isnan(confSort) );
vpBR(1,1) = ocr_raw.CharacterBoundingBoxes(topIdx(1),1)+ocr_raw.CharacterBoundingBoxes(topIdx(1),3)/2;
vpBR(1,2) = ocr_raw.CharacterBoundingBoxes(topIdx(1),2)+ocr_raw.CharacterBoundingBoxes(topIdx(1),4)/2;

if flag == 1
    plot(vpTL(1,1),vpTL(1,2),'r+'); plot(vpTR(1,1),vpTR(1,2),'r+','LineWidth',2);
    plot(vpBL(1,1),vpBL(1,2),'r+'); plot(vpBR(1,1),vpBR(1,2),'r+','LineWidth',2);
end

%% Detect Pin Holes Locations: Find Rough Holes Location

% Segment Image For Hole Characters
[centers, ~, ~] = imfindcircles(im_bwft,[15,30],'Sensitivity',0.85);
if flag == 1
    plot(centers(:,1),centers(:,2),'r+','LineWidth',2);
end

%% Find Corner Holes Coordinates
% Estimated Coordinates of the Corner Holes
holeTA = [textTop(1,1), numTL(1,2)]; holeTJ = [textTop(4,1), numTR(1,2)];
holeBA = [textBot(1,1), numBL(1,2)]; holeBJ = [textBot(4,1), numBR(1,2)];
holeTLP = [vpTL(1,1), numTL(1,2)]; holeTRP = [vpTR(1,1), numTR(1,2)]; 
holeBLP = [vpBL(1,1), numBL(1,2)]; holeBRP = [vpBR(1,1), numBR(1,2)]; 
holeTLM = [(vpTL(1,1)+numTL(1,1))/2, numTL(1,2)]; holeTRM = [2*vpTR(1,1)-textTop(4,1), numTR(1,2)]; 
holeBLM = [(vpBL(1,1)+numBL(1,1))/2, numBL(1,2)]; holeBRM = [2*vpBR(1,1)-textBot(4,1), numBR(1,2)]; 

% Calculate Nearest Neighbour
holes = [holeTA; holeTJ; holeBA; holeBJ; holeTLP; holeTRP; holeBLP; holeBRP; holeTLM; holeTRM; holeBLM; holeBRM];
idx = knnsearch(centers, holes);

holeTA = centers(idx(1),:); holeTJ = centers(idx(2),:);
holeBA = centers(idx(3),:); holeBJ = centers(idx(4),:);
holeTLP = centers(idx(5),:); holeTRP = centers(idx(6),:);
holeBLP = centers(idx(7),:); holeBRP = centers(idx(8),:);
holeTLM = centers(idx(9),:); holeTRM = centers(idx(10),:);
holeBLM = centers(idx(11),:); holeBRM = centers(idx(12),:);

% Find TopE ,TopF, BotE, BotF
holeTE = [textTop(2,1),0]; holeTF = [textTop(3,1),0];
holeTE(1,2)= interp1([holeTA(1), holeTJ(1)],[holeTA(2), holeTJ(2)],textTop(2,1));
holeTF(1,2)= interp1([holeTA(1), holeTJ(1)],[holeTA(2), holeTJ(2)],textTop(3,1));
holeBE = [textBot(2,1),0]; holeBF = [textBot(3,1),0];
holeBE(1,2)= interp1([holeBA(1), holeBJ(1)],[holeBA(2), holeBJ(2)],textBot(2,1));
holeBF(1,2)= interp1([holeBA(1), holeBJ(1)],[holeBA(2), holeBJ(2)],textBot(3,1));

if flag == 1
    plot(holeTA(1),holeTA(2),'r+'); plot(holeTJ(1),holeTJ(2),'r+','LineWidth',2);
    plot(holeBA(1),holeBA(2),'r+'); plot(holeBJ(1),holeBJ(2),'r+','LineWidth',2);
    plot(holeTLP(1),holeTLP(2),'r+'); plot(holeBLP(1),holeBLP(2),'r+','LineWidth',2);
    plot(holeTRP(1),holeTRP(2),'r+'); plot(holeBRP(1),holeBRP(2),'r+','LineWidth',2);
    plot(holeTLM(1),holeTLM(2),'r+'); plot(holeBLM(1),holeBLM(2),'r+','LineWidth',2);
    plot(holeTRM(1),holeTRM(2),'r+'); plot(holeBRM(1),holeBRM(2),'r+','LineWidth',2);
    plot(holeTE(1),holeTE(2),'r+'); plot(holeTF(1),holeTF(2),'r+','LineWidth',2);
    plot(holeBE(1),holeBE(2),'r+'); plot(holeBF(1),holeBF(2),'r+','LineWidth',2);
end
%% Generating the Grid

% Top and Bot Coordin
holeT = zeros(2,14);
holeB = zeros(2,14);
holeT(1,:) = [holeTLP(1,1), holeTLM(1,1), linspace(holeTA(1,1),holeTE(1,1),5),linspace(holeTF(1,1),holeTJ(1,1),5), holeTRP(1,1), holeTRM(1,1)];
holeT(2,:) = [holeTLP(1,2), holeTLM(1,2), linspace(holeTA(1,2),holeTE(1,2),5),linspace(holeTF(1,2),holeTJ(1,2),5), holeTRP(1,2), holeTRM(1,2)];
holeB(1,:) = [holeBLP(1,1), holeBLM(1,1), linspace(holeBA(1,1),holeBE(1,1),5),linspace(holeBF(1,1),holeBJ(1,1),5), holeBRP(1,1), holeBRM(1,1)];
holeB(2,:) = [holeBLP(1,2), holeBLM(1,2), linspace(holeBA(1,2),holeBE(1,2),5),linspace(holeBF(1,2),holeBJ(1,2),5), holeBRP(1,2), holeBRM(1,2)];

% Holes: 490 rows, 4 cols [x, y, 1~14, 1~35];
holes = zeros(14*35,4);
for idx = 1:14
    holes(idx*35-34:idx*35,1) = linspace(holeT(1,idx),holeB(1,idx),35);
    holes(idx*35-34:idx*35,2) = linspace(holeT(2,idx),holeB(2,idx),35);
    holes(idx*35-34:idx*35,3) = idx * ones(35,1);
    holes(idx*35-34:idx*35,4) = linspace(1,35,35);
end

% Rotate Back to Original Frame
temp = holes(:,1:2);
holes(:,1) = temp(:,2);
holes(:,2) = size(im,1) - temp(:,1);

if flag == 1
    figure;imagesc(im);hold on;
    plot(holes(:,1),holes(:,2),'r+');
    title('Breadboard Holes Locations');
end
disp(strcat("Successfully Located ",num2str(size(holes,1))," Holes !"));
end