% Game_GUI the main startup script for the Quirkle playing GUI
% author: Sean Thompson
% Last modified: 15/11/2017

%TODO remove this debuggingInit once finished
%DEBUGGING_Init();

global game_state;
global handleboard;
global deck;%
global p1;%[shape, color] temp for player selection
global block_queue;% The queue of blocks that the player wishes to place this turn;
global board_stat;%desired board stat
global AI;%The functions That handle parsing of the quirkleboard rules
global board_buttons;
global turn_data; % struct of board and deck state including pending moves
p1=zeros(1,2);%shape and color
board_stat=zeros(9,9,2);%2 9*9 matrix for shape and color
AI = QuirkleBoard();
deck = zeros(2, 2, 6); %The blocks both players have in their deck: [player 1, player 2]*[shape, colour]*6 slots

handleboard=game_gui_app();
% disable game controls until the game is started
game_gui_init();

set(handleboard.Button_square,'Icon','square.png');
set(handleboard.Button_diamond,'Icon','diamond.png');
set(handleboard.Button_circle,'Icon','circle.png');
set(handleboard.Button_club,'Icon','club.png');
set(handleboard.Button_cross,'Icon','cross.png');
set(handleboard.Button_star,'Icon','star.png');

set(handleboard.Button_red,'Icon','red.png');
set(handleboard.Button_orange,'Icon','orange.png');
set(handleboard.Button_green,'Icon','green.png');
set(handleboard.Button_yellow,'Icon','yellow.png');
set(handleboard.Button_blue,'Icon','blue.png');
set(handleboard.Button_purple,'Icon','purple.png');

% Set Pattern selection button callbacks
set(handleboard.Button_square,'ButtonPushedFcn', @square);
set(handleboard.Button_diamond,'ButtonPushedFcn', @diamond);
set(handleboard.Button_circle,'ButtonPushedFcn', @circle);
set(handleboard.Button_club,'ButtonPushedFcn', @club);
set(handleboard.Button_cross,'ButtonPushedFcn', @cross);
set(handleboard.Button_star,'ButtonPushedFcn', @star);
set(handleboard.Button_red,'ButtonPushedFcn', @red);
set(handleboard.Button_orange,'ButtonPushedFcn', @orange);
set(handleboard.Button_green,'ButtonPushedFcn', @green);
set(handleboard.Button_yellow,'ButtonPushedFcn', @yellow);
set(handleboard.Button_blue,'ButtonPushedFcn', @blue);
set(handleboard.Button_purple,'ButtonPushedFcn', @purple);

set(handleboard.Button_clear,'ButtonPushedFcn', @clear_callback);
set(handleboard.Button_confirm,'ButtonPushedFcn', @confirm_move_callback);
set(handleboard.Button_ReadJSON,'ButtonPushedFcn', @pattern_from_json_callback);


% Game Control Buttons
set(handleboard.PauseButton, 'ValueChangedFcn', @pausebuttoncallback);
set(handleboard.StartGameButton, 'ButtonPushedFcn', @startgamebuttoncallback);
set(handleboard.Button_EndTurn, 'ButtonPushedFcn', @endturnbuttoncallback);
set(handleboard.Button_ClearTable, 'ButtonPushedFcn', @cleartablecallback);

% setup p1 deck buttons
board_buttons.p1 = [handleboard.Button_p11, handleboard.Button_p12, handleboard.Button_p13, handleboard.Button_p14, handleboard.Button_p15, handleboard.Button_p16];
%set(board_buttons.p1, 'ButtonPushedFcn', @p1deckcallback);

% setup p2 deck buttons
board_buttons.p2 = [handleboard.Button_p21, handleboard.Button_p22, handleboard.Button_p23, handleboard.Button_p24, handleboard.Button_p25, handleboard.Button_p26];
%set(board_buttons.p2, 'ButtonPushedFcn', @p2deckcallback);

% set all board grid buttons to use the cellcallback function
set(handleboard.board_grid_Panel.Children, 'ButtonPushedFcn', @cellcallback);

set(handleboard.Button_LoadDecks, 'ButtonPushedFcn', @load_decks_button_callback);
set(handleboard.SwapDeckOutButton, 'ButtonPushedFcn', @swap_deck_button_callback);
set(handleboard.ConveyorSwitch, 'ValueChangedFcn', @Conveyorcallback);


%% shape call back functions
function square(hObject, ~, handles)
    global handleboard p1;
%     temp=get(handleboard.Button_square,'Icon');
    p1(1)=1;
%     set(handleboard.Button_l1,'Icon','square.png');
end

function diamond(hObject, eventdata, handles)
    global p1;
    p1(1)=2;
end

function circle(hObject, eventdata, handles)
    global p1;
    p1(1)=3;
end

function club(hObject, eventdata, handles)
    global p1;
    disp('DEBUGGING: club pattern select pressed');
    p1(1)=4;
end

function cross(hObject, eventdata, handles)
    global p1;
    p1(1)=5;
end

function star(hObject, eventdata, handles)
    global p1;
    p1(1)=6;
end

%% color call back functions
function red(hObject, eventdata, handles)
    global p1;
    p1(2)=1;
end

function orange(hObject, eventdata, handles)
    global p1;
    p1(2)=2;
end

function green(hObject, eventdata, handles)
    global p1;
    p1(2)=4;
end

function yellow(hObject, eventdata, handles)
    global p1;
    p1(2)=3;
end

function blue(hObject, eventdata, handles)
    global p1;
    p1(2)=5;
end

function purple(hObject, eventdata, handles)
    global p1;
    disp('DEBUGGING: purple pattern select pressed');
    p1(2)=6;
end
