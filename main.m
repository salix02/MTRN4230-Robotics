%% This script has the main function which starts up the GUI, connection to robot studio, Video Processing and Global Variable declarations
% Joseph Salim, Alvin Yap, Jie Zhu, Sean Thompson
% 171115

function mainmain()
    global handleboard
    try
        delete(handleboard.UIFigure);
    catch
    end
    instrreset; close all; clear all; %deletes old sockets and video feeds
    
    warning off;

    robot_IP_address = '192.168.125.1';
    %robot_IP_address = '127.0.0.1';

    global MvSocket;
    global HBSocket;

    global game_state;
%         global handleboard;
%         global deck;%
%         global p1;%[shape, color] temp for player selection
%         global board_stat;%desired board stat
%         global AI;%The functions That handle parsing of the quirkleboard rules
%         global board_buttons;
    

    % Assuming Game_GUI.m is the startup point for the app
    % setup searchpath for functions and scripts in subfolders
    working_dir = pwd;
    % TODO new_main may be renamed to video_detection in future
    addpath(strcat(working_dir, '.\new_main'));
    addpath(strcat(working_dir, '.\Communications'));
    addpath(strcat(working_dir, '.\Game_GUI'));
    addpath(strcat(working_dir, '.\QuirkleLogic'));
    addpath(strcat(working_dir, '.\DeckLoading'));
    %% set up
    GameStateInit();  
    MvSocket = CommSetUp(robot_IP_address, 1025);
    HBSocket = CommSetUp(robot_IP_address, 1026);

    
    %% example on using Move2Pos (I don't think we need any other move commands
    % If I want to move robot to position blah
    % XYZ = [300,0,147];
    % speed, mode and quat are optional. 
    % Move2Pos(XYZ, speed, mode, quat), remember to transform your values
    % to the correct frame values
    % Move2Pos(XYZ);
    
    % preset position 0 callibration, 1 table home, 2 conv home, 3 conv
    % block
    % Move2PresetPos(0);
    
    
    
    online=true;
    global detection_State
    % detection_State.grid_coord=2;
    
    %% OFFLINE TESTING Commented this line out 
    global vidvars;
    [vid1,vid2,handle]=start_vid(online);
    vidvars.vid1 = vid1;
    vidvars.vid2 = vid2;
    vidvars.handle = handle;
    
    Game_GUI
    
    drawnow;
    pause(10); % let GUI load because Alvin and Joseph needs a new laptop
    
    HBRun = true;
    
    disp('Polling');
    
    HBCounter = 0;
    while true
        HBCounter = HBCounter + 1;
        if online==1
            video_detection(vid1,vid2,handle);
        end
       %% Information gathering
%        robot status
        if(HBCounter == 2)
            [IO, JointAng, Pos, Quat] = HBStatus(HBSocket);
        %        qwirkle status
            HBCounter = 0;
        end
       
       % Move2Pos(XYZ);
       pause(0.15);
    end
end

%% Initalise the sytem-wide game state
function GameStateInit()
global game_state debug_state;
game_state.game_started = false;
game_state.current_player = 1;
game_state.p2_is_AI = false;
game_state.gui_paused = false;
game_state.robot_paused = false;
debug_state.use_detection_spoofer = false;
end
