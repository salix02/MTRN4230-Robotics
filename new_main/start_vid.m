function [vid1,vid2,handle]=start_vid(online)
%start_vid
%   this function starts either live video feed or static image feed based
%   on the input online.
%   it returns object handles that can be used in detection function
%
%   see also video_detection
% warning off;
    cameraParams=load('cameraParams.mat');
    cameraParams=cameraParams.cameraParams;
    ratio_table=1.524;
    ratio_convey=787/520;
    robot_center1=[796, 858-548.6*ratio_table];%%%%%%%%%%%%%
    robot_center2=[215, 781-175*ratio_convey];%%%%%%%%%%%%%%
%     online=0;
    global on_table not_inside_grid on_board on_deck1 on_deck2 orientation_box
    global in_box
    global vacum detection
    global board_stat deck1_stat deck2_stat
    global detection_State
    board_stat=zeros(9,9,2);%2 9*9 matrix for shape and color
    deck1_stat=zeros(6,1,2);
    deck2_stat=zeros(6,1,2);
    cell_center();
    vid1=0;
    vid2=0;
    %% first figure for live feed
    if online==1
        table;
        conveyor;
        handle.fg1=figure(1);
        set(gca,'position',[0 0 1 1],'units','normalized')
        vid1=videoinput('winvideo', 1, 'RGB24_1600x1200');
        vidRes1=vid1.VideoResolution;
        nBands1=vid1.NumberOfBands;
        hImage1=image(zeros(vidRes1(2),vidRes1(1),nBands1));
        preview(vid1, hImage1);
        src1=getselectedsource(vid1);
        src1.ExposureMode = 'manual';
        src1.Exposure = -3;
        src1=getselectedsource(vid1);
        hold on;
        %handle of plotting center of robot in table frame
        handle.p1center=plot(robot_center1(1),robot_center1(2),'c*');
        %handle of plotting center of box in table frame
        handle.p1=plot(robot_center1(1),robot_center1(2),'c*');
        handle.ori1=quiver(0,0,0,0);
        temp=zeros(100,2);
        handle.t1=text(temp(:,1),temp(:,2),'','Color','m','FontSize',8);

        set(handle.fg1,'units','normalized','WindowButtonDownFcn', {@getMousePositionOnImage,1},'KeyPressFcn',{@getKey,1},'KeyReleaseFcn',{@resetKey});
        %% second figure for live feed
        handle.fg2=figure(2);
        set(gca,'position',[0 0 1 1],'units','normalized')
        vid2 = videoinput('winvideo', 2, 'RGB24_1600x1200');
        vidRes2=vid2.VideoResolution;
        nBands2=vid2.NumberOfBands;
        hImage2=image(zeros(vidRes2(2),vidRes2(1),nBands2));
        preview(vid2, hImage2);
        src2=getselectedsource(vid2);
        src2.ExposureMode = 'manual';    
        src2.Exposure = -3.2;
        hold on;
        %handle of plotting center of robot in conveyor frame
        handle.p2center=plot(robot_center2(1),robot_center2(2),'c*');
        %handle of plotting center of box in conveyor frame
        handle.p2=plot(robot_center2(1),robot_center2(2),'c*');
        handle.ori2=quiver(0,0,0,0);
        temp=zeros(40,2);
        handle.t2=text(temp(:,1),temp(:,2),'','Color','m','FontSize',8);
        
        set(handle.fg2,'units','normalized','WindowButtonDownFcn', {@getMousePositionOnImage,2},'KeyPressFcn',{@getKey,2},'KeyReleaseFcn',{@resetKey});
    else
        %% first figure for static image
        handle.fg1=figure(1);
        set(gca,'position',[0 0 1 1],'units','normalized')
        im1=imread('table14.jpg');
        % im1=imread('table11.jpg');
        [im1,newOrigin1]=undistortImage(im1,cameraParams);
        imshow(im1);
        hold on;
        %handle of plotting center of robot in conveyor frame
        handle.p1center=plot(robot_center1(1),robot_center1(2),'c*');
        %handle of plotting center of box in table frame
        handle.p1=plot(robot_center1(1),robot_center1(2),'c*');
        handle.ori1=quiver(0,0,0,0);
        temp=zeros(100,2);
        handle.t1=text(temp(:,1),temp(:,2),'','Color','m','FontSize',8);
        try
            [result1]=detect_blocks(im1,robot_center1);
        catch
        end
        if exist('result1','var')
            coord2cell(result1);
            reach1=find(result1(:,6)==1);
            result1=result1(reach1,:);
            set(handle.p1,'xdata',result1(:,1),'ydata',result1(:,2));
            set(handle.ori1,'xdata',result1(:,1),'ydata',result1(:,2),'UData',60*cos(result1(:,3)),'VData',60*sin(result1(:,3)),'AutoScale','off');
            for i=1:length(result1(:,1))
                temp1=int2str(uint8(result1(i,4)));
                temp2=int2str(uint8(result1(i,5)));
                temp=strcat(temp1,temp2);
                if result1(i,6)==1
                    set(handle.t1(i),'Position',result1(i,1:2),'String',temp);
%                     text(result1(i,1),result1(i,2),temp,'Color','m','FontSize',8);
                end
            end
        end

        set(handle.fg1,'units','normalized','WindowButtonDownFcn', {@getMousePositionOnImage,1},'KeyPressFcn',{@getKey,1},'KeyReleaseFcn',{@resetKey});
        %% second figure for static image
        handle.fg2=figure(2);
        set(gca,'position',[0 0 1 1],'units','normalized')
        im2=imread('conveyor1.jpg');
        [im2,newOrigin2]=undistortImage(im2,cameraParams);
        imshow(im2);
        hold on;
        handle.p2center=plot(robot_center2(1),robot_center2(2),'c*');
        %handle of plotting center of box in conveyor frame
        handle.p2=plot(robot_center2(1),robot_center2(2),'c*');
        handle.ori2=quiver(0,0,0,0);
        temp=zeros(40,2);
        handle.t2=text(temp(:,1),temp(:,2),'','Color','w','FontSize',8);
        try
            [centroid_box,orientation_box,BW_box]=box_detection(im2);% calculate centroid and orientation of box
            [result2]=detect_blocks_box(im2,BW_box,orientation_box,robot_center2);%missing reachability
            box_occupancy(conveyor2global(centroid_box),orientation_box);
            detection_State.orientation_box=orientation_box*1;
        catch ME
        end;
        if exist('result2','var')
            reach2=find(result2(:,6)==1);
            result2=result2(reach2,:);
            detection_State.in_box_CVframe=result2;
            detection_State.in_box_CVframe(:,2)=1200-detection_State.in_box_CVframe(:,2);
            in_box=result2;
            in_box(:,2)=1200-in_box(:,2);
            in_box=conveyor2global(in_box);
            in_box=in_box(:,1:5);
            in_box(:,3)=in_box(:,3)*-1;
            detection_State.in_box=in_box;
            set(handle.p2,'xdata',result2(:,1),'ydata',result2(:,2));
            set(handle.ori2,'xdata',result2(:,1),'ydata',result2(:,2),'UData',60*cos(result2(:,3)),'VData',60*sin(result2(:,3)),'AutoScale','off');
            for i=1:length(result2(:,1))
                temp1=int2str(uint8(result2(i,4)));
                temp2=int2str(uint8(result2(i,5)));
                temp=strcat(temp1,temp2);
                if result2(i,6)==1
                    set(handle.t2(i),'Position',result2(i,1:2),'String',temp);
                    text(result2(i,1),result2(i,2),temp,'Color','w','FontSize',8);
                end
            end
        end
        set(handle.fg2,'units','normalized','WindowButtonDownFcn', {@getMousePositionOnImage,2},'KeyPressFcn',{@getKey,2},'KeyReleaseFcn',{@resetKey});
    end
end
