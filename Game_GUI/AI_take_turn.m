function AI_take_turn()
% AI_take_turn - function to make the AI player take the actions for its turn
% inputs none
% outputs none
% uses globals to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 13/11/2017
    global game_state deck board_stat AI handleboard;
    warning('AI move support is incomplete, it tries to make a move based on P2s hand');
    if isempty(find(deck(2, :, :), 1))
        warning('The deck of player 2 appears to be empty. Put something in it, then try again');
        return
    end
    % known the AI only makes 1 block moves
    [newBoard, newDeck, newScore, block_to_place] = AI.getMove(board_stat, squeeze(deck(2, :, :))');
    if newScore < 0
        warning('No legal move could be found, SHOULD call a SWAP DECK');
        % TODO
        % call for a swap deck
        %return
    end
    add_turn_score_player(game_state.current_player, newScore);
    board_stat = newBoard;
    deck(game_state.current_player, :, :) = newDeck';

    % TODO make this actually call setBoard
    disp('DEBUGGING:setBoard(block_to_place), block_to_place=');
    disp(block_to_place);
    %setBoard(block_to_place);
    update_gui_using_state();
    % TODO make AI set to need a deck refill and indicate this to the human player

    % AI ending its turn
    disp('DEBUGGING: AI ending turn');
    ready_next_turn();
end

