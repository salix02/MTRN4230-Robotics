function p1deckcallback(hObject, eventdata, handles)
% p1deckcallback - callback for player 1 selecting blocks to place 
%   by clicking the block icon within the player 1 deck
%   Unused in current version of system, 
%       part of alternative pattern selection implementation
% inputs: hObject - the object the callback is called on
%         eventdata - unused in this callback
%         handles - currently unused
% outputs none
% uses globals to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 13/11/2017
    global handleboard board_buttons turn_data;

    deck_cell_ind = 1+(handleboard.Button_p11.Position(2) - eventdata.Source.Position(2))/59;
    if any(turn_data.decks(1, deck_cell_ind, 1:2)==0)
        % can't select an empty slot in deck
        disp('DEBUGGING: selected empty deck space');
        return
    elseif turn_data.decks(1, deck_cell_ind, 3)==true
        % can't select an already placed deck block
        disp('DEBUGGING: selected deck block already used');
        return

    elseif (turn_data.selected_deck_block_index ~= false)
        % prev block selected but not put on board, user changed their mind
        % unselect the previous block
        board_buttons.p1(turn_data.selected_deck_block_index).Text = '';
        % set selected index to the new index
        turn_data.selected_deck_block_index = deck_cell_ind;
    end
    % set selected block to selected, visually
    turn_data.selected_deck_block_index = deck_cell_ind;
    fprintf('DEBUGGING clicked: deck_cell_ind: %d\n', deck_cell_ind);
    fprintf('DEBUGGING clicked: cell: %d shp:%d clr:%d\n', deck_cell_ind, turn_data.decks(1, deck_cell_ind, 1), turn_data.decks(1, deck_cell_ind, 2));
    eventdata.Source.Text = 'Selected';
end

