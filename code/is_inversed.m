function [names, inverse] = is_inversed(chip_img)
% clear;
% clc;
% close all

% name = 'chip*.jpg';
% imagelist = dir(name);
confidence = zeros([1,0]);
% for i = 1:length(imagelist)
%     imgg = imread(imagelist(i).name);
[height, width, channel] = size(chip_img);
%     SE1 = strel('line',20,0);
%     im = imtophat(im,SE1);
% chip_img = imbinarize(chip_img);
[img_label,num] = bwlabel(chip_img,8);
% figure()
% imshow(label2rgb(img_label))
% hold on
names = '';
properties=regionprops(img_label,'BoundingBox','Area');
for k=1:size(properties,1)
    if properties(k).Area < 300 || properties(k).Area > 2000
        continue;
    end
    w = properties(k).BoundingBox(3);
    h = properties(k).BoundingBox(4);
    if h < 10 || w < 10 || w/h>1 || h>0.3*height || w>0.1*width
        continue;
    end
%     rectangle('Position',properties(k).BoundingBox,'EdgeColor','b','LineWidth',2);
    detected = ~chip_img(properties(k).BoundingBox(2):properties(k).BoundingBox(2)+h, properties(k).BoundingBox(1):properties(k).BoundingBox(1)+w);
%     figure()
%     imshow(detected)
    ocrtxt = ocr(detected,'TextLayout','Block','CharacterSet','0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    if ~isempty(ocrtxt.CharacterConfidences)
        confidence(end+1) = ocrtxt.WordConfidences;
        [sortedConf, sortedIndex] = sort(ocrtxt.CharacterConfidences, 'descend');
        indexesNaNsRemoved = sortedIndex( ~isnan(sortedConf) );
        topIndex = indexesNaNsRemoved(1);
        if ocrtxt.CharacterConfidences(topIndex) >= 0.7
            names = strcat(names,ocrtxt.Text(topIndex));
        else
            names = strcat(names,'*');
        end
    else
        names = strcat(names,'*');
        confidence(end+1) = 0;
        continue;
    end
    
%     if ocrtxt.WordConfidences
%         confidence(end+1) = ocrtxt.WordConfidences;
%     else
%         confidence(end+1) = 0;
%     end
        
%         name = 'character/*.jpg';
%         samples = dir(name);
%         for idx = 1:length(samples)
%             true = imread(samples(idx).name);
%             reshape(true, [h,w]);
%                        
%         end
end
% txt{1,end+1} = 'end';
if mean(confidence) > 0.6
    inverse = 0;
else
    inverse = 1;
    chip_img = imrotate(chip_img,180);
    [img_label,num] = bwlabel(chip_img,8);
    names = '';
%     confidence = zeros([1,0]);
    properties=regionprops(img_label,'BoundingBox','Area');
    for k=1:size(properties,1)  
        if properties(k).Area < 300 || properties(k).Area > 2000
            continue;
        end
        w = properties(k).BoundingBox(3);
        h = properties(k).BoundingBox(4);
        if h < 10 || w < 10 || w/h>1 || h>0.3*height || w>0.1*width
            continue;
        end
        detected = ~chip_img(properties(k).BoundingBox(2):properties(k).BoundingBox(2)+h, properties(k).BoundingBox(1):properties(k).BoundingBox(1)+w);
        ocrtxt = ocr(detected,'TextLayout','Block','CharacterSet','0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
        if ~isempty(ocrtxt.CharacterConfidences)
%             confidence(end+1) = ocrtxt.WordConfidences;
            [sortedConf, sortedIndex] = sort(ocrtxt.CharacterConfidences, 'descend');
            indexesNaNsRemoved = sortedIndex( ~isnan(sortedConf) );
            topIndex = indexesNaNsRemoved(1);
            if ocrtxt.CharacterConfidences(topIndex) >= 0.7
                names = strcat(names,ocrtxt.Text(topIndex));
            else
                names = strcat(names,'*');
            end
        else
%             confidence(end+1) = 0;
            continue;
        end
    end

end
%     hold off
%     pause (0.5)
% end

