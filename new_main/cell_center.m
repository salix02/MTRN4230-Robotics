function cell_center()
%cell_center
%   the function is called at the very beginning of programme
%   it regulates the actual coordinates in robot frame for each cells
%   the value is stored in global struct detection_State
global detection_State
    detection_State.deck1x=193:36:373;
    detection_State.deck1y=-230;

    detection_State.boardx=193:36:481;
    detection_State.boardy=-144:36:144;

    detection_State.deck2x=193:36:373;
    detection_State.deck2y=230;
end

