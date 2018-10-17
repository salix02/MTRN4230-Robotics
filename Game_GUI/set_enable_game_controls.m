function set_enable_game_controls(enable_logical_val)
% set_enable_game_controls - set all game controls enabled or disabled
% inputs: enable_logical_val - true (1) for enabled, false (0) for disabled
% outputs: none
% uses global handleboard to change state in the Game GUI
% author: Sean Thompson
% Last modified: 07/11/2017
global handleboard;
enable_str = logical2_on_off_str(enable_logical_val);
set(handleboard.board_grid_Panel.Children, 'Enable', enable_str);
set(handleboard.P1_Panel.Children, 'Enable', enable_str);
set(handleboard.P2_Panel.Children, 'Enable', enable_str);
set(handleboard.pattern_select_Panel.Children, 'Enable', enable_str);
set(handleboard.bottom_controls_Panel.Children, 'Enable', enable_str);
set(handleboard.demonstration_functions_Panel.Children, 'Enable', enable_str);
end
