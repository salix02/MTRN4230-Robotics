%% Robot movement commands
% This function send a command to robot studio to move to certain position
% specified by input arguments.
% XYZ is position of robot z = 0
% speed is speed of movement
% quat is endeffector orientation
% mode: 0 for linear, 1 for joint
% Joseph Salim
% 171115

function Move2Pos(XYZ, speed, mode, quat)
    global MvSocket;
    if(~isequal(get(MvSocket, 'Status'), 'open'))
        warning('MvSocket is not connected, possibly port 2015');
        return;
    end
    
    switch nargin
        case 1
            msg = sprintf('3_1_100_[%.2f,%.2f,%.2f]_[0,0,-1,0]', XYZ);
        case 2
            msg = sprintf('3_1_%.2f_[%.2f,%.2f,%.2f]_[0,0,-1,0]', speed, XYZ);
        case 3
            msg = sprintf('3_%1d_%.2f_[%.2f,%.2f,%.2f]_[0,0,-1,0]', mode, speed, XYZ);
        case 4
            msg = sprintf('3_%1d_%.2f_[%.2f,%.2f,%.2f]_[%1d,%1d,%1d,%1d]', mode, speed, XYZ, quat);
    end      
    
    fwrite(MvSocket, msg);
    
    
end

