function update_player_prompt(prompt_str)
% update_player_prompt  update the text displayed in the player prompt text area of GUI
% Use for signalling actions needed or illegal actions attempted.
% inputs: prompt_str string suitable as input for sprintf
% side effects: assigns to game_state.prompt_message
%               updates TextArea component on GUI
% outputs: none
% author: Sean Thompson
% Last modified: 14/11/2017
    global handleboard game_state;
    game_state.prompt_message = sprintf(prompt_str);
    handleboard.TextArea_player_message.Value = game_state.prompt_message;
end


