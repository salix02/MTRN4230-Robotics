function clear_board_deck_buttons()
% clear_board_deck_buttons clear the icons from board grid and both decks
% inputs no arguments
% outputs none
% author: Sean Thompson
% Last modified: 10/11/2017
    global board_buttons;
    % clear the board grid
    set(board_buttons.grid, 'Icon', '');
    % clear p1 deck
    set(board_buttons.p1, 'Icon', '');
    % clear p2 deck
    set(board_buttons.p2, 'Icon', '');
    DEBUGGING_clear_board_deck_text();
end
