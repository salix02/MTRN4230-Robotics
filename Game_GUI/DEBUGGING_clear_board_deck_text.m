function DEBUGGING_clear_board_deck_text()
% DEBUGGING_clear_board_deck_text   clear text from the grid and both deck buttons
% inputs no arguments
% outputs none
% author: Sean Thompson
% Last modified: 13/11/2017
    global board_buttons;
    % clear the board grid
    set(board_buttons.grid, 'Text', '');
    % clear p1 deck
    set(board_buttons.p1, 'Text', '');
    % clear p2 deck
    set(board_buttons.p2, 'Text', '');
end
