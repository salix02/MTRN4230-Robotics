function DEBUGGING_Init()
% DEBUGGING_Init - DEBUGGING initialisation intended for standalone testing of the Game_GUI.m script
%   replaces the need for setup performed by mainmain.m, to allow standalone testing
% inputs none
% outputs none
% author: Sean Thompson
% Last modified: 15/11/2017

    warning('DEBUGGING INIT running. BY THE END OF THE ASSIGNMENT, this should not run!');
    global game_state turn_data debug_state vidvars;
    game_state.gui_paused = false;
    game_state.game_started = false;
    game_state.current_player = 1;
    game_state.p2_is_AI = false;
    turn_data.selected_deck_block_index = false;
    turn_data.selected_deck_block_queue = []; % list of indices of blocks in decks used this turn
    turn_data.decks = zeros(2,6,3); % (players, (6 blocks), (shape, color, used_this_turn)
    turn_data.grid = zeros(9,9,3); % (9blocks, 9blocks, (shape, color, placed_this_turn)
    % For testing of Game_GUI alone
    % setup searchpath for functions and scripts in other subfolders
    working_dir = pwd;
    addpath(strcat(working_dir, '\..\QuirkleLogic'));
    addpath(strcat(working_dir, '\..\new_main'));
    addpath(strcat(working_dir, '\..\Communications'));
    % SET detection spoofer true or false
    debug_state.use_detection_spoofer = false;
    if debug_state.use_detection_spoofer
        Testing_Detection_Spoofer;
    end
    % startup video detection so that board config from detection
    %  can be done 
    [vidvars.vid1, vidvars.vid2, vidvars.handle ] = start_vid(false);
end
