% A function to empty a player's deck by moving the blocks to the conveyor
% Jie Zhu, Joseph Salim
% 171115
function EmptyDeck(playerDeck)
    global detection_State
    
    
    if playerDeck == 1
        deckCoord = detection_State.deck1_coord;
    else
        deckCoord = detection_State.deck2_coord;
    end
    
    temp1=deckCoord;
    temp2=detection_State.box_og;
    len=min(length(temp1(:,1)),length(temp2(:,1)));
    
    for i=1:len        
        msgPos=[deckCoord(i,1:2),157, deckCoord(i,3)];
        PickUp(msgPos(1:2),msgPos(4));
        
        msgPos=[temp2(i,1),temp2(i,2),32,-1*detection_State.orientation_box];
        PutDown(msgPos(1:2),msgPos(4));
    end
end