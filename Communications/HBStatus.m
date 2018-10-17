%% HB polling
% This function polls the server which is connected by socket "HBSocket"
% which is pecified in the input argument as a string. It returns the
% status of IOs and robot status.
% Output from the HBStatus function
% DI = Vars(1);
% DO = Vars(2:5);
% EStop = Vars(6);
% LightCurtain = Vars(7);
% Hold2En = Vars(8);
% MotorStat = Vars(9);
% MotionTrig = Vars(10);
% ExeErr = Vars(11);
% TaskExe = Vars(12);
% NotMoving = Vars(13); % 0 = Moving 1 = Not Moving
% Angles = Vars(14:19);
% Pos = Vars(20:22);
% Quat = Vars(23:26);
% Joseph Salim
% 171115

function [IO, JointAng, Pos, Quat] = HBStatus(HBSocket)
    global handleboard
    global vacuum
    
    % Check if still open
    if(~isequal(get(HBSocket, 'Status'), 'open'))
        warning(['Could not open TCP connection to HBSocket possibly port 2016']);
        return;
    end

    fwrite(HBSocket, '1');
    pause(0.1);
    HBTimer = tic;
    while HBSocket.BytesAvailable < 70
        % Wait for reply
        HBRespTime = toc(HBTimer);
        if HBRespTime > 20 % Timeout = 20 seconds (arbitrarily assigned)
            logMsg = 'COMMUNICATION TIMEOUT; CONNECTION LOST';
            disp(logMsg);
            % ERROR HANDLING HERE - PLACEHOLDER FOR NOW
            pause(5);
            return;
        end
    end
    %pause(1); %Arbitrary long wait time to ensure response is fully sent

    Msg = char(fread(HBSocket, HBSocket.BytesAvailable, 'char'))';

    Vars = sscanf(Msg, '%d_%d_%d_%d_%d_%d_%d_%d_%d_%d_%d_%d_%d_[%f,%f,%f,%f,%f,%f]_[%f,%f,%f]_[%f,%f,%f,%f]');

    IO = Vars(1:13);
    JointAng = Vars(14:19);
    Pos = Vars(20:22);
    Quat = Vars(23:26);
    
    % set global variable vacuum to determine whether pickup or putdown is
    % to be called
    vacuum = IO(3);
    
    % reversing the value just so it looks right for GUI implementation.
    if(IO(10) == 1)
        IO(10) = 0;
    else
        IO(10) = 1;
    end
    
    if(IO(11) == 1)
        IO(11) = 0;
    else
        IO(11) = 1;
    end
    
    % Put handles in array ordered by their order in message
    lampHandles = [handleboard.Estop_error_Lamp, handleboard.light_curtain_Lamp, ...
        handleboard.hold_enable_error_Lamp, handleboard.motor_off_error_Lamp, ...
        handleboard.motion_supervision_error_Lamp, handleboard.execution_error_Lamp];
    
    for i = 1:6
        if IO(i+5) == 0 %Error state
            lampHandles(i).Color = [1 0 0]; %red
        else
            lampHandles(i).Color = [0 1 0]; %green
        end
    end
    
end