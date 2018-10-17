function next_player = get_next_player(current_player)
% next_player - get the next player index - convenience function
% inputs: current_player - the index of the current player: 1 or 2
% outputs: next_player - the index of the next player: 1 or 2
% author: Sean Thompson
% Last modified: 07/10/2017
switch current_player
case 1,
    next_player = 2;
case 2,
    next_player = 1;
end
return
end
