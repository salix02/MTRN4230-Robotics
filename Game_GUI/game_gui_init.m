function game_gui_init()
% game_gui_init  Initialisation for game GUI
% inputs no arguments
% outputs none
% last edited: Sean Thompson
% Last modified: 15/11/2017
    global handleboard board_buttons turn_data;
    
    % User can't make a move before the game has started
    set_enable_game_controls(false);
    % make it so scores are only displayed, not editable by users
    handleboard.P1_Field_Turn_Score.Editable = 'off';
    handleboard.P1_Field_Total_Score.Editable = 'off';
    handleboard.P2_Field_Turn_Score.Editable = 'off';
    handleboard.P2_Field_Total_Score.Editable = 'off';

    % make the board buttons addressable
    % need minimum 2 buttons to make array
    board_buttons.grid = [handleboard.Button_11, handleboard.Button_12];
    for colInd=[3:9]
        board_buttons.grid = [board_buttons.grid, eval(sprintf('handleboard.Button_1%d', colInd))];
    end
    for rowInd = [2:9]
        grid_row = [eval(sprintf('handleboard.Button_%d1', rowInd)), eval(sprintf('handleboard.Button_%d2', rowInd))];
        %grid_row = eval(sprintf('[handleboard.Button_%d1, handleboard.Button_%d2]', rowInd));
        for colInd = [3:9]
            grid_row = [grid_row, eval(sprintf('handleboard.Button_%d%d', rowInd, colInd))];
        end
        board_buttons.grid = [board_buttons.grid; grid_row];
    end
    % Only for DEBUGGING board addressing setup, leave commented out in working system
    % DEBUG_VIS_board_grid_addressing();

    % initialise per turn global variables
    turn_data.action_made = false;
    turn_data.need_reload_decks = false;
    turn_data.swap_state = 0; % ie swap not started
    disp('DEBUGGING: game_gui_init() completed');
end
