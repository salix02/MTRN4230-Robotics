%% This function takes a single block from the box in the conveyor and places it in the deck
% Jie Zhu, Joseph Salim
% 171115

function loadSingle()
    global detection_State
    msgPos=[detection_State.in_box(1,1),detection_State.in_box(1,2),detection_State.in_box(1,3)];
    PickUp(msgPos(1:2),msgPos(4));
    msgPos=[detection_State.deck1x(1),detection_State.deck1y,157];
    PutDown(msgPos(1:2),0);
end
