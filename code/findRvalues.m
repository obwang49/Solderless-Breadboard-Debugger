function Rvalues = findRvalues(im, RLCsXY, flag)

disp('Detecing Resistor Values...');
Rvalues = zeros(1,size(RLCsXY,1));

% Loop through all Resistors
for idx = 1:size(RLCsXY,1)
    
    % Create XY vectors
    x = linspace(RLCsXY(idx,1),RLCsXY(idx,3),200);
    y = interp1([RLCsXY(idx,1),RLCsXY(idx,3)],[RLCsXY(idx,2),RLCsXY(idx,4)],x);

    % Fetching the Gray Images
    im_gray = rgb2gray(im2double(im));
    %im_gray = im2double(im_raw(:,:,3));
    
    color = interp2(im_gray,x,y);
    len = sum(color(20:160)<0.33);
    
    if flag == 1
        figure()
        plot(color)
        hold on;
        plot([0,200],[0.33,0.33]);
        hold off;
        disp(len);
    end
      
       
    if len<20 || len>35
        Rvalues(idx) = 5600;
    else
        Rvalues(idx) = 623;
    end
end
disp(strcat("Successfully Detected ",num2str(size(RLCsXY,1))," Resistor Values !"));
end