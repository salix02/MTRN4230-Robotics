function outstr = logical2_on_off_str(logicalVal)
% logical2_on_off_str - helper function to convert a given logical true/false 
%   to str equivalent, 'on'==true, 'off'==false
% inputs: logicalVal - true (1) or false (0)
% outputs: outstr - on' for input==true, 'off' for input==false
% author: Sean Thompson
% Last modified: 31/10/2017
if(logicalVal)
    outstr = 'on';
else
    outstr = 'off';
end
return
end

