function load_decks_button_callback(hObject, eventdata, handles)
% load_decks_button_callback - call back for Button_LoadDecks
% inputs: hObject - the object the callback is called on
%         eventdata - unused in this callback
%         handles - currently unused
% outputs: none
% uses globals to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 14/11/2017
    global turn_data;
    if (~turn_data.need_reload_decks || ~turn_data.action_made)
        update_player_prompt('Cannot reload deck until you have made a move');
        % TODO show this message in prompt on GUI
    else
        % TODO get robot to reload decks
        warning('reload decks call to Robot missing');
        % TODO
        % Use vision detection to actually confirm the decks have been successfully loaded 
        %   before considering them reloaded
        turn_data.need_reload_decks = false;
        update_player_prompt('Reloading Deck Complete.\nReady to End Turn.');
    end
end

