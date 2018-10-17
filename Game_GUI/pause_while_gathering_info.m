
function pause_while_gathering_info(time) 
%%  pause_while_gathering_info  - Information gathering whilst pausing 
% inputs: time (time is in seconds)
% outputs none
% author: Oliver Mcdonald
% Last modified: 08/11/2017
    repeat = time*10;
    global HBSocket;
    
    for n = 1:repeat
    % Information gathering
    % robot status
    [IO, JointAng, Pos, Quat] = HBStatus(HBSocket)
    % qwirkle status
    % Move2Pos(XYZ);

    pause(0.1)
    end
end
