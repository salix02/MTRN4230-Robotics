function cellcallback(hObject, eventdata, handles)
% cellcallback - board any grid cell callback function
%     NOTE the board_stat coordinate callculation within this function is 
%     dependent on the position of the buttons relative to Button_11 and their
%     current size and spacing.
%     If the buttons are resized or rearranged the current implementation 
%     WILL BREAK and will need to be updated
% inputs: hObject - the object the callback is called on
%         eventdata - unused in this callback
%         handles - currently unused
% outputs: none
% uses globals to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 15/11/2017
    global debug_state AI handleboard p1 board_stat turn_data game_state board_buttons block_queue;
    if (~turn_data.action_made)
        % ONLY allow pattern to be placed if not already done
        % find selected cell coordinates to set board_stat appropriately
        % dependent on positions of buttons relative to Button_11, and current
        % size and spacing
        % Buttons have width 60 and height 60 (with 1 pixel overlap)
        %   gives effective button size for calculation 59 (hence magic 59
        %    divisor in calculation below)
        colcoord = 1+(handleboard.Button_11.Position(1) - eventdata.Source.Position(1))/-59;
        rowcoord = 1+(handleboard.Button_11.Position(2) - eventdata.Source.Position(2))/59;

        % PATTERN SELECTOR TO BOARD
        %   DOES NOT TAKE BLOCK SELECTION FROM DECKS
        fprintf('DEBUGGING board cell clbk: p1=[%d,%d]\n', p1(1), p1(2));
        if board_stat(rowcoord, colcoord, 1) ~= 0
            update_player_prompt('You have tried to place a block where one exists already.\n')
        end
        
        if(p1(1)~=0 && p1(2)~=0)
            %Push requested moves into a queue to be evaluated at the end of a
            %turn
            if isempty(block_queue)
                block_queue = [rowcoord colcoord p1];
            else
                block_queue = [block_queue; [rowcoord colcoord p1]];
            end
            % set the board cell icon to the chosen block
            picked=pick(p1);
            eventdata.Source.Icon = picked;
            % DEBUGGING block_queue changes on pattern placement
            disp('DEBUGGING: block queue due to pattern click:');
            disp(block_queue);

        else
            % this the board cell has been cleared
            % remove the icon to show as clear
            eventdata.Source.Icon  = '';
            % update board_stat to show the cell as clear
            board_stat(rowcoord, colcoord, 1) = 0;
            board_stat(rowcoord, colcoord, 2) = 0;
        end    
        % DEBUGGING with detection_State spoofer, 
        if debug_state.use_detection_spoofer
            warning('Grid cell callback using detection_State spoofer, disable for actual use');
            spoofer_cell_update(rowcoord, colcoord, p1);
        end
    end
end

