function cor=table2global(cor)
%table2global
%   this function takes local coordinates and converts them into
%   coordinates in robot frame
    temp = 0.6575.*(1200-cor(:,2)-285.72)+175;
    cor(:,2) = 0.6575.*(cor(:,1)-797.14);
    cor(:,1) = temp;
end