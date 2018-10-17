function clear_next_clicked_cell(hObject, eventdata, handles)
% clear_next_clicked_cell - callback for setting the pattern selection 
%   p1 global to clear - NOW UNUSED
% inputs: hObject - the object the callback is called on
%         eventdata - unused in this callback
%         handles - currently unused
% outputs none
% uses global p1 to store changed state in the Game GUI
% author: Sean Thompson
% Last modified: 14/11/2017
    global p1;
    p1(1)=0;
    p1(2)=0;
end

