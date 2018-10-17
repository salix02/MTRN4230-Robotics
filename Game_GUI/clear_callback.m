function clear_callback(hObject, eventdata, handles)
% clear_callback  - callback for the pattern clear button
% inputs: hObject - the object the callback is called on
%         eventdata - unused in this callback
%         handles - currently unused
% outputs none
% uses globals to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 14/11/2017

% callback for clear move button
    global board_buttons block_queue turn_data;
    % clear the prompt to player, since it is likely historical
    update_player_prompt('Move Cleared\nMake a Move or Swap Your Deck');
    if (~turn_data.action_made)
        % can only clear chosen move if not yet confirmed
        % block_queue format: [rowPos colPos shape colour]
        sz_block_queue = size(block_queue);
        for rowInd = 1:sz_block_queue(1);
            % reset the board grid buttons from the placed pattern, to blank
            board_buttons.grid(block_queue(rowInd, 1), block_queue(rowInd, 2)).Icon = '';
            board_buttons.grid(block_queue(rowInd, 1), block_queue(rowInd, 2)).Text = '';
        end

        % empty block_queue for the new choice of pattern
        block_queue = [];
    end
end

