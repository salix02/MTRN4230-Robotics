function ready_next_turn()
% ready_next_turn - Helper function, set state for next turn
% inputs no arguments
% outputs none
% author: Sean Thompson
% Last modified: 15/11/2017
   global handleboard game_state block_queue turn_data vidvars;
    update_player_prompt('Moving robot for vision detection');
    Move2PresetPos(0);
    waitWhileBusy();
    video_detection(vidvars.vid1,vidvars.vid2,vidvars.handle);

    block_queue = [];%irrespective of who's turn it is the block_queue should always be cleared
    turn_data.action_made = false;
    turn_data.need_reload_decks = false;
    turn_data.swap_state = 0; % NOT swapping
    % change to next player
    game_state.current_player = get_next_player(game_state.current_player);
    % upate screen
    set(handleboard.pattern_select_Panel.Children, 'Enable', 'on');
    set(handleboard.Button_ReadJSON, 'Enable', 'on');
    update_for_turn();
end

