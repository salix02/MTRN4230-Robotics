%random testing script

% feature=load('feature.mat');
% feature=feature.feature;


clear;
feature0=zeros(42,42);
feature0(7:36,7:36)=1;
imshow(feature0);
feature10=imrotate(feature0,10,'bilinear','crop');
feature20=imrotate(feature0,20,'bilinear','crop');
feature30=imrotate(feature0,30,'bilinear','crop');
feature40=imrotate(feature0,40,'bilinear','crop');
feature50=imrotate(feature0,50,'bilinear','crop');
feature60=imrotate(feature0,60,'bilinear','crop');
feature70=imrotate(feature0,70,'bilinear','crop');
feature80=imrotate(feature0,80,'bilinear','crop');

feature_shape=zeros(42,42,9);
feature_shape(:,:,1)=feature0;
feature_shape(:,:,2)=feature10;
feature_shape(:,:,3)=feature20;
feature_shape(:,:,4)=feature30;
feature_shape(:,:,5)=feature40;
feature_shape(:,:,6)=feature50;
feature_shape(:,:,7)=feature60;
feature_shape(:,:,8)=feature70;
feature_shape(:,:,9)=feature80;

imshow(feature10);
imshow(feature30);
imshow(feature50);
imshow(feature70);
