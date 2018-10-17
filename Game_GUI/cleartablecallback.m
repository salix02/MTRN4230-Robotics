function cleartablecallback(hObject, ~)
% cleartablecallback - callback for the Clear table Button
% inputs: hObject - the object the callback is called on
% author: Alvin Yap & Sean Thompson
% Last modified: 15/11/2017
    global vidvars
    Move2PresetPos(0);
    waitWhileBusy;
    video_detection(vidvars.vid1,vidvars.vid2,vidvars.handle);
    allBlocks2Box;
end
