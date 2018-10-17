function theta=orientation(BW,centers_block,extrema)
%orientation
%   used for calculating orientation of shapes
%   mainly used for dimond and square differtiation
%   inputs corner points and center of blocks
%   outputs orientation between [-pi/4, pi/4]

%   See also color_filter
    feature=load('feature_shape.mat');
    feature=feature.feature_shape;
    idx=0:10:80;
    idx(6:9)=idx(6:9)-90;
    for i=1:length(centers_block(:,1))
        a0=centers_block(i,1)-21;
        a1=centers_block(i,1)+20;
        a2=centers_block(i,2)-21;
        a3=centers_block(i,2)+20;
        t=BW(a2:a3,a0:a1);
        for j=1:9
           score(j)=sum(sum(t&feature(:,:,j)));
        end
        fst=find(score==max(score));
        score(fst)=0;
        snd=find(score==max(score));
        orientation(i)=(1.2*idx(fst(1))+0.8*idx(snd(1)))/2;
        if (fst==5 & snd==6) | (fst==6 & snd==5)
            orientation(i)=45;
        end
    end
    theta=orientation*pi/180;
    theta=theta';
    
    
    
    
    
%     theta=0;
%     length(centers_block(:,1));
%     for i=1:length(centers_block(:,1))%for each individual shapes
%             temp1=cell2mat(extrema(i));
%     %         imshow(imm); hold on; plot(temp1(:,1)*2,temp1(:,2)*2,'+');
%             line=[(temp1(3,1)-temp1(8,1)),(-temp1(3,2)+temp1(8,2))];
%             angle=atan(line(2)/line(1));%calculate orientation from extremas
%             if angle>pi/4
%                 angle=angle-pi/4;%normalize angle
%             elseif angle<=-pi/4
%                 angle=angle+pi/4;%normalize angle
%             end
%             theta=[theta;angle];
%     end
%     theta=theta(2:end);
end