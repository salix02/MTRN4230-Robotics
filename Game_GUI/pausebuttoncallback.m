function pausebuttoncallback(hObject, eventdata, handles)
% pausebuttoncallback - callback for the Pause GUI button
%   allows game to be toggled paused and resumed,
%   disables GUI elements to prevent interaction while paused
%   and visually signal the paused state.
%   Sends message to robot to pause and resume motion
% inputs: hObject - the object the callback is called on
%         eventdata - unused in this callback
%         handles - currently unused
% outputs none
% uses globals to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 15/11/2017
disp('DEBUGGING: pause state button value changed');
global handleboard game_state board_buttons MvSocket
new_gui_pause_state = ~game_state.gui_paused;
% disable the board grid and player decks while the game is paused
if game_state.game_started
    % only change state of game controls if the game has already started
    % in false case, pause is used to pause robot motion for non-game task
    set_enable_game_controls(~new_gui_pause_state);
    % disable off turn player controls again
    if game_state.current_player == 1
        set(board_buttons.p2, 'Enable', 'off');
    else
        % game_state.current_player == 2
        set(board_buttons.p1, 'Enable', 'off');
    end
end
game_state.gui_paused = new_gui_pause_state;
if (new_gui_pause_state)
    update_player_prompt('System Paused.');
else
    update_player_prompt('System Resumed');
end
% TODO call to pause or resume robot motion goes here
if game_state.gui_paused
    msg = '5_1'; % Message to resume
else
    msg = '5_0'; % Message to pause
end
%SEND TO ROBOT STUDIO
fwrite(MvSocket, msg);
end

