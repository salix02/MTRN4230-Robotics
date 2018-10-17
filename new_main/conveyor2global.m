function cor=conveyor2global(cor)
%converyor2global
%   this function converts coordinates in camera frame to robot frame
    temp = 0.75*(1200-cor(:,2)-525)+0;
    cor(:,2) = 0.75*(cor(:,1)-834)+409;
    cor(:,1) = temp;
end