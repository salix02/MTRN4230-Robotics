function [result]=detect_blocks(im,center)
%detect_blocks
%   takes in a RGB image and returns block information.
%   result contains centroids, orientation, color, shape, surface, reachability.
%   this is a main function uses other function for computation
%
%   See also color_filter, shape_filter, square2, match
global detection_State
    detection_State.board_matrix=zeros(9,9,2);
    detection_State.deck1_matrix=zeros(6,1,2);
    detection_State.deck2_matrix=zeros(6,1,2);
    feature=load('feature.mat');
    feature=feature.feature;
    idx=0:5:85;
    idx(11:end)=idx(11:end)-90;
    imm=im;
    im=imresize(im,0.5);%resize image to a half
    imm(1:220,:)=0;
    imm(:,1:100,:)=0;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%delete
    [BW_shape,centers_color,shape_color,theta_color]=color_filter(imm);%detect colered shapes
    %%
    BW=square3(im);%detect black blocks
    BW=BW|BW_shape;%bitwise or binary shape and binart block to make a whole block
    BW(1:130,:)=0;%mask out unnecessory areas
    BW=bwareaopen(BW,120,4);%remove small objects(noise)

    %% orientation
    centers_color=round(centers_color);
    for i=1:length(centers_color(:,1))
        a0=centers_color(i,1)-17;
        a1=centers_color(i,1)+17;
        a2=centers_color(i,2)-17;
        a3=centers_color(i,2)+17;
        t=BW(a2:a3,a0:a1);
        for j=1:18
           score(j)=sum(sum(t&feature(:,:,j)));
        end
        fst=find(score==max(score));
        score(fst)=0;
        snd=find(score==max(score));
        orientation(i)=(1.2*idx(fst(1))+0.8*idx(snd(1)))/2;
        if (fst==10 & snd==11) | (fst==11 & snd==10)
           orientation(i)=42.5; 
        end
    end

    %% differentiate square and diamond
    temp=find(shape_color==1);
    for i=1:length(temp)
        if abs(theta_color(temp(i))-orientation(temp(i))*pi/180)>0.25
            shape_color(temp(i))=2;
        end
    end
%     temp=find(shape_color==1);
%     for i=1:length(temp)
%         if abs(theta_color(temp(i))+orientation(temp(i))*pi/180)<0.2
%            shape_color(temp(i))=2;
%         end
%     end

    %% location: deck? table? board?
    for i=1:length(centers_color)
        if centers_color(i,1)>275 & centers_color(i,1)<520 & centers_color(i,2)>145 & centers_color(i,2)<390
            grid(i)=1;
        elseif centers_color(i,1)>210 & centers_color(i,1)<235 & centers_color(i,2)>145 & centers_color(i,2)<305
            grid(i)=2;
        elseif centers_color(i,1)>565 & centers_color(i,1)<590 & centers_color(i,2)>145 & centers_color(i,2)<305
            grid(i)=3;
        else
            grid(i)=0;
        end
    end
    %% final output
    result=[centers_color(:,1:2)*2,orientation'*pi/-180,centers_color(:,3),shape_color];
    result(:,6)=1;
    reach=((centers_color(:,1)*2-center(:,1)).^2+(centers_color(:,2)*2-center(:,2)).^2).^0.5;
    temp=find(reach>832);
    result(temp,6)=0;
    result=[result,grid'];
end