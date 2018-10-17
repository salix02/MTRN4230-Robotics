function confirm_move_callback(hObject, eventdata, handles)
% confirm_move_callback - callback for confirming the placed pattern as the desired move
%   check the legality of the move chosen with the pattern selector
% inputs: hObject - the object the callback is called on
%         eventdata - unused in this callback
%         handles - currently unused
% outputs none
% uses globals to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 15/11/2017
    global handleboard board_stat deck block_queue game_state turn_data AI;

    % %As a matter of course find out if the detected board is a legal one:
    % isLegal = AI.isLegalBoard(board_stat)
    update_from_detection()
    if isempty(block_queue)
        update_player_prompt('Illegal Move: You have not placed a pattern of blocks for your move.\nMake a Legal Move or Swap your Deck.');
        return;
    elseif (turn_data.action_made)
        % already confirmed the move, cannot confirm it again
        update_player_prompt('You have already confirmed your move');
        return;
    end
    [newBoard, newDeck, newScore] = AI.makeMove(board_stat, squeeze(deck(game_state.current_player, :, :))', block_queue);
    % TODO reject illegal moves, allowing illegal moves here to test other functionality
    % warning('Illegal moves allowed for debugging');
    if newScore < 0
        %TODO: request a deck swap.
        update_player_prompt('Illegal Move: Make a legal move or Swap your Deck');
        return
    % TODO reject illegal moves, allowing illegal moves here to test other functionality
    % warning('Illegal moves allowed for debugging');
    else
        % Positive score, therefore a legal move has been made
        % 
        % Convert block_queue to format expected by setBoard(blocks_matrix)
        % block_queue format: [rowPos colPos shape colour]
        sz_block_queue = size(block_queue);
        fprintf('DEBUGGING: size(block_queue):\n');
        disp(sz_block_queue);
        % blocks_to_place format: [playerNum,colour,shape,rowID,columnID], 1 row per block
        blocks_to_place = zeros(sz_block_queue(1), 5);
        fprintf('DEBUGGING: size(blocks_to_place):\n');
        disp(size(blocks_to_place));
        % set the player placing the blocks (always current player)
        blocks_to_place(:, 1)  = game_state.current_player;
        % set row and column indices
        blocks_to_place(:, 4:5) = block_queue(:, 1:2);
        % set shape
        blocks_to_place(:,3) = block_queue(:, 3);
        % set color
        blocks_to_place(:,2) = block_queue(:, 4);

        % Place the legal move, using the robot
        % TODO make this actually call setBoard
        update_player_prompt('Robot Placing Move');
        disp('DEBUGGING:setBoard(blocks_to_place), blocks_to_place=');
        disp(blocks_to_place);
        setBoard(blocks_to_place);
        pause(0.2);
        % wait until the robot has finished placing all the blocks
        % disable controls while waiting
        set_enable_game_controls(false);
        waitWhileBusy();
        % re-controls now that waiting for the robot is done
        set_enable_game_controls(true);
        update_for_turn();
        % disable pattern selector since confirmed move has been placed
        set(handleboard.pattern_select_Panel.Children, 'Enable', 'off');
        % Update scores
        add_turn_score_player(game_state.current_player, newScore);
        board_stat = newBoard;
        deck(game_state.current_player, :, :) = newDeck';
        % signal change in actions-within-turn state
        update_player_prompt('Reload Deck required');
        turn_data.action_made = true;
        turn_data.need_reload_decks = true;
    end
end

