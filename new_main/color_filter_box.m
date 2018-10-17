function [BW,centers_color,shape_color,theta_color] = color_filter_box(RGB)
%color_filter
%   threshold RGB image by using colorThresholder app.
%   function is for detecting color shapes in blocks.
%   returns binary image, centroid, shape and orientation of shapes in table frame.
%   centroiod contains n by 2 matrix of x and y location in the image.
%   orientation contains angle in radiants from [-pi/4, pi/4] by using regionprops function.
%   this function calls shape_filter function
%
%   See also regionprops, shape_filter, colorThresholder.
    I = rgb2hsv(RGB);%convert RGB to HSV
%% green
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.266;
channel1Max = 0.468;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.233;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.275;
channel3Max = 1.000;
    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BWg = sliderBW;

    shape_green=0;
%     BWg(1:220,:)=0;%mask out areas not interested
    BWg=bwareaopen(BWg,120,4);%remove small objects
    stats=regionprops('table',BWg,'Centroid','Perimeter','FilledArea','Extrema');
    centers_green=stats.Centroid/2;%image is resized to 0.5
    extrema=stats.Extrema;%check corners for orientation calculation to differentiate diamond and square
    if isempty(centers_green)~=1, centers_green(:,3)=4; end%fill color into array
    filledarea=stats.FilledArea;%check area of detected object
    perimeter=stats.Perimeter;%check perimeters
    circularity=perimeter.^2./(4*pi*filledarea);%calculate circularity
    for i=1:length(filledarea)
        shape_green=[shape_green;shape_filter(circularity(i))];%fill shape into array
    end
    shape_green=shape_green(2:end);
    
    if length(centers_green)~=0
        theta_green=orientation(BWg,stats.Centroid,stats.Extrema);%fill orientation into array
    else
        theta_green=centers_green;
    end
    %same algorithm applies for all other colors and shapes.    

%% red
    % I = rgb2hsv(RGB);
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.938;
channel1Max = 0.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.254;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.551;
channel3Max = 1.000;
    sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BWr = sliderBW;

    shape_red=0;
%     BWr(1:220,:)=0;
    BWr=bwareaopen(BWr,120,4);
    stats=regionprops('table',BWr,'Centroid','Perimeter','FilledArea','Extrema');
    centers_red=stats.Centroid/2;
    extrema=stats.Extrema;
    if isempty(centers_red)~=1, centers_red(:,3)=1; end
    filledarea=stats.FilledArea;
    perimeter=stats.Perimeter;
    circularity=perimeter.^2./(4*pi*filledarea);
    for i=1:length(filledarea)
        shape_red=[shape_red;shape_filter(circularity(i))];
    end
    shape_red=shape_red(2:end);
    
    if length(centers_red)~=0
        theta_red=orientation(BWr,stats.Centroid,stats.Extrema);
    else
        theta_red=centers_red;
    end
    
%% orange
    % I = rgb2hsv(RGB);
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 0.066;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.250;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.440;
channel3Max = 1.000;
    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BWo = sliderBW;

    shape_orange=0;
%     BWo(1:220,:)=0;
    BWo=bwareaopen(BWo,120,4);
    stats=regionprops('table',BWo,'Centroid','Perimeter','FilledArea','Extrema');
    centers_orange=stats.Centroid/2;
    extrema=stats.Extrema;
    if isempty(centers_orange)~=1, centers_orange(:,3)=2; end
    filledarea=stats.FilledArea;
    perimeter=stats.Perimeter;
    circularity=perimeter.^2./(4*pi*filledarea);
    for i=1:length(filledarea)
        shape_orange=[shape_orange;shape_filter(circularity(i))];
    end
    shape_orange=shape_orange(2:end);
    
    if length(centers_orange)~=0
        theta_orange=orientation(BWo,stats.Centroid,stats.Extrema);
    else
        theta_orange=centers_orange;
    end
    
%% blue
    % I = rgb2hsv(RGB);
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.520;
channel1Max = 0.660;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.233;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.275;
channel3Max = 1.000;
    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BWb = sliderBW;

    shape_blue=0;
%     BWb(1:220,:)=0;
    BWb=bwareaopen(BWb,120,4);
    stats=regionprops('table',BWb,'Centroid','Perimeter','FilledArea','Extrema');
    centers_blue=stats.Centroid/2;
    extrema=stats.Extrema;
    if isempty(centers_blue)~=1, centers_blue(:,3)=5; end
    filledarea=stats.FilledArea;
    perimeter=stats.Perimeter;
    circularity=perimeter.^2./(4*pi*filledarea);
    for i=1:length(filledarea)
        shape_blue=[shape_blue;shape_filter(circularity(i))];
    end
    shape_blue=shape_blue(2:end);
%     figure; imshow(BWb);
    if length(centers_blue)~=0
        theta_blue=orientation(BWb,stats.Centroid,stats.Extrema);
    else
        theta_blue=centers_blue;
    end
%% volet
    % I = rgb2hsv(RGB);
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.646;
channel1Max = 0.730;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.233;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.275;
channel3Max = 1.000;
    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BWv = sliderBW;

    shape_volet=0;
%     BWv(1:220,:)=0;
    BWv=bwareaopen(BWv,120,4);
    stats=regionprops('table',BWv,'Centroid','Perimeter','FilledArea','Extrema');
    centers_volet=stats.Centroid/2;
    extrema=stats.Extrema;
    if isempty(centers_volet)~=1, centers_volet(:,3)=6; end
    filledarea=stats.FilledArea;
    perimeter=stats.Perimeter;
    circularity=perimeter.^2./(4*pi*filledarea);
    for i=1:length(filledarea)
        shape_volet=[shape_volet;shape_filter_v(circularity(i))];
    end
    shape_volet=shape_volet(2:end);
    
    if length(centers_volet)~=0
        theta_volet=orientation(BWv,stats.Centroid,stats.Extrema);
    else
        theta_volet=centers_volet;
    end
%% yellow
    % I = rgb2hsv(RGB);
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.153;
channel1Max = 0.229;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.109;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.243;
channel3Max = 1.000;
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.116;
channel1Max = 0.225;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.220;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.732;
channel3Max = 1.000;
    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BWy = sliderBW;
    BWy=bwareaopen(BWy,300);
    shape_yellow=0;
%     BWy(1:220,:)=0;
    BWy=bwareaopen(BWy,120,4);
    stats=regionprops('table',BWy,'Centroid','Perimeter','FilledArea','Extrema');
    centers_yellow=stats.Centroid/2;
    extrema=stats.Extrema;
    if isempty(centers_yellow)~=1, centers_yellow(:,3)=3; end
    filledarea=stats.FilledArea;
    perimeter=stats.Perimeter;
    circularity=perimeter.^2./(4*pi*filledarea);
    for i=1:length(filledarea)
        shape_yellow=[shape_yellow;shape_filter_y(circularity(i))];
    end
    shape_yellow=shape_yellow(2:end);
    
    if length(centers_yellow)~=0
        theta_yellow=orientation(BWy,stats.Centroid,stats.Extrema);
    else
        theta_yellow=centers_yellow;
    end
 %%
    BW=BWr|BWg|BWb|BWy|BWv|BWo;
    BW=imresize(BW,0.5);  
    centers_color=[centers_red;centers_green;centers_blue;centers_yellow;centers_volet;centers_orange];
    shape_color=[shape_red;shape_green;shape_blue;shape_yellow;shape_volet;shape_orange];
    theta_color=[theta_red;theta_green;theta_blue;theta_yellow;theta_volet;theta_orange];
end


%% 
% function theta=orientation(centers_block,extrema)
%     theta=0;
%     length(centers_block(:,1));
%     for i=1:length(centers_block(:,1))%for each individual shapes
%             temp1=cell2mat(extrema(i));
%     %         imshow(imm); hold on; plot(temp1(:,1)*2,temp1(:,2)*2,'+');
%             line=[(temp1(3,1)-temp1(8,1)),(-temp1(3,2)+temp1(8,2))];
%             angle=atan(line(2)/line(1));%calculate orientation from extremas
%             if angle>0
%                 angle=angle-pi/4;%normalize angle
%             elseif angle<=0
%                 angle=angle+pi/4;%normalize angle
%             end
%             theta=[theta;angle];
%     end
%     theta=theta(2:end);
% end