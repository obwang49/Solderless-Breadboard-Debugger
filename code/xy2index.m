% This Function Convert the x,y coordinates to hole index
function [num,char,idx,dist] = xy2index(xy,holes,im,flag)
warning('off','all');
disp('Converting Image Coordinates To Breadboard Indexes...');
[idx, dist] = knnsearch(holes(:,1:2),xy);
charmap = ['+','-','A','B','C','D','E','F','G','H','I','J','+','-'];
if flag==1
    figure(); imagesc(im); hold on;
    plot(holes(idx,1),holes(idx,2),'r+');
end

for i = 1:size(xy,1)
    if dist(i) > 50
        disp(strcat("Error Too Large! ","Index: ",num2str(i)," Dist: ",num2str(dist(i))));
    end
end
char = charmap(holes(idx,3));
num = holes(idx,3:4);
disp(strcat("Successfully Converted ",num2str(size(xy,1))," Indexes !"));
end