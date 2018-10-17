function DEBUGGING_enable_player_deck(playerToEnable)
% DEBUGGING_enable_player_deck - Enable selected players deck, debugging utility function
% inputs 1 or 2, player to enable deck of
% outputs none
% uses globals to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 15/11/2017

    global board_buttons;
    switch playerToEnable
    case 1,
        set(board_buttons.p1, 'Enable', 'on');
    case 2,
        set(board_buttons.p2, 'Enable', 'on');
    end
end
