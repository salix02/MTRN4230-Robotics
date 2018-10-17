function add_turn_score_player(player_to_add_score, score_add)
% add_turn_score_player  - Helper function for adding score for turn
% inputs:
%       player_to_add_score - 1 or 2 for player to increase score off
%       score_add - amount to add to score
% outputs none
% uses global handleboard to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 13/11/2017
    global handleboard;
    if player_to_add_score == 1
        handleboard.P1_Field_Total_Score.Value = handleboard.P1_Field_Total_Score.Value + score_add;
        handleboard.P1_Field_Turn_Score.Value = score_add;
    else
        % player_to_add_score == 2
        handleboard.P2_Field_Total_Score.Value = handleboard.P2_Field_Total_Score.Value + score_add;
        handleboard.P2_Field_Turn_Score.Value = score_add;
    end
end

