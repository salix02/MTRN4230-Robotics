function swap_deck_button_callback(hObject, eventdata, handles)
% swap_deck_button_callback  GUI callback for the Swap Deck In/Out Button
% author: Sean Thompson
% Last modified: 15/11/2017
global handleboard board_buttons turn_data game_state vidvars;
   switch turn_data.swap_state
   case {0,1}
       % 1st click
       update_player_prompt('Robot Swapping Out Deck to Box.\nMoving to calibation');
       turn_data.swap_state = 1;
       % Move Robot to to Calibration position for video detection run
       Move2PresetPos(0);
       waitWhileBusy();
       video_detection(vidvars.vid1,vidvars.vid2,vidvars.handle);

       EmptyDeck(game_state.current_player);
       % signal starting swap
       set(handleboard.pattern_select_Panel.Children, 'Enable', 'off');
       set(handleboard.Button_ReadJSON, 'Enable', 'off');

       waitWhileBusy();
       update_player_prompt('Robot Finished Swapping Out Deck to Box');
       hObject.Text = 'Swap Deck In';
       turn_data.swap_state = 2;
   case {2,3}
       update_player_prompt('Robot Started Swapping In new Deck From Box');
       fillDeck(vid1, vid2, handle);
       waitWhileBusy();
       update_player_prompt('Robot Finished Swapping In new Deck From Box');
       turn_data.swap_state = 0;
       hObject.Text = 'Swap Deck Out';
       turn_data.action_made = true;
       ready_next_turn();
end
