%model main for how to use image detection and how to interact between
%global structs.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%please read this first%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% stuct detction_State
%   on_table_TBframe
%       blocks reachable on table in camera frame
%   on_table
%       blocks reachable on table in robot frame
%   not_inside_cell
%       blocks reachable on table not in any cell in robot frame
%   deck1_coord
%       blocks in deck1 in robot frame
%   deck2_coord
%       blocks in deck2 in robot frame
%   board_coord
%       blocks in board in robot frame
%   deck1_matrix
%       status of current deck1, 6*1*2 matrix
%   deck2_matrix
%       status of current deck2, 6*1*2 matrix
%   board_matrix
%       status of current board, 9*9*2 matrix
%   in_box_CVframe
%       blocks reachable in box in conveyor frame
%   in_box
%       blocks reachable in box in robot frame
%   msgPos
%       current click of mouse, could return actual location or the centre
%       of grid in robot frame, it can be toggled by controlling grid_coord
%   msgPos_grid
%       current click of mouse, could return actual grid index of board or
%       decks, it can be toggled by controlling grid_coord
%   grid_coord
%       chose between if return grid number of coordinate
%       1 means grid index
%       2 means closest centroid of block
%       0 means actual coordinate
%   deck1x
%       x coordinate of deck 1 cells in robot frame(top to bottom)
%   deck1y
%       y coordinate of deck 1 cells in robot frame(only one value)
%   deck2x
%       x coordinate of deck 2 cells in robot frame(top to bottom)
%   deck2y
%       y coordinate of deck 2 cells in robot frame(only one value)
%   boardx
%       x coordinate of board cells in robot frame(top to bottom)
%   boardy
%       y coordinate of board cells in robot frame(left to right)
%% declear variables
close all;
% clear;
% clc;
online=0;
global detection_State vacuum
vacuum=1;
% detection_State.grid_coord=1;
[vid1,vid2,handle]=start_vid(online);
fillDeck(vid1,vid2,handle);
if online==1
    video_detection(vid1,vid2,handle);
end

%% example
% choose which mode you want by setting flag in the struct
% if need to use real coordinate based on click
%   set detection_State.grid_coord = 0
% if need to use grid index for board and deck based on click
%   set detection_State.grid_coord = 1
% if need to use controid of block based on click
%   set detection_State.grid_coord = 2
% coordinates are stored in msgPos



% function [vid1,vid2,handle]=start_vid(online)
%     cameraParams=load('cameraParams.mat');
%     cameraParams=cameraParams.cameraParams;
%     ratio_table=1.524;
%     ratio_convey=787/520;
%     robot_center1=[796, 858-548.6*ratio_table];%%%%%%%%%%%%%
%     robot_center2=[215, 781-175*ratio_convey];%%%%%%%%%%%%%%
% %     online=0;
%     global on_table not_inside_grid on_board on_deck1 on_deck2 orientation_box
%     global in_box
%     global vacuum detection
%     global board_stat deck1_stat deck2_stat
%     global detection_State
%     board_stat=zeros(9,9,2);%2 9*9 matrix for shape and color
%     deck1_stat=zeros(6,1,2);
%     deck2_stat=zeros(6,1,2);
%     vid1=0;
%     vid2=0;
%     %% first figure for live feed
%     if online==1
%         table;
%         conveyor;
%         handle.fg1=figure(1);
%         set(gca,'position',[0 0 1 1],'units','normalized')
%         vid1=videoinput('winvideo', 1, 'RGB24_1600x1200');
%         vidRes1=vid1.VideoResolution;
%         nBands1=vid1.NumberOfBands;
%         hImage1=image(zeros(vidRes1(2),vidRes1(1),nBands1));
%         preview(vid1, hImage1);
%         src1=getselectedsource(vid1);
%         src1.ExposureMode = 'manual';
%         src1.Exposure = -3;
%         src1=getselectedsource(vid1);
%         hold on;
%         %handle of plotting center of robot in table frame
%         handle.p1center=plot(robot_center1(1),robot_center1(2),'c*');
%         %handle of plotting center of box in table frame
%         handle.p1=plot(robot_center1(1),robot_center1(2),'c*');
%         handle.ori1=quiver(0,0,0,0);
% 
%         set(handle.fg1,'units','normalized','WindowButtonDownFcn', {@getMousePositionOnImage,1},'KeyPressFcn',{@getKey,1},'KeyReleaseFcn',{@resetKey});
%         %% second figure for live feed
%         handle.fg2=figure(2);
%         set(gca,'position',[0 0 1 1],'units','normalized')
%         vid2 = videoinput('winvideo', 2, 'RGB24_1600x1200');
%         vidRes2=vid2.VideoResolution;
%         nBands2=vid2.NumberOfBands;
%         hImage2=image(zeros(vidRes2(2),vidRes2(1),nBands2));
%         preview(vid2, hImage2);
%         src2=getselectedsource(vid2);
%         src2.ExposureMode = 'manual';    
%         src2.Exposure = -3;
%         hold on;
%         %handle of plotting center of robot in conveyor frame
%         handle.p2center=plot(robot_center2(1),robot_center2(2),'c*');
%         %handle of plotting center of box in conveyor frame
%         handle.p2=plot(robot_center2(1),robot_center2(2),'c*');
%         handle.ori2=quiver(0,0,0,0);
% 
%         set(handle.fg2,'units','normalized','WindowButtonDownFcn', {@getMousePositionOnImage,2},'KeyPressFcn',{@getKey,2},'KeyReleaseFcn',{@resetKey});
%     else
%         %% first figure for static image
%         handle.fg1=figure(1);
%         set(gca,'position',[0 0 1 1],'units','normalized')
%         im1=imread('table11.jpg');
%         [im1,newOrigin1]=undistortImage(im1,cameraParams);
%         imshow(im1);
%         hold on;
%         %handle of plotting center of robot in conveyor frame
%         handle.p1center=plot(robot_center1(1),robot_center1(2),'c*');
%         %handle of plotting center of box in table frame
%         handle.p1=plot(robot_center1(1),robot_center1(2),'c*');
%         handle.ori1=quiver(0,0,0,0);
%         try
%             [result1]=detect_blocks(im1,robot_center1);
%         catch
%         end
%         if exist('result1','var')
%             coord2cell(result1);
%     %         board_stat(:,:,1)
%     %         board_stat(:,:,2)
%     %         deck1_stat(:,:,1)
%     %         deck2_stat(:,:,1)
%     %         on_table
%             reach1=find(result1(:,6)==1);
%             result1=result1(reach1,:);
%             set(handle.p1,'xdata',result1(:,1),'ydata',result1(:,2));
%             set(handle.ori1,'xdata',result1(:,1),'ydata',result1(:,2),'UData',60*cos(result1(:,3)),'VData',60*sin(result1(:,3)),'AutoScale','off');
%         %orientation is reversed, need to flip direction!!!
%             for i=1:length(result1)
%                 temp1=int2str(uint8(result1(i,4)));
%                 temp2=int2str(uint8(result1(i,5)));
%                 temp=strcat(temp1,temp2);
%                 if result1(i,6)==1
%                     text(result1(i,1),result1(i,2),temp,'Color','m','FontSize',8);
%                 end
%             end
%         end
% 
%         set(handle.fg1,'units','normalized','WindowButtonDownFcn', {@getMousePositionOnImage,1},'KeyPressFcn',{@getKey,1},'KeyReleaseFcn',{@resetKey});
%         %% second figure for static image
%         handle.fg2=figure(2);
%         set(gca,'position',[0 0 1 1],'units','normalized')
%         im2=imread('conveyor1.jpg');
%         [im2,newOrigin2]=undistortImage(im2,cameraParams);
%         imshow(im2);
%         hold on;
%         handle.p2center=plot(robot_center2(1),robot_center2(2),'c*');
%         %handle of plotting center of box in conveyor frame
%         handle.p2=plot(robot_center2(1),robot_center2(2),'c*');
%         handle.ori2=quiver(0,0,0,0);
%         try
%             [centroid_box,orientation_box,BW_box]=box_detection(im2);% calculate centroid and orientation of box
%             [result2]=detect_blocks_box(im2,BW_box,orientation_box,robot_center2);%missing reachability
%         catch ME
%         end;
%         if exist('result2','var')
%             reach2=find(result2(:,6)==1);
%             result2=result2(reach2,:);
%             detection_State.in_box_CVframe=result2;
%             in_box=result2;
%             in_box(:,2)=1200-in_box(:,2);
%             in_box=conveyor2global(in_box);
%             in_box=in_box(:,1:5);
%             in_box(:,3)=in_box(:,3)*-1;
%             detection_State.in_box=in_box;
%             set(handle.p2,'xdata',result2(:,1),'ydata',result2(:,2));
%             set(handle.ori2,'xdata',result2(:,1),'ydata',result2(:,2),'UData',60*cos(result2(:,3)),'VData',60*sin(result2(:,3)),'AutoScale','off');
%             for i=1:length(result2)
%                 temp1=int2str(uint8(result2(i,4)));
%                 temp2=int2str(uint8(result2(i,5)));
%                 temp=strcat(temp1,temp2);
%                 if result2(i,6)==1
%                     text(result2(i,1),result2(i,2),temp,'Color','w','FontSize',8);
%                 end
%             end
%         end
%         set(handle.fg2,'units','normalized','WindowButtonDownFcn', {@getMousePositionOnImage,2},'KeyPressFcn',{@getKey,2},'KeyReleaseFcn',{@resetKey});
%     end
% end

%% loop
% function video_detection(vid1,vid2,handle)
% 
%     global on_table not_inside_grid on_board on_deck1 on_deck2 orientation_box
%     global in_box
%     global vacuum detection
%     global board_stat deck1_stat deck2_stat
%     global detection_State
% %% plot for first video feed
%     im1=getsnapshot(vid1);
%     [im1,newOrigin1]=undistortImage(im1,cameraParams);
%     try
%         [result1]=detect_blocks(im1,robot_center1);
%     catch
%     end
%     if exist('result1','var')
%         coord2cell(result1);
%         reach1=find(result1(:,6)==1);
%         result1=result1(reach1,:);
%         set(handle.p1,'xdata',result1(:,1),'ydata',result1(:,2));
%         set(handle.ori1,'xdata',result1(:,1),'ydata',result1(:,2),'UData',60*cos(result1(:,3)),'VData',60*sin(result1(:,3)),'AutoScale','off');
%     %orientation is reversed, need to flip direction!!!
%         for i=1:length(result1)
%             temp1=int2str(uint8(result1(i,4)));
%             temp2=int2str(uint8(result1(i,5)));
%             temp=strcat(temp1,temp2);
%             if result1(i,6)==1
%                 text(result1(i,1),result1(i,2),temp,'Color','m','FontSize',8);
%             end
%         end
%     else
%         set(handle.p1,'xdata',0,'ydata',0);
%         set(handle.ori1,'xdata',0,'ydata',0,'UData',0,'VData',0,'AutoScale','off');
%     end
%     drawnow();
% %% plot for second video feed
%     im2=getsnapshot(vid2);
%     [im2,newOrigin2]=undistortImage(im2,cameraParams);
%     try
%         [centroid_box,orientation_box,BW_box]=box_detection(im2);% calculate centroid and orientation of box
%         [result2]=detect_blocks_box(im2,BW_box,orientation_box,robot_center2);%missing reachability
%     catch ME
%     end;
%     if exist('result2','var')
%         reach2=find(result2(:,6)==1);
%         result2=result2(reach2,:);
%         detection_State.in_box_CVframe=result2;
%         in_box=result2;
%         in_box(:,2)=1200-in_box(:,2);
%         in_box=conveyor2global(in_box);
%         in_box=in_box(:,1:5);
%         in_box(:,3)=in_box(:,3)*-1;
%         detection_State.in_box=in_box;
%         set(handle.p2,'xdata',result2(:,1),'ydata',result2(:,2));
%         set(handle.ori2,'xdata',result2(:,1),'ydata',result2(:,2),'UData',60*cos(result2(:,3)),'VData',60*sin(result2(:,3)),'AutoScale','off');
%         for i=1:length(result2)
%             temp1=int2str(uint8(result2(i,4)));
%             temp2=int2str(uint8(result2(i,5)));
%             temp=strcat(temp1,temp2);
%             if result2(i,6)==1
%                 text(result2(i,1),result2(i,2),temp,'Color','w','FontSize',8);
%             end
%         end
%     else
%         set(handle.p2,'xdata',0,'ydata',0);
%         set(handle.ori2,'xdata',0,'ydata',0,'UData',0,'VData',0,'AutoScale','off');
%     end
%     drawnow();
% end


%% callback function for mouse click
% function getMousePositionOnImage(handle,evt,idx)
% global datacursor msgPos vacuum board_stat deck1_stat deck2_stat
% global detection_State
% received=1;
% detection_State.grid_coord=1;%check if need to return cell number or actual location!!!!!!!!!
%     cursorPoint = get(handle, 'CurrentPoint');
%     curX = cursorPoint(1,1)*1600;
%     curY = cursorPoint(1,2)*1200;
% %     handle.UserData=[curX,curY];
%     datacursor=[idx,curX,curY];
% %     disp(datacursor);
%     %idx points to cameras
%     x_gap=54.92;%54.5611;
%     y_gap=54.92;%54.9671;
%     %check cell number of board
%     if idx==1 && detection_State.grid_coord==1%548.57 914.25, 1043 414.3
%         if curX>548 && curX<1045.7 && curY>417.14 && curY<914.25
%             celly=ceil((curX-548)/x_gap);
%             cellx=ceil((abs(curY-1200)-285.72)/y_gap);
%             if cellx==0, cellx=1; end;
%             if cellx==10, cellx=9; end;
%             if celly==0, celly=1; end;
%             if celly==10, celly=9; end;
%         end
%         %cleck player1 deck
%         if curX>417.14 && curX<474.28 && curY>580 && curY<914.25
%             celly=0;
%             cellx=ceil((abs(curY-1200)-285.72)/y_gap);
%             if cellx==0, cellx=1; end;
%             if cellx==7, cellx=6; end;
%         end
%         %check player2 deck
%         if curX>1120 && curX<1174.3 && curY>580 && curY<914.25
%             celly=10;
%             cellx=ceil((abs(curY-1200)-293)/y_gap);
%             if cellx==0, cellx=1; end;
%             if cellx==7, cellx=6; end;
%         end
%         %display for debugging
%         if exist('celly','var') && exist('cellx','var')
%             fprintf('grid number is %d,%d\n', cellx, celly);%%%%%%%%%%%%%%%
%             [x,y]=cell2coord(cellx, celly);
%             msgPos(1) = 0.6667*(1200-y-285.72)+175;
%             msgPos(2) = 0.6667*(x-797.14);
%             msgPos(3) = 157;
%         else
%             disp(datacursor);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             msgPos(1) = 0.6667*(1200-curY-285.72)+175;
%             msgPos(2) = 0.6667*(curX-797.14);
%             msgPos(3) = 157;
%         end
%     elseif idx==1 && detection_State.grid_coord==0
%         disp(datacursor);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         msgPos(1) = 0.6667*(1200-curY-285.72)+175;
%         msgPos(2) = 0.6667*(curX-797.14);
%         msgPos(3) = 157;
%     elseif idx==2
%         disp(datacursor);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         msgPos(1) = 0.75*(1200-curY-525)+0;
%         msgPos(2) = 0.75*(curX-869)+409;
%         msgPos(3) = 32;
%     end
%     disp('msgPos is');
%     disp(msgPos);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if vacuum==0%vacuum is off, ready to pick
%         send_message(1);
%     else%vacuum is on, ready to drop
%         send_message(1);%keep vacuum on and move to goal
%         while received~=1
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %%%receive message from robot
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %waiting to complete picking up
%         end
%         send_message(0);%turn off vacuum and place block
%     end
%     detection_State.msgPos=msgPos;
% end

%% execusion functions for questions
function fillDecks()%question 1.4
global in_box
received=1;
    inbox=in_box(:,1:3);
    for i=1:12
        if i>length(inbox(1,:))
            break;
        end
        from=inbox(i,:);%[x,y,angle], need to send orientation angle
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%send message to robot
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        while received~=1
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%receive message from robot
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %waiting to complete picking up 
        end
        if i<7
            cellx=0;
            celly=i;
            [x,y]=cell2coord(cellx, celly);
        else
            cellx=10;
            celly=i-6;
            [x,y]=cell2coord(cellx, celly);
        end
        to=[x,y];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%send message to robot
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        while received~=1
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%receive message from robot
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %waiting to complete picking up  
        end
    end
end

function allBlocks2Box()%question 1.5
global in_box not_inside_grid on_board orientation_box
received=1;
    temp=not_inside_grid(:,1:3);
    temp1=on_board(:,1:3);
    nd=[temp;temp1];%not in deck cells
    ib=in_box(:,1:2);
    for i=1:length(nd(:,1))
        from=nd(i,:);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%send message to robot
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        while received~=1
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%receive message from robot
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %waiting to complete picking up 
        end
        to=ib
        
    end
end

function fillDecks_six()%question 1.6
global on_table
received=1;
    ot=on_table;
    for i=1:12
        if i<7%first 6 with same color
            temp=mode(ot(:,4));
            same_color=ot(temp,1:3);
            from=same_color(i,1:3);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%send message to robot
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            while received~=1
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%receive message from robot
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %waiting to complete picking up 
            end
            cellx=0;
            celly=i;
            [x,y]=cell2coord(cellx, celly);
        else%last 6 with same shape
            temp=mode(ot(:,5));
            same_shape=ot(temp,1:3);
            from=same_shape(i-6,1:3);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%send message to robot
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            while received~=1
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%receive message from robot
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %waiting to complete picking up 
            end
            cellx=10;
            celly=i-6;
            [x,y]=cell2coord(cellx, celly);
        end
        to=[x,y];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%send message to robot
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        while received~=1
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%receive message from robot
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %waiting to complete picking up  
        end 
    end
end

%% general functions
% function [x,y]=cell2coord(cellx, celly)
% % 579 313
% % 1018 760
%     x_dist=54.92;
%     y_dist=54.92;
%     
%     x=549.57+x_dist/2+(celly-1)*x_dist;
%     y=911.45-y_dist/2-(cellx-1)*y_dist;
% %     y=313+(cellx-1)*y_dist;
%     if celly==0
%         x=417.14+x_dist/2;
%         y=911.45-y_dist/2-(cellx-1)*y_dist;
%     elseif celly==10
%         x=1120+x_dist/2;
%         y=911.45-y_dist/2-(cellx-1)*y_dist;
%     end
% end

% function coord2cell(result1)
% global on_table not_inside_grid on_board on_deck1 on_deck2
% global board_stat deck1_stat deck2_stat
% global detection_State
%     x_gap=54.5611;
%     y_gap=54.9671;
%     
%     temp=find(result1(:,6)==1);
%     on_table=result1(temp,:);
%     on_table(:,3)=on_table(:,3)*-1;
%     temp=find(on_table(:,7)==0);
%     on_table(:,2)=1200-on_table(:,2);
%     detection_State.on_table_TBframe=on_table;
%     not_inside_grid=on_table(temp,1:5);
%     not_inside_grid=table2global(not_inside_grid);
%     
%     temp=find(on_table(:,7)==1);
%     on_board=on_table(temp,1:5);
%     x=on_board(:,1); y=1200-on_board(:,2);
%     for i=1:length(x)
%         celly=ceil((x(i)-563)/x_gap);
%         cellx=ceil((y(i)-284)/y_gap);
%         if cellx==0, cellx=1; end;
%         if cellx==10, cellx=9; end;
%         if celly==0, celly=1; end;
%         if celly==10, celly=9; end;
%         board_stat(cellx,celly,1)=on_board(i,4);
%         board_stat(cellx,celly,2)=on_board(i,5);
%     end
%     on_board=table2global(on_board);
%     
%     temp=find(on_table(:,7)==2);
%     on_deck1=on_table(temp,1:5);
%     y=1200-on_deck1(:,2);
%     for i=1:length(y)
%         cellx=ceil((y(i)-284)/y_gap);
%         if cellx==0, cellx=1; end;
%         if cellx==7, cellx=6; end;
%         deck1_stat(cellx,1,1)=on_deck1(i,4);
%         deck1_stat(cellx,1,2)=on_deck1(i,5);
%     end
%     on_deck1=table2global(on_deck1);
%     
%     temp=find(on_table(:,7)==3);
%     on_deck2=on_table(temp,1:5);
%     y=1200-on_deck2(:,2);
%     for i=1:length(y)
%         cellx=ceil((y(i)-284)/y_gap);
%         if cellx==0, cellx=1; end;
%         if cellx==7, cellx=6; end;
%         deck2_stat(cellx,1,1)=on_deck2(i,4);
%         deck2_stat(cellx,1,2)=on_deck2(i,5);
%     end
%     on_deck2=table2global(on_deck2);
%     on_table=table2global(on_table);
%     
%     detection_State.on_table=on_table;
%     detection_State.not_inside_cell=not_inside_grid;
%     detection_State.deck1_coord=on_deck1;
%     detection_State.deck2_coord=on_deck2;
%     detection_State.board_coord=on_board;
%     detection_State.deck1_matrix=deck1_stat;
%     detection_State.deck2_matrix=deck2_stat;
%     detection_State.board_matrix=board_stat;
% end

% function cor=table2global(cor)
%     temp = 0.6667.*(1200-cor(:,2)-285.72)+175;
%     cor(:,2) = 0.6667.*(cor(:,1)-797.14);
%     cor(:,1) = temp;
% end

% function cor=conveyor2global(cor)
%     temp = 0.75*(1200-cor(:,2)-525)+0;
%     cor(:,2) = 0.75*(cor(:,1)-869)+409;
%     cor(:,1) = temp;
% end

% function send_message(vacuum)
% global msgPos
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%send message to robot
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end

%% callback function for key press detection
% function getKey(handle,evt,idx)
% global datakey
%     key = double(get(handle, 'CurrentCharacter'));
%     datakey=[idx,key];
%     disp(datakey);
%     %idx points to cameras
%     %ASCII values
%     %left is 28
%     %right is 29
%     %up is 30
%     %down is 31
% end
% 
% %% callback function for debounce
% function resetKey(handle,evt)
%     global datakey
%     datakey = [];
%     disp(datakey);
%     %set datakey to 0, stop action if key is released
% end