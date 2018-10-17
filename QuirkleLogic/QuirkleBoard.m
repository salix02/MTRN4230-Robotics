%%Thi class represents a quirkle board and everything you could possibly
%want to do with a quirkle board.
%FORMAT for board pieces. Each element of the board is an uint16. Each bit
%of the int32 represents a particular attibute to make it very easy to
%check stuff by & things together. see the difinitions at the top of this
%file for exact implementation

classdef QuirkleBoard<handle
    properties
        Grid %This is the layou of the board as it currently exists
        ConceivableMoves % A logical grid containing elements where a move could potentially be made
        allowableMoves%another logical grid containing moves that are legal to make (subset of ConceivableMoves)
        GridSize = [9 9];
        %MASKS:
        squareM  = uint16(bin2dec('1000000000000000'));
        diamondM = uint16(bin2dec('0100000000000000'));
        circleM  = uint16(bin2dec('0010000000000000'));
        clubM    = uint16(bin2dec('0001000000000000'));
        crossM   = uint16(bin2dec('0000100000000000'));
        starM    = uint16(bin2dec('0000010000000000'));
        
        redM     = uint16(bin2dec('0000000000000001'));
        orangeM  = uint16(bin2dec('0000000000000010'));
        yellowM  = uint16(bin2dec('0000000000000100'));
        greenM   = uint16(bin2dec('0000000000001000'));
        blueM    = uint16(bin2dec('0000000000010000'));
        purpleM  = uint16(bin2dec('0000000000100000'));
        
        colourM  = uint16(bin2dec('0000000011111111'));
        shapeM   = uint16(bin2dec('1111111100000000'));
    end
    
    methods
        function obj = QuirkleBoard(obj)
            %% myQuirkleBoard = QuirkleBoard(). The constructor.
            
            obj.Grid = zeros(obj.GridSize, 'uint16');
        end
        
        function obj = getConceivableMoves(obj)
            %%This function examins the internal representation of the
            %board and calculates the moves that could happen with no
            %constraints placed on which pieces you have
            %%
            %make a temporary grid 1 bigger to avoid edge cases
            moves = false(obj.GridSize + 2);
            tmpGrid = zeros(size(moves), 'uint16');
            tmpGrid(2:end - 1, 2:end - 1) = obj.Grid;
            
            for i = 2:obj.GridSize - 1
                for j = 2:obj.GridSize - 1
                    moves(i, j) = tmpGrid(i+1, j) || tmpGrid(i-1, j) || tmpGrid(i, j+1)|| tmpGrid(i, j-1);
                end
            end
            %you can't place a block where there is already a block:
            moves = moves & ~tmpGrid;
            %downsize grid now we have successfully ignored edge cases:
            obj.ConceivableMoves = moves(2:end - 1, 2:end - 1);
        end
        
        
        function blocks = parseInputBlocks(obj, bl)
            %% This function parses the matrix of blocks as they were presented in assignment 1,
            %and returns a vector of blocks as uint16s
            %%
            if size(bl, 2) ~= 7
                error('the size of the input matrix is not correct. It should be n x 7, just like assignment 1')
            elseif find(bl(:, 4) < 0 | bl(:, 4) > 6)
                error('one or more of your blocks contains an illegal colour. Should be in the range 0-6')
            elseif find(bl(:, 5) < 0 | bl(:, 5) > 6)
                error('one or more of your blocks contains an illegal shape. Should be in the range 0-6')
            end
            if find(bl(:, 4) == 0)
                warning('some of the blocks are inverted! ignoring them...')
                mask = bl(:, 4) == 0;
                bl(mask, :) = [];
            end
            blocks = zeros(size(bl, 1), 1, 'uint16');
            blocks = bitor(blocks , bitshift(obj.squareM, -(bl(:, 5) - 1)));
            %             dec2bin(blocks, 16)
            blocks = bitor(blocks , bitshift(obj.redM,  (bl(:, 4) - 1)));
            %             dec2bin(blocks, 16)
        end
        
        function block = parsePl(obj, pl)
            %% this function converts a block of the type [shape, colour]
            %to the uint16 type that is more convenient for the AI
            %%
            if size(pl, 1) ~= 1 && size(pl, 2 ~= 2)
                error('the size of the input matrix is not correct. It should be 1 x 2')
            elseif find(pl < 0 | pl > 6)
                error('Either the position or the size of pl is out of range. Should be in the range 0-6')
            end
            
            %for convenience of masking, empty spaces are all ones, not
            %zeros
            if(pl(1) == 0 && pl(2) == 0)
                block = uint16(2^16-1);
%                 dec2bin(block, 16)
                return;
            end
            
            block = uint16(0);
            block = bitor(block , bitshift(obj.squareM, -(pl(1) - 1)));
            block = bitor(block , bitshift(obj.redM,  (pl(2) - 1)));
        end
        function obj = parseInputBoard(obj, board)
            %%This function parses the board as it is present in the gui
            %and updates Grid
            %%
            if ~isequal(size(board), [9 9 2])
                error('The size of the board in the gui appears not to be correct! should be 9*9*2')
            end
            
            for i = 1:obj.GridSize(1)
                for j = 1:obj.GridSize(2)
                    obj.Grid(i, j) = obj.parsePl(squeeze(board(i, j, :))');
                end
            end
        end
        
        function isLegal = isLegalMove(obj, board, pl, pos)
            %This function checks if the block pl placed at the position
            %pos is against the rules for the board passed in as an
            %argument. Takes in arguments of the format the gui uses.
            if find(pos < 0 | pos > 9)
                error('pos is out of range. all elements should be in range 1-9')
            end
            
            %first update board:
            parseInputBoard(obj, board);
            move = obj.parsePl(pl);
            
            isLegal = isLegalParsed(obj, move, pos);
        end
        
        function isLegal = isLegalBoard(obj, board)
            %% This function takes in a board as it is represented in the gui and detemins if
            %the configuration of the board is a legal one.
            if ~isequal(size(board), [9, 9, 2])
                warning('The size of the board is wrong, should be 9*9*2');
                isLegal = -1;
                return;
            elseif numel(find(board < 0 | board > 6, 1)) > 0
                warning('The board appears to have numbers outside the allowed bounds of 0 and 6')
                isLegal = -2;
                return
            elseif find(xor(squeeze(board(:, :, 1)), board(:, :, 2)), 1)
                warning('it is illegal for a board to have a zero for shape/colour and a nonzero value for the other attribute')
                isLegal = -3;
                return;
            end
            
            if isempty(find(board, 1))
                warning('The board is empty, which is legal')
                isLegal = 1;
                return;
            end
            obj.parseInputBoard(board);
            
            %Check if the blocks are sitting next to an allowed block (does
            %not check if they are sitting by themselves)
            
            %check if the blocks horizontally next to each other are in the
            %allowed configuration
            h1 = obj.Grid (:, 2:end);
            h2 = obj.Grid(:, 1:end-1);
            isAllowedH = bitand(h1 , h2) == 0;
            
            v1 = obj.Grid(1:end - 1, :);
            v2 = obj.Grid(2:end, :);
            isAllowedV = bitand(v1 , v2) == 0;
            if ~(isempty(find(isAllowedH, 1)) && isempty(find(isAllowedV, 1)))
                warning('adjacent blocks must be of the same type or colour');
                isLegal = -5;
                return;
            end
            
           %Now check in a really horribe manner if there are any blocks by
           %themselves
           [rows, cols] = find(obj.Grid ~= uint16(2^16-1));
           for i = 1:length(rows)
               posToCheck = zeros(4, 2);
               posToCheck(1, :) = [rows(i)    , cols(i) + 1];
               posToCheck(2, :) = [rows(i)    , cols(i) - 1];
               posToCheck(3, :) = [rows(i) + 1, cols(i)    ];
               posToCheck(4, :) = [rows(i) - 1, cols(i)    ];
               %is the move is placed on the edge of the board then some of
               %the positions do not need to be checked:
               mask = posToCheck(:, 1) <= 0 | posToCheck(:, 2) <= 0 | posToCheck(:, 2) > 9 | posToCheck(:, 1) > 9;
               posToCheck(mask, :) = [];
               posToCheck = sub2ind(size(obj.Grid), posToCheck(:, 1), posToCheck(:, 2));
               if numel(find(obj.Grid(posToCheck) ~= uint16(2^16-1))) == 0
                   isLegal = -4;
                   return
               end
           end
            isLegal = 2;
        end
        
        function isLegal = isLegalParsed(obj, move, pos)
            %% Find if a requested move given by the uint16 block 
            %is legal according to the board as it exists currently in
            %obj.Grid. This function should not be accessed outside this
            %class
            %%
            if obj.Grid(pos(1), pos(2), 1) ~= uint16(2^16-1)
%                 warning('you have tried to place a block where one exists already. Of course this isnt legal!')
                isLegal = -1;
                return
            end
            
            %if this is the beginning of the game, i.e. if the board is
            %completely empty then any move is a legal one:
            if numel(find(obj.Grid ~= uint16(2^16-1))) == 0
                warning('Any move is a legal move, because there are no blocks on the board!')
                isLegal = 1;
                return
            end
            
            %check the blocks surrounding the move to determine if it is
            %legal:
            posToCheck = zeros(4, 2);
            posToCheck(1, :) = [pos(1)    , pos(2) + 1];
            posToCheck(2, :) = [pos(1)    , pos(2) - 1];
            posToCheck(3, :) = [pos(1) + 1, pos(2)    ];
            posToCheck(4, :) = [pos(1) - 1, pos(2)    ];
            %is the move is placed on the edge of the board then some of
            %the positions do not need to be checked:
            mask = posToCheck(:, 1) <= 0 | posToCheck(:, 2) <= 0 | posToCheck(:, 2) > 9 | posToCheck(:, 1) > 9;
            posToCheck(mask, :) = [];
            posToCheck = sub2ind(size(obj.Grid), posToCheck(:, 1), posToCheck(:, 2));

            %The block you place needs to be sitting next to another block
            %for it to be a legal move:
            if numel(find(obj.Grid(posToCheck) ~= uint16(2^16-1))) == 0
%                 warning('you must place a block next to another block!')
                isLegal = -2;
                return
            end

            legalMask = move;
            for i = 1:length(posToCheck)
                legalMask = bitand(legalMask, obj.Grid(posToCheck(i)));
            end
            isLegal = double(legalMask);
        end
        function [newBoard, newDeck, score, block_to_place] = getMove(obj, boardIn, deckIn)
            global debug_state game_state;
            %% For a Given board and 'deck', this function will calculate a
            %one-block move that is legal, and return that move. If no move
            %is legal, it will return the same board and deck you gave it
            %and in addition the score of the move will be -1.
            %if the move is legal, it will return the updated status of the
            %new board and deck.
            %TODO: calculate the number of points this move makes
            %%
            if ~isequal(size(deckIn), [6 2])
                error('The size of the deck should be 6x2 where [6 blocks]*[shape, colour]')
            elseif ~isequal(size(boardIn), [9 9 2])
                error('The size of the board should be 9*9*2!')
            end
            %check if this is the first move, and if so place the first
            %block in the middle
            if isempty(find(boardIn, 1))
                disp('This is the first move of the game')
                newBoard = boardIn; newDeck = deckIn;
                score = 1;
                blockIdx = find(deckIn(:, 1), 1);
                block = deckIn(blockIdx, :);
                newDeck(blockIdx, :) = 0;
                newBoard(5, 5, :) = block;%hardcoded middle of board
                % block_to_place format: [playerNum,colour,shape,rowID,columnID], 1 row per block
                block_to_place = [game_state.current_player, block(2), block(1), 5,5];
                return
            end
            %convert datatypes:
            parseInputBoard(obj, boardIn);
            
            deckConv = zeros(1, size(deckIn, 1));
            for i = 1:length(deckConv)
                deckConv(i) = obj.parsePl(deckIn(i, :));
            end
            deck = deckConv(deckIn(:, 1) ~= 0);
            newBoard = boardIn;
            newDeck = deckIn;
            
            %Parse through all possible moves to find a legal one.
            for x = 1:obj.GridSize(1)
                for y = 1:obj.GridSize(2)
                    for pl = 1:length(deck)
                        %the below check is extremely inefficient as it
                        %converts the entire board for each potential move.
                        if obj.isLegalParsed(deck(pl), [x y]) > 0
                            moveIdx = find(deckConv == deck(pl), 1);
                            newDeck(moveIdx, :) = 0;
                            block = deckIn(moveIdx, :);
                            disp('DEBUGGING AI chosen block');
                            disp(block);
                            newBoard(x, y, :) = block;
                            % block_to_place format: [playerNum,colour,shape,rowID,columnID], 1 row per block
                            block_to_place = [game_state.current_player, block(2), block(1), x,y];
                            disp('DEBUGGING AI generated block_to_place');
                            disp(block_to_place);
                            score = obj.getScore(boardIn, [x y deckIn(moveIdx, :)]);
                            disp(strcat('move  ', num2str(deckIn(moveIdx, :)), ' was made at pos  ', num2str([x y])));
                            % DEBUGGING show the AI move selected
                            % this is bad style breaking encapsulation modifying the GUI components here
                            global board_buttons;
                            board_buttons.grid(x,y).Text = 'AI move';
                            board_buttons.grid(x,y).FontColor = [1 0 1];
                            board_buttons.grid(x,y).Icon = pick(deckIn(moveIdx, :));
                            if debug_state.use_detection_spoofer
                                warning('DEBUGGING: update of detection spoof GUI active in AI');
                                spoofer_cell_update(x, y, deckIn(moveIdx, :));
                            end
                            return;
                        end
                    end
                end
            end
            score = -1;
            block_to_place  = [];
            return;
        end
        
        function [newBoard, newDeck, score] = makeMove(obj, boardIn, deckIn, moves)
            %% This function allows the player to make a move that can consist of the placement
            % of one or more blocks as per the quirkle rules. If the move
            % requested was not a legal one, then the score returned will
            % be some negative value dependant on why exactly it wasn't
            % legal.
            % Arguments:
            %boardIn - the current state of the board
            %deckIn - the players current deck (6 blocks*[shape colour])
            %moves  - a N*4 matrix where each row is a move (maximum 6)
            %   and the columns are [rowPos colPos shape colour]. This MUST
            %   be done with the blocks placed in order outwards from the other 
            %   blocks already on the board
            %%
            newBoard = boardIn;
            newDeck = deckIn;

            if isempty(moves)
                warning('you appeared to have no blocks selected for your move');
                score = -1;
                return;
            elseif size(moves, 1) > 6 || size(moves, 2) ~= 4
                warning('deckIn must be N*4 where 1 < N <= 6');
                score = -2;
                return;
            elseif ~isequal(size(boardIn), [9 9 2])
                warning('the size of the variable representing the state of the board is incorrect, must be 9*9*2')
                score = -3;
                return;
            elseif size(moves, 1) > numel(find(deckIn(:, 1) ~= 0))
                update_player_prompt('Illegal Move: You have tried to make more moves than you have blocks.\nClear your Move and make a Legal Move.');
                score = -8;
                return;
            end
            
            tmpDeck = deckIn;%just for checking if the user has enough blocks of a given type
            for i = 1:size(moves, 1)
                [~, hasBlock] = intersect(tmpDeck, moves(i, 3:4), 'rows');
                if isempty(hasBlock)
                    update_player_prompt('Illegal Move: One or more of the blocks you have in your move are not in your deck.\nClear Your Move and make a Legal Move');
                    score = -4;
                    return
                end
                tmpDeck(hasBlock(1), :) = [0 0];
            end

            if size(moves, 1) == 1
                pos = moves(1:2);
                block = moves(3:4);
                if obj.isLegalMove(boardIn, block, pos) > 0
                    newBoard(pos(1), pos(2), :) = block;
                    [~, deckIdx] = intersect(newDeck, block, 'rows'); 
                    newDeck(deckIdx, :) = 0;
                    score = obj.getScore(boardIn, moves);
                else
                    warning('the single block move you tried to make is illegal');
                    score = -7;
                end
                return;
            end
                    
            %Assert that all the blocks are in one contiguous line
            if all(moves(:, 1) == moves(1, 1))
                direction = 0;%A horizontal row
            elseif all(moves(:, 2) == moves(1, 2))
                direction = 1;%A vertical row
            else %neither i.e. the blocks are not in a line
                warning('the blocks of your move are not placed in a line');
                score = -5;
                return;
            end
            
            %now validate that the move is a valid one. The below for loop
            %is why it is necessary for all the blocks to be in the correct
            %order.
            for i = 1:size(moves, 1)
                pos = moves(i, 1:2);
                block = moves(i, 3:4);
                if obj.isLegalMove(newBoard, block, pos)
                    newBoard(pos(1), pos(2), :) = block;
                    [~, deckIdx] = intersect(newDeck, block, 'rows'); 
                    newDeck(deckIdx, :) = 0;
                else
                    warning(strcat('the move:', num2str(moves(i, :)), 'is not a valid one. Check that you placed the blocks in the right order.'));
                    newBoard = boardIn;
                    newDeck = deckIn;
                    score = -6;
                    return;
                end
            end
            
            %make sure that each row and column has a common shape or
            %colour:
            for i = 1:size(moves, 1)
                pos = moves(i, 1:2);
                
                for j = 1:2%Shape, colour
                    rowPos = find(newBoard(pos(2):end, pos(1), j) == 0, 1) - 1;
                    rowNeg = find( fliplr(newBoard(1:pos(2), pos(1), j) == 0)) + pos(1) - 1;
                end
            end
            score = obj.getScore(boardIn, moves);
        end
        
        function score = getScore(obj, board, moves)
        %% This function should never be called outside this class.
        % It assumes that the move requested is legal
        %it takes in a board as it is present in the GUI, moves as they are
        %present in makeMove and returns the score.
        %%
        
        %add the moves to the board:
        shapes = sub2ind(size(board), moves(:, 1), moves(:, 2), ones(length(moves(:, 1)), 1));
        colours = sub2ind(size(board), moves(:, 1), moves(:, 2), 2*ones(length(moves(:, 1)), 1));
        board(shapes) = moves(:, 3);
        board(colours) = moves(:, 4);
        
        %this is a *horrible* way to calculate score, but can't think of a
        %nice one right now
        addedBlocks = [];
        quirkle = 0;
        for i = 1:size(moves, 1)
            quirkleCount = 0;
            row = moves(i, 1);
            col = moves(i, 2);
            %search down:
            while  row > 0 && board(row, col) ~= 0
                addedBlocks = [addedBlocks sub2ind(obj.GridSize, row, col)];
                row = row - 1;
                quirkleCount = quirkleCount + 1;
            end
            %search up:
            row = moves(i, 1);
            while row < size(obj.Grid, 1) && board(row, col) ~= 0
                addedBlocks = [addedBlocks sub2ind(obj.GridSize, row, col)];
                row = row + 1;
                quirkleCount = quirkleCount + 1;
            end
            if quirkleCount >= 7%+1 because the real block gets counted twice
                quirkle = quirkle + 1;
            end
            quirkleCount = 0;
            row = moves(i, 1);
            
            %search left:
            while col > 0 && board(row, col) ~= 0
                addedBlocks = [addedBlocks sub2ind(obj.GridSize, row, col)];
                col = col - 1;
                quirkleCount = quirkleCount + 1;
            end
            
            col = moves(i, 2);
            %search right:
            while col < size(obj.Grid, 2) && board(row, col) ~= 0
                addedBlocks = [addedBlocks sub2ind(obj.GridSize, row, col)];
                col = col + 1;
                quirkleCount = quirkleCount + 1;
            end
            if quirkleCount >=7
                quirkle = quirkle + 1;
            end
        end
        if quirkle > 0
            disp('Its a quirkle!');
        end
        score = length(unique(addedBlocks)) + 6*(quirkle > 0);%can't get more than one quirkle in one turn
        end
    end
end




















