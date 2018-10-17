%random testing script
clear;
figure;
% close all;
feature=load('feature.mat');
feature=feature.feature;
idx=0:5:85;
idx(11:end)=idx(11:end)-90;

%%
im=imread('table11.jpg');
tic;
imm=im;
im=imresize(im,0.5);
imm(1:220,:)=0;
imm(:,1:100,:)=0;

%%
[BW_shape,centers_color,shape_color,theta_color]=color_filter_box(imm);
BW=square3(im);
BW=BW|BW_shape;
BW(1:130,:)=0;
BW=bwareaopen(BW,120,4);
% imshow(BW);

%% orientation
for i=1:length(centers_color(:,1))
    a0=centers_color(i,1)-17;
    a1=centers_color(i,1)+17;
    a2=centers_color(i,2)-17;
    a3=centers_color(i,2)+17;
    t=BW(a2:a3,a0:a1);
    for j=1:18
       score(j)=sum(sum(t&feature(:,:,j)));
    end
    imshow(t);
    fst=find(score==max(score));
    score(fst)=0;
    snd=find(score==max(score));
    orientation(i)=(0.7*idx(fst(1))+0.3*idx(snd(1)))/2;
end

%% differentiate square and diamond
temp=find(shape_color==1);
for i=1:length(temp)
    if abs(theta_color(temp(i))-orientation)>0.2
       shape_color(temp(i))=2;
    end
end

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
result=[centers_color(:,1:2)*2,orientation',centers_color(:,3),shape_color,grid'];
result(:,6)=1;
reach=((centers_color(:,1)*2-center(:,1)).^2+(centers_color(:,2)*2-center(:,2)).^2).^0.5;
temp=find(reach>832);
result(temp,6)=0;
result=[result,grid];

toc;
orientation



%%
% feature0=zeros(35,35);
% feature0(6:30,6:30)=1;
% feature=zeros(35,35,18);
% feature5=imrotate(feature0,5,'bilinear','crop');
% feature10=imrotate(feature0,10,'bilinear','crop');
% feature15=imrotate(feature0,15,'bilinear','crop');
% feature20=imrotate(feature0,20,'bilinear','crop');
% feature25=imrotate(feature0,25,'bilinear','crop');
% feature30=imrotate(feature0,30,'bilinear','crop');
% feature35=imrotate(feature0,35,'bilinear','crop');
% feature40=imrotate(feature0,40,'bilinear','crop');
% feature45=imrotate(feature0,45,'bilinear','crop');
% feature50=imrotate(feature0,50,'bilinear','crop');
% feature55=imrotate(feature0,55,'bilinear','crop');
% feature60=imrotate(feature0,60,'bilinear','crop');
% feature65=imrotate(feature0,65,'bilinear','crop');
% feature70=imrotate(feature0,70,'bilinear','crop');
% feature75=imrotate(feature0,75,'bilinear','crop');
% feature80=imrotate(feature0,80,'bilinear','crop');
% feature85=imrotate(feature0,85,'bilinear','crop');
% for i=1:18
%     feature0|feature0;
% end
% feature(:,:,1)=feature0;
% feature(:,:,2)=feature5;
% feature(:,:,3)=feature10;
% feature(:,:,4)=feature15;
% feature(:,:,5)=feature20;
% feature(:,:,6)=feature25;
% feature(:,:,7)=feature30;
% feature(:,:,8)=feature35;
% feature(:,:,9)=feature40;
% feature(:,:,10)=feature45;
% feature(:,:,11)=feature50;
% feature(:,:,12)=feature55;
% feature(:,:,13)=feature60;
% feature(:,:,14)=feature65;
% feature(:,:,15)=feature70;
% feature(:,:,16)=feature75;
% feature(:,:,17)=feature80;
% feature(:,:,18)=feature85;















