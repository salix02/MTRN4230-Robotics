function update_from_detection()
% update_from_detection - Update board and deck state as displayed on GUI 
%   from lastest block detection from video feed
%  NOTE this DOES NOT trigger video detection or move the robot
% inputs: none
% outputs: none
% uses globals to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 10/11/2017
global board_buttons detection_State board_stat deck turn_data;
disp('DEBUGGING update from detection call');
for row=[1:9]
    for col=[1:9]
        square_state = [detection_State.board_matrix(row,col,2), detection_State.board_matrix(row,col,1)];
        if not(any(square_state==0))
            % block in space
            board_buttons.grid(row,col).Icon = pick(square_state);
        else
            % blank space
            board_buttons.grid(row,col).Icon = '';
        end
        turn_data.grid(row,col,1) = square_state(1);
        turn_data.grid(row,col,2) = square_state(2);
        board_stat(row, col, :) = square_state;
    end
end
% Update P1 deck
for deck_cell=[1:6]
    % note detection_State.deck1_matrix(cell_ind, player, col=1_shp=2)
    square_state = [detection_State.deck1_matrix(deck_cell,1,2), detection_State.deck1_matrix(deck_cell,1,1)];
    fprintf('DEBUGGING update frm detect: dk1 sqrstate:[%d,%d]\n',square_state(1), square_state(2));
    if not(any(square_state==0))
        board_buttons.p1(deck_cell).Icon = pick(square_state);
    else
        % blank space
        board_buttons.p1(deck_cell).Icon = '';
    end
    turn_data.decks(1,deck_cell, 1) = square_state(1);
    turn_data.decks(1,deck_cell, 2) = square_state(2);
    deck(1, :, deck_cell) = square_state;
end
% Update P2 deck
for deck_cell=[1:6]
    % note detection_State.deck1_matrix(cell_ind, player, col=1_shp=2)
    square_state = [detection_State.deck2_matrix(deck_cell,1,2), detection_State.deck2_matrix(deck_cell,1,1)];
    fprintf('DEBUGGING update frm detect: dk2 sqrstate:[%d,%d]\n',square_state(1), square_state(2));
    if not(any(square_state==0))
        board_buttons.p2(deck_cell).Icon = pick(square_state);
    else
        % blank space
        board_buttons.p2(deck_cell).Icon = '';
    end
    turn_data.decks(2,deck_cell, 1) = square_state(1);
    turn_data.decks(2,deck_cell, 2) = square_state(2);
    deck(2, :, deck_cell) = square_state;
end
end

