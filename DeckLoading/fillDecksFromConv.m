%% This function fills both decks with blocks from the box in conveyor 
% Jie Zhu, Joseph Salim
% 171115
function fillDecksFromConv()
    global detection_State
    inbox=detection_State.in_box;
    for i=1:6
        msgPos=[inbox(i,1),inbox(i,2),32,inbox(i,3)];
        PickUp(msgPos(1:2),msgPos(4));
        if(i == 1)
            %I'm not sure why, but it seems like the first put down's get
            %skipped with the same wait time as everything else.
            pause(0.05);
        end
        %pause(0.15);
        msgPos=[detection_State.deck1x(i),detection_State.deck1y,157];
        PutDown(msgPos(1:2),0);
        %pause(0.15);
    end
    for i=1:6
        msgPos=[inbox(i,1),inbox(i,2),32,inbox(i,3)];
        PickUp(msgPos(1:2),msgPos(4));
        %pause(0.15)
        msgPos=[detection_State.deck2x(i),detection_State.deck2y,157];
        PutDown(msgPos(1:2),0);
        %pause(0.15);
    end
end