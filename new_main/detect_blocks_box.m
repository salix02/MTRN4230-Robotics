function [result]=detect_blocks_box(im,BW_box,orientation_box,center)
%detect_blocks
%   takes in a RGB image and returns block information.
%   result contains centroids, orientation, color, shape, surface, reachability.
%   this is a main function uses other function for computation
%
%   See also color_filter, shape_filter, square2, match
    im(:,:,1)=im(:,:,1).*uint8(BW_box);
    im(:,:,2)=im(:,:,2).*uint8(BW_box);
    im(:,:,3)=im(:,:,3).*uint8(BW_box);
    imm=im;
    im=imresize(im,0.5);%resize image to a half
    [BW_shape,centers_color,shape_color,theta_color]=color_filter_box(imm);%detect colered shapes
%     figure; imshow(BW_shape);
    %%
    temp=find(shape_color==1);
    for i=1:length(temp)
        if abs(theta_color(temp(i))+orientation_box)>0.25
           shape_color(temp(i))=2;
        end
    end
    orientation=zeros(size(shape_color));
    orientation(:)=orientation_box;
%     (centers_color(:,1:2)-center);
    result=[centers_color(:,1:2)*2,orientation,centers_color(:,3),shape_color];
    result(:,6)=1;
    reach=((centers_color(:,1)*2-center(:,1)).^2+(centers_color(:,2)*2-center(:,2)).^2).^0.5;
    temp=find(reach>832);
    result(temp,6)=0;
      
end