%% This function sorts out blocks by colour and places them onto the decks
% Jie Zhu, Joseph Salim
% 171115
function fillDeck(vid1,vid2,handle)
    global detection_State
    counter=0;
    Move2PresetPos(0);%move calib position
    pause(10);%wait 7 secs
    video_detection(vid1,vid2,handle);%call detection
    inbox=detection_State.in_box;
    idx_deck1=find(detection_State.deck1_matrix(:,:,1)==0);
    idx_deck2=find(detection_State.deck2_matrix(:,:,1)==0);
    try
        deck1=detection_State.deck1x(idx_deck1);
        temp=-230*ones(length(deck1));
        deck1=[deck1;temp];
        for i=1:length(deck1(1,:))
            msgPos=[inbox(i,1),inbox(i,2),32,inbox(i,3)];
            PickUp(msgPos(1:2),msgPos(4));
            msgPos=[deck1(1,i),deck1(2,i),157];
            PutDown(msgPos(1:2),0);
            counter=counter+1;
        end
    catch
    end
    
    try
        deck2=detection_State.deck2x(idx_deck2);
        temp=230*ones(length(deck2));
        deck2=[deck2;temp];
        for i=1:length(deck2(1,:))
            msgPos=[inbox(i+counter,1),inbox(i+counter,2),32,inbox(i+counter,3)];
            PickUp(msgPos(1:2),msgPos(4));
            msgPos=[deck2(1,i),deck2(2,i),157];
            PutDown(msgPos(1:2),0);
        end
    catch
    end

end