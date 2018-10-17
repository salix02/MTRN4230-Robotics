%% This function sorts out blocks by colour and places them onto the decks
% Jie Zhu, Joseph Salim
% 171115

function fillDecksFromTable()
    global detection_State
    ontable=detection_State.on_table;
    color=mode(ontable(:,4));
    shape=find(ontable(:,4)~=color);
    color=find(ontable(:,4)==color);
    color=ontable(color,:);
    shape=ontable(shape,:);
    for i=1:6
        msgPos=[color(i,1),color(i,2),157,color(i,3)];
        PickUp(msgPos(1:2),msgPos(4));
        if(i == 1)
            pause(0.5); % The first putdown get's skipped sometimes with the default pause, so add extra.
        end
        pause(0.15);
        msgPos=[detection_State.deck1x(i),detection_State.deck1y,157];
        PutDown(msgPos(1:2),0);
        pause(0.15);
    end
    for i=1:6
        msgPos=[shape(i,1),shape(i,2),32,shape(i,3)];
        PickUp(msgPos(1:2),msgPos(4));
        if(i == 1)
            pause(0.5); % The first putdown get's skipped sometimes with the default pause, so add extra.
        end
        pause(0.15);
        msgPos=[detection_State.deck2x(i),detection_State.deck2y,157];
        PutDown(msgPos(1:2),0);
        pause(0.15);
    end
end