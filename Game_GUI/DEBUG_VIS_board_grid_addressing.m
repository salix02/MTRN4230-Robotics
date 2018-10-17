function DEBUG_VIS_board_grid_addressing()
% DEBUG_VIS_board_grid_addressing - Debugging visualisation function, labels board grid buttons with their indices
%   in the 2D board_buttons.grid array, to confirm array indices match button layout
% inputs none
% outputs none
% author: Sean Thompson
% Last modified: 08/11/2017
    global board_buttons;
    for row = [1:9]
        for col = [1:9]
            board_buttons.grid(row,col).Text = sprintf('r%dc%d', row, col);
        end
    end
end

