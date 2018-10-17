function setBoard(inMatrix)
% Reads a matrix composed of rows indicating each block to be placed, and
% sends the commands required to robot studio to execute the movements. It
% is assumed that all blocks are available in the correct deck. Input is
% expected to be in the form of an n x 5 matrix (n < 12: limited by sizes
% of decks). The five columns in the matrix are expected to be
% [playerNum,colour,shape,rowID,columnID], indicating which deck, what
% colour block, what shape block, row on board to move it to, and column on
% board to move it to respectively.
% Author: Alvin Yap
% Last modified: 15/11/2017

global detection_State

sortedCoord1 = sortrows(detection_State.deck1_coord);
sortedCoord2 = sortrows(detection_State.deck2_coord);
deck1 = detection_State.deck1_matrix;
deck2 = detection_State.deck2_matrix;

for row = 1:size(inMatrix,1)
    blockColour = inMatrix(row,2);
    blockShape = inMatrix(row,3);
    boardRow = inMatrix(row,4);
    boardCol = inMatrix(row,5);
    
    if inMatrix(row, 1) == 1 % if playerNum == 1
        % Search for block in decks - searches occupied positions only
        idx = find(deck1(deck1(:,:,1)~=0, 1) == blockColour ...
            & deck1(deck1(:,:,2)~=0, 2) == blockShape);
        deckXY = sortedCoord1(idx,1:2);
        deckAngle = sortedCoord1(idx,3);
         % Block has been moved; remember this without needing to run video detection again
        deck1(idx,:,:) = 0;
        sortedCoord1(idx,:) = [];
    else
        idx = find(deck2(deck2(:,:,1)~=0,1) == blockColour ...
            & deck2(deck2(:,:,2)~=0,2) == blockShape);
        deckXY = sortedCoord2(idx,1:2);
        deckAngle = sortedCoord2(idx,3);
        % Block has been moved; remember this without needing to run video detection again
        deck2(idx,:,:) = 0;
        sortedCoord2(idx,:) = [];
    end
    
    disp(deckXY);
    
    % Pick up block
    PickUp(deckXY, deckAngle);
    
    % Put down block
    PutDown([detection_State.boardx(boardRow), detection_State.boardy(boardCol)],0);
    
    % Pause and wait for robot to finish? TEST QUEUING
end

end