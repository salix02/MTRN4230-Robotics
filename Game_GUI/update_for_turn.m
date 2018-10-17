%% helper function to set GUI elements state as appropriate
%%   for current player
function update_for_turn()
% update_for_turn - set GUI elements state (enabled, disabled)
%   appropriately based on which player is the current player
% inputs none
% outputs none
% uses globals to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 07/11/2017
global game_state handleboard board_buttons;
    switch game_state.current_player
    case 1,
        handleboard.player_indicator_Label.Text = 'P1 Turn';
        update_player_prompt('P1 Start Turn');
        % Enable p1 controls, disable p2
        set(board_buttons.p1, 'Enable', 'on');
        set(board_buttons.p2, 'Enable', 'off');
    case 2,
        if game_state.p2_is_AI
            handleboard.player_indicator_Label.Text = 'P2 AI Turn';
            update_player_prompt('P2 AI Turn Started');
            % Enable p2 controls, disable p1
            set(board_buttons.p2, 'Enable', 'off');
            set(board_buttons.p1, 'Enable', 'off'); 
        else
            handleboard.player_indicator_Label.Text = 'P2 Turn';
            update_player_prompt('P2 Start Turn');
            % Enable p2 controls, disable p1
            set(board_buttons.p2, 'Enable', 'on');
            set(board_buttons.p1, 'Enable', 'off');
        end
    end
end

