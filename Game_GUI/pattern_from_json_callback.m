function pattern_from_json_callback(hObject, eventdata, handles)
% pattern_from_json_callback   callback to read & display JSON file specifying move to make
% inputs: hObject - the object the callback is called on
%         eventdata - unused in this callback
%         handles - currently unused
% outputs none
% uses globals to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 14/11/2017
    global board_buttons game_state block_queue turn_data;

    if turn_data.action_made
        update_player_prompt('You have already confirmed a move this turn.');
    else
        % uigetfile usage ref
        % [fileName,pathName,filterIndex] = uigetfile(FilterSpec,DialogTitle)
        [fileName,pathName,filterIndex] = uigetfile('*.txt','Move Blocks JSON txt file Select');
        pattern_json_file_fullpath = strcat(pathName, fileName);
        % fprintf('DEBUGGING: ReadJSON: chsn filepath: %s\n', pattern_json_file_fullpath);
        pattern_json_txt = fileread(pattern_json_file_fullpath);
        block_structs_from_json = jsondecode(pattern_json_txt);
        json_pattern_valid = true;
        % TODO there is no guarantee that the blocks are added to the block_queue in the order
        %   required by the QuirkleBoard legality check logic
        %   so even a legal move may be rejected due to this
        %   FIX THIS
        for block_struct = block_structs_from_json'
            % disp('DEBUGGING trans(block_structs_from_json)');
            % disp(block_structs_from_json');
            % disp('DEBUGGING item block_struct');
            % disp(block_struct);

            block_data = Block();
            block_data.row = block_struct.row;
            block_data.column = block_struct.column;
            block_data.shape = block_struct.shape;
            block_data.colour = block_struct.colour;
            % TODO json parse to block_queue logic
            if ~((block_data.shape_value >=1) && (block_data.shape_value <= 6) && (block_data.colour_value >=1) && (block_data.colour_value <=6))
                json_pattern_valid = false;
                break;
            end
            % block is on-board, visually place
            board_buttons.grid(block_data.row, block_data.column).Icon = pick([block_data.shape_value, block_data.colour_value]);
            % block_queue format: [rowPos colPos shape colour]
            block_queue = [block_queue; [block_data.row, block_data.column, block_data.shape_value, block_data.colour_value]];
        end
        if json_pattern_valid
            update_player_prompt('Move Pattern From JSON Displayed.\nConfirm to make move.');
        else
            update_player_prompt('Pattern From JSON contained illegal block positions.\nUpdate JSON file or select Pattern using GUI.');
        end
    end
end

