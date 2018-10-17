%% This function moves the robot arm to preset position
% 0 moves to callibration position
% 1 moves to table home
% 2 moves to conveyor home
% 3 moves to conveyor blocking
% Joseph Salim
% 171115

function Move2PresetPos(PresetPos)
    global MvSocket;
    
    switch PresetPos
        case 0   
            msg = '6_0';
        case 1
            msg = '6_1';
        case 2
            msg = '6_2';
        case 3
            msg = '6_3';
    end
            
    fwrite(MvSocket,msg) 
    pause(0.15);
end
 