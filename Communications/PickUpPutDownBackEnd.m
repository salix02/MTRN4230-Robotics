% Function designed to be called by PickUp/PutDown functions only so that
% it is more intuitive to code using those functions without having to
% remember the numerical code for pickup or putdown. Refer to PickUp and
% PutDown functions for use. It is recommended to not use this function in
% any other location.
% Author: Alvin Yap
% Last modified: 15/11/2017

function PickUpPutDownBackEnd(XY, angle, PuPd)

global MvSocket;

if XY(1) < 125 % Conveyor
    XYZ = [XY 30];
else %table
    XYZ = [XY 154];
end

quat = angle2quat(angle, -pi, 0);

msg = sprintf('7_%d_150_[%.2f,%.2f,%.2f]_[%.5f,%.5f,%.5f,%.5f]', PuPd, XYZ, quat);
fwrite(MvSocket, msg);
pause(0.3);
end