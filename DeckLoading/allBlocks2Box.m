%% question 1.5
% This function moves blocks from the table onto the box up to the
% available spaces available in box.
% Jie Zhu, Joseph Salim
% 171115
function allBlocks2Box()
    global detection_State
    temp1=[detection_State.not_inside_cell;detection_State.board_coord];
    temp2=detection_State.box_og;
    len=min(length(temp1(:,1)),length(temp2(:,1)));
    for i=1:len
        msgPos=[temp1(i,1),temp1(i,2),157,temp1(i,3)];
        PickUp(msgPos(1:2),msgPos(4));
        msgPos=[temp2(i,1),temp2(i,2),32,-1*detection_State.orientation_box];
        PutDown(msgPos(1:2),msgPos(4));
    end
end