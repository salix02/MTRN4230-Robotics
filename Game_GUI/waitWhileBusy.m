function waitWhileBusy()
% Continues receiving heartbeat from robot while waiting for it to signal
% that it is not busy (i.e. queue empty).
% Author: Alvin Yap
% Last modified: 15/11/2017

global HBSocket;

moving = 1;

while moving
    % Information gathering
    % robot status
    [IO, JointAng, Pos, Quat] = HBStatus(HBSocket)
    % qwirkle status
    % Move2Pos(XYZ);
    moving = ~IO(13);
    pause(0.1)
end
end