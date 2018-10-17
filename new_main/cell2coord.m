function [x,y]=cell2coord(cellx, celly)
%cell2coord
%   it takes cell index and converts them to actual coordinates in robot
%   frame.
%   the function uses boardx, boardy, deck1x, deck1y, deck2x, deck2y in
%   global struct detecton State
    
global detection_State
% 579 313
% 1018 760
%     x_dist=54.92;
%     y_dist=54.92;
%     
%     x=549.57+x_dist/2+(celly-1)*x_dist;
%     y=911.45-y_dist/2-(cellx-1)*y_dist;
    if celly~=0 && celly~=10
    x=detection_State.boardy(celly);
    y=detection_State.boardx(cellx);
%     y=313+(cellx-1)*y_dist; 
    elseif celly==0
        x=detection_State.deck1y(celly+1);
        y=detection_State.deck1x(cellx);
%         x=417.14+x_dist/2;
%         y=911.45-y_dist/2-(cellx-1)*y_dist;
    elseif celly==10
        x=detection_State.deck2y(celly-9);
        y=detection_State.deck2x(cellx);
%         x=1120+x_dist/2;
%         y=911.45-y_dist/2-(cellx-1)*y_dist;
    end
end