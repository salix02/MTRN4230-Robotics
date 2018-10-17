function p2deckcallback(hObject, eventdata, handles)
% p2deckcallback - callback for player 2 selecting blocks to place 
%   by clicking the block icon within the player 2 deck
%   Unused in current version of system, 
%       part of alternative pattern selection implementation
% inputs: hObject - the object the callback is called on
%         eventdata - unused in this callback
%         handles - currently unused
% outputs none
% uses globals to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 15/11/2017
    global handleboard p1 deck;
    %TODO make the deck callback properly select blocks to place from deck to board
    %   rather than be pattern select destination as is now
    % NOTE the p1 variable is the pattern selected
    %   does not indicate player 1 or 2
    %TODO rename p1 variable
    if(p1(1)~=0 && p1(2)~=0)
        picked=pick(p1);
        % calculate offset from 1st (from top) p2 deck button
        % find selected deck cell coordinates to set deck appropriately
        % dependent on positions of buttons relative to Button_p21, and current
        % size and spacing
        % Buttons have width 60 and height 60 (with 1 pixel overlap)
        %   gives effective button size for calculation 59 (hence magic 59
        %    divisor in calculation below)
        deck_cell_ind = 1+(handleboard.Button_p11.Position(2) - eventdata.Source.Position(2))/59;
        deck(2, :, deck_cell_ind) = p1;
        set(hObject,'Icon',picked); 
    end
end

