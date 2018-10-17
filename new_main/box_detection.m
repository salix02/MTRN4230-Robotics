function [centroid,orientation,BW]=box_detection(im)
%box_detection 
%   returns centroid and orientation of box in conveyor frame.
%   centroiod contains n by 2 matrix of x and y location in the image.
%   orientation contains angle in degrees from [-90, 90] by using regionprops function.
%   this function calls box function
%  
%   See also box, regionprops.
    
%     im=imrotate(im,180);
    centroid=[];
    orientation=[];
    imi=im;

%     im=imresize(im,0.25);%resize image for faster processing
    BW = box(im);%use color thresholding method
    BW(:,1:4*135)=0;%mask out areas not interested
%     figure; imshow(BW);
    BW(700:end,:)=0;%mask out areas not interested
%     imshow(BW);
    BW(:,285*4:end)=0;%mask out areas not interested
%     imshow(BW);
    BW=bwareaopen(BW,100);%remove small objects in image
%     figure;
%     imshow(BW);
    BW=imfill(BW,'holes');
    BW=bwareaopen(BW,500);
%     se=strel('disk',200);%structural element
%     figure; imshow(BW);
%     BW=imclose(BW,se);%close small hollows in the object
%     imshow(BW);
    stats=regionprops(BW,'centroid','Extrema','Orientation','area');%detect object features
    temp=corner(BW);
    temp2=sum(temp,2);
    idx1=find(temp2==min(temp2));
    idx1=idx1(1);
    idx2=find(temp2==max(temp2));
    idx2=idx2(1);
%     plot(temp(idx1,1),temp(idx1,2),'c+');
%     plot(temp(idx2,1),temp(idx2,2),'c+');
%     (atan((temp(idx2,2)-temp(idx1,2))/(temp(idx2,1)-temp(idx1,1)))+0.0977)
    d=atan((temp(idx2,2)-temp(idx1,2))/(temp(idx2,1)-temp(idx1,1)));
%     d*180/pi
    orientation=(0.32-d);%*180/pi
%     orientation*180/pi
%     plot(stats.Extrema(:,1),stats.Extrema(:,2),'c+');
    orientation=-stats.Orientation*pi/180;
    if orientation>pi/4
        orientation=orientation-pi/2;
    elseif orientation<-pi/4
        orientation=orientation+pi/2;
    end
    
    if isempty(stats)~=1%if there is an object
        temp=find(stats.Area>3200);%find box object
        if isempty(temp)~=1%if the object is a box
            centroid=stats.Centroid;%resize centroid to original image
            centroid(2)=1200-centroid(2);
%             orientation=stats.Orientation;%check orientation
        end
    end
end