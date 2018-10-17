function Conveyorcallback(hObject, ~) %, eventdata, handles)    
% Conveyorcallback - callback for the Conveyor Control Switch
% inputs: hObject - the object the callback is called on
% outputs none
% author: Oliver Mcdonald
% Last modified: 15/11/2017
    global MvSocket
    
    %freeze all GUI buttons
    set_enable_game_controls(false)
    
    if strcmp(hObject.Value, hObject.Items{2})
        %%%%%%%%%%%%insert box (to robot)%%%%%%%%%%%%%%
        %move arm horizontally above conveyor
        %Move2PresetPos(2)
        %block the conveyor belt for box
        Move2PresetPos(3)
        
        switchCOnDir = 1;   
        %switchConMov = 1;
    else 
        %%%%%%%%%%%%%%%reload box (from robot)%%%%%%%%%%%%%
        switchCOnDir = 0;   
        %switchConMov = 1;
    end
    
    %set direction
    msg = sprintf('4_4_%1d', switchCOnDir);
    disp(msg);
    % send to robot studio
    fwrite(MvSocket, msg); 
    pause(0.15);
    
    %run conveyor
    msg2 = sprintf('4_3_1');
    disp(msg2);
    fwrite(MvSocket, msg2);
        
    %pause for 9.5s
    pause_while_gathering_info(6) %Seems like there's a system lag of about 3.5s

    %stop conveyor
    msg2 = sprintf('4_3_0');
    disp(msg2);
    fwrite(MvSocket, msg2);
    pause(0.15);
    
    Move2PresetPos(1);
    
    %unfreeze all G UI buttons
    set_enable_game_controls(true)
end

