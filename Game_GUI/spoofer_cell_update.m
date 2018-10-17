function spoofer_cell_update(rowcoord, colcoord, p1)
% function to update the grid spoofer gui 
%   and spoofed detection_State.board_matrix
% for use with spoofer grid button callback and game gui grid callback
% author: Sean Thompson
% Last modified: 10/11/2017
    global detection_State spoofer_buttons;
    if(p1(1)~=0 && p1(2)~=0)
        % set the board cell icon to the chosen block
        picked=pick(p1);
        spoofer_buttons.grid(rowcoord, colcoord).Icon = picked;
        % note detection_State.deck1_matrix(cell_ind, player, col=1_shp=2)
        % p1(shape,color)
        detection_State.board_matrix(rowcoord, colcoord, 2) = p1(1);
        detection_State.board_matrix(rowcoord, colcoord, 1) = p1(2);

    else
        % this the board cell has been cleared
        % remove the icon to show as clear
        spoofer_buttons.grid(rowcoord, colcoord).Icon  = '';
        % update board_stat to show the cell as clear
        detection_State.board_matrix(rowcoord, colcoord, 1) = 0;
        detection_State.board_matrix(rowcoord, colcoord, 2) = 0;
    end    
end
