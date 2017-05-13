function [chips8, chips16, chips8Type, chips16Type,chips] = locateChips(im,holes,nameMaps,flag)

chips = findchips(im,flag);

chips8 = zeros(0,16);
chips16 = zeros(0,32);
chips8Type = "";
chips16Type = "";

for i = 1:size(chips,1)

% Find the Holes near to the mid to the 1st pin
mid = [(chips(i,1)+chips(i,3))/2,chips(i,2)];
mid(1,1) = mid(1,1) + 30*sign(chips(i,1)-chips(i,3));
[point,~,~,~] = xy2index(mid,holes,im,0);

% Check for chip type
if abs(chips(i,1)-chips(i,3))<500
    % Loop for Chips8
    if point(1,1) == 7
        chips8(end+1,1:2) = [7,point(1,2)-1];
        chips8(end,3:4) = [7,point(1,2)];
        chips8(end,5:6) = [7,point(1,2)+1];
        chips8(end,7:8) = [7,point(1,2)+2];
        chips8(end,9:10) = [8,point(1,2)+2];
        chips8(end,11:12) = [8,point(1,2)+1];
        chips8(end,13:14) = [8,point(1,2)];
        chips8(end,15:16) = [8,point(1,2)-1];
    end
    if point(1,1) == 8
        chips8(end+1,1:2) = [8,point(1,2)+1];
        chips8(end,3:4) = [8,point(1,2)];
        chips8(end,5:6) = [8,point(1,2)-1];
        chips8(end,7:8) = [8,point(1,2)-2];
        chips8(end,9:10) = [7,point(1,2)-2];
        chips8(end,11:12) = [7,point(1,2)-1];
        chips8(end,13:14) = [7,point(1,2)];
        chips8(end,15:16) = [7,point(1,2)+1];
    end
    if chips8Type == ""
        chips8Type(end) = nameMaps(chips(i,5));
    else
        chips8Type(end+1) = nameMaps(chips(i,5));
    end
else
    % Loop for Chip16
    if point(1,1) == 7
        chips16(end+1,1:2) = [7,point(1,2)-3];
        chips16(end,3:4) = [7,point(1,2)-2];
        chips16(end,5:6) = [7,point(1,2)-1];
        chips16(end,7:8) = [7,point(1,2)];
        chips16(end,9:10) = [7,point(1,2)+1];
        chips16(end,11:12) = [7,point(1,2)+2];
        chips16(end,13:14) = [7,point(1,2)+3];
        chips16(end,15:16) = [7,point(1,2)+4];
        chips16(end,17:18) = [8,point(1,2)+4];
        chips16(end,19:20) = [8,point(1,2)+3];
        chips16(end,21:22) = [8,point(1,2)+2];
        chips16(end,23:24) = [8,point(1,2)+1];
        chips16(end,25:26) = [8,point(1,2)];
        chips16(end,27:28) = [8,point(1,2)-1];
        chips16(end,29:30) = [8,point(1,2)-2];
        chips16(end,31:32) = [8,point(1,2)-3];
    end
    if point(1,1) == 8
        chips16(end+1,1:2) = [7,point(1,2)+3];
        chips16(end,3:4) = [7,point(1,2)+2];
        chips16(end,5:6) = [7,point(1,2)+1];
        chips16(end,7:8) = [7,point(1,2)];
        chips16(end,9:10) = [7,point(1,2)-1];
        chips16(end,11:12) = [7,point(1,2)-2];
        chips16(end,13:14) = [7,point(1,2)-3];
        chips16(end,15:16) = [7,point(1,2)-4];
        chips16(end,17:18) = [8,point(1,2)-4];
        chips16(end,19:20) = [8,point(1,2)-3];
        chips16(end,21:22) = [8,point(1,2)-2];
        chips16(end,23:24) = [8,point(1,2)-1];
        chips16(end,25:26) = [8,point(1,2)];
        chips16(end,27:28) = [8,point(1,2)+1];
        chips16(end,29:30) = [8,point(1,2)+2];
        chips16(end,31:32) = [8,point(1,2)+3];
    end
    if chips16Type == ""
        chips16Type(end) = nameMaps(chips(i,5));
    else
        chips16Type(end+1) = nameMaps(chips(i,5));
    end
end

end
end