function getMousePositionOnImage(handle,evt,idx)
%getMousePositionOnImage
%   this is the call back funtion for live video feed GUI.
%   it converts a click in the video into global frames.
%   it can choose if the centroid of block is desired or the centre of the
%   cell is required or the actual location is needed.
%   it also checks the status of board and decks by output matrix stored in
%   global struct dection_State.
%   the click of position is stored in msgPos in struct for sending to
%   robot studio side.
global datacursor msgPos vacuum board_stat deck1_stat deck2_stat
global detection_State
received=1;
% detection_State.grid_coord=1;%check if need to return cell number or actual location!!!!!!!!!
cursorPoint = get(handle, 'CurrentPoint');
curX = cursorPoint(1,1)*1600;
curY = cursorPoint(1,2)*1200;
%     handle.UserData=[curX,curY];
datacursor=[idx,curX,curY];
%     disp(datacursor);
%idx points to cameras
x_gap=54.92;%54.5611;
y_gap=54.92;%54.9671;

tabScaleX = 0.6575;
tabScaleY = 0.6575;
conScaleX = 0.75;
conScaleY = 0.75;

if vacuum == 1 % Snap to grid if possible for putting down
    detection_State.grid_coord = 1;
else
    detection_State.grid_coord = 2;
end

%check cell number of board
if idx==1 && detection_State.grid_coord==1%548.57 914.25, 1043 414.3
    if curX>548 && curX<1045.7 && curY>417.14 && curY<914.25
        celly=ceil((curX-548)/x_gap);
        cellx=ceil((abs(curY-1200)-285.72)/y_gap);
        if cellx==0, cellx=1; end;
        if cellx==10, cellx=9; end;
        if celly==0, celly=1; end;
        if celly==10, celly=9; end;
    end
    %cleck player1 deck
    if curX>417.14 && curX<474.28 && curY>580 && curY<914.25
        celly=0;
        cellx=ceil((abs(curY-1200)-285.72)/y_gap);
        if cellx==0, cellx=1; end;
        if cellx==7, cellx=6; end;
    end
    %check player2 deck
    if curX>1120 && curX<1174.3 && curY>580 && curY<914.25
        celly=10;
        cellx=ceil((abs(curY-1200)-293)/y_gap);
        if cellx==0, cellx=1; end;
        if cellx==7, cellx=6; end;
    end
    %display for debugging
    if exist('celly','var') && exist('cellx','var')
        fprintf('grid number is %d,%d\n', cellx, celly);%%%%%%%%%%%%%%%
        detection_State.msgPos_grid=[cellx,celly];
        [x,y]=cell2coord(cellx, celly);
        msgPos(1) = y;%tabScaleY*(1200-y-285.72)+175;
        msgPos(2) = x;%tabScaleX*(x-797.14);
        msgPos(3) = 157;
        msgPos(4) = 0; %ANGLE IN RADIANS
    else
        disp(datacursor);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        msgPos(1) = tabScaleY*(1200-curY-285.72)+175;
        msgPos(2) = tabScaleX*(curX-797.14);
        msgPos(3) = 157;
        msgPos(4) = 0; %ANGLE IN RADIANS
    end
elseif idx==1 && detection_State.grid_coord==0
    disp(datacursor);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    msgPos(1) = tabScaleY*(1200-curY-285.72)+175;
    msgPos(2) = tabScaleX*(curX-797.14);
    msgPos(3) = 157;
    msgPos(4) = 0; % ANGLE IN RADIANS
elseif idx==1 && detection_State.grid_coord==2
    disp(datacursor);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    temp=[curX,curY];
    temp=sqrt((temp(1)-detection_State.on_table_TBframe(:,1)).^2+(temp(2)-detection_State.on_table_TBframe(:,2)).^2);
    idx=find(temp<25);
    try
        msgPos(1) = tabScaleY*(1200-detection_State.on_table_TBframe(idx(1),2)-285.72)+175;
        msgPos(2) = tabScaleX*(detection_State.on_table_TBframe(idx(1),1)-797.14);
        msgPos(3) = 157;
        msgPos(4) = detection_State.on_table_TBframe(idx(1),3); % ANGLE IN RADIANS
    catch
    end
elseif idx==2 && detection_State.grid_coord~=2
    disp(datacursor);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    msgPos(1) = conScaleY*(1200-curY-525)+0;
    msgPos(2) = conScaleX*(curX-834)+409;
    msgPos(3) = 32;
    msgPos(4) = -1*detection_State.in_box_CVframe(idx(1),3); % ANGLE IN RADIANS
elseif idx==2 && detection_State.grid_coord==2
    temp=[curX,curY];
    temp=sqrt((temp(1)-detection_State.in_box_CVframe(:,1)).^2+(temp(2)-detection_State.in_box_CVframe(:,2)).^2);
    idx=find(temp<25);
    try
        disp(datacursor);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        msgPos(1) = conScaleY*(1200-detection_State.in_box_CVframe(idx(1),2)-525)+0;
        msgPos(2) = conScaleX*(detection_State.in_box_CVframe(idx(1),1)-834)+409;
        msgPos(3) = 32;
        msgPos(4) = -1*detection_State.in_box_CVframe(idx(1),3); % ANGLE IN RADIANS
    catch
    end
end
disp('msgPos is');
disp(msgPos);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if vacuum==0%vacuum is off, ready to pick
%     PickUp(msgPos(1:2), msgPos(4));
% else%vacuum is on, ready to drop
%     PutDown(msgPos(1:2), msgPos(4));
% end
detection_State.msgPos=msgPos;
end