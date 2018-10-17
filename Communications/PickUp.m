% This function sends command to robot studio to pick up blocks.
% Argument expected: [X, Y]: global co-ordinates in mm. Conveyor or table
% frame determined using X co-ordinate
% angle expected to be in radians
% Author: Alvin Yap
% Last Modified: 04/11/2017

function PickUp(XY, angle)

PickUpPutDownBackEnd(XY, angle, 1); %1 is for pick up

% global MvSocket;

% if XY(1) < 125 % Conveyor
%     XYZ = [XY 32];
% else %table
%     XYZ = [XY 157];
% end
% 
% quat = angle2quat(angle, -pi, 0);
% 
% msg = sprintf('7_1_150_[%.2f,%.2f,%.2f]_[%.5f,%.5f,%.5f,%.5f]', XYZ, quat);
% fwrite(MvSocket, msg);

end