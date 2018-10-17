function box_occupancy(c,o)
%box_occupacy
%   the function is called after detection made.
%   it sets 8 positions in the empty box to put blocks
%   the function updates the box_og field in global struct detecton_State
    
global detection_State
    temp=[-20.3689  -85.2164
          -24.8506  -41.8271
          -30.7823  6.1104
          -36.8734  60.1040
          35.5591  -81.5353
          32.0199  -34.3871
          27.6067   18.8153
          17.8310   72.7886];
    og=temp+c;
    detection_State.box_og=og;
end