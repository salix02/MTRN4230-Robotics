function endturnbuttoncallback(hObject, eventdata, handles)
% endturnbuttoncallback  callback for the End Turn Button of Game GUI
% inputs: hObject - the object the callback is called on
%         eventdata - unused in this callback
%         handles - currently unused
% outputs none
% uses global handleboard to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 14/11/2017
    global handleboard deck AI board_stat game_state turn_data block_queue;
    if (~turn_data.action_made)
        update_player_prompt('Make a move or Swap your deck before ending turn');
        % TODO prompt the player on the GUI with this message
    elseif (turn_data.need_reload_decks)
        update_player_prompt('Reload your deck before ending turn');
        % TODO prompt the player on the GUI with this message
    else
        fprintf('it is end of player %d''s turn\n', game_state.current_player);

        update_from_detection();
        
        update_gui_using_state();

        % other end of turn logic
        ready_next_turn();
     
        % Make the AI take its turn
        if (game_state.current_player == 2) && game_state.p2_is_AI
            AI_take_turn();
        end
    end
end

