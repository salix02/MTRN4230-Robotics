function startgamebuttoncallback(hObject, eventdata, handles)
% startgamebuttoncallback  - callback for the Start Game Button of Game GUI
% inputs: hObject - the object the callback is called on
%         eventdata - unused in this callback
%         handles - currently unused
% outputs none
% uses global handleboard to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 15/11/2017

    global handleboard game_state block_queue turn_data;
    if game_state.game_started
        % User selected to quit current game, to start a new game

        % TODO implement
        % Do any stop and cleanup of robot actions as needed
        StopNCleanQueue;        

        % finalising
        % reset button text
        hObject.Text = 'Start Game';
        % enable AI vs 2p choice for next game
        handleboard.Switch_AI_2p.Enable = 'on';
        set_enable_game_controls(false);
        clear_board_deck_buttons();
        game_state.game_started = false;
        % Reset Scores for new game
        handleboard.P2_Field_Total_Score.Value = 0;
        handleboard.P2_Field_Turn_Score.Value = 0;
        handleboard.P1_Field_Total_Score.Value = 0;
        handleboard.P1_Field_Turn_Score.Value = 0;
        % reset block queue for new game
        block_queue = [];
    else
        %Starting a new game
        % get choice to play 2 player or vs AI
        if (strcmp(handleboard.Switch_AI_2p.Value, '2 Player'))
            game_state.p2_is_AI = false;
        else
            game_state.p2_is_AI = true;
        end
        % disable the Switch_AI_2p while the game is active
        handleboard.Switch_AI_2p.Enable = 'off';
        %reset the current player to 1 for new game
        game_state.current_player = 1;
        turn_data.action_made = false;
        turn_data.need_reload_decks = false;
        turn_data.swap_state = 0; %ie swap not started
        set_enable_game_controls(true);
        update_for_turn();
        update_from_detection();
        % reset block queue for new game
        block_queue = []; 
        game_state.game_started = true;
        % hObject is the StartGameButton here
        hObject.Text = 'End Current Game';
    end
end

