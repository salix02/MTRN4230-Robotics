function picked=pick(p)
%pick
%   The function takes a 1*2 string array as input.
%   It returns the actual file name of desired block images, which can be 
%   used in GUI for displaying purpose.
    switch p(1)
        case 1
            shape='square';
        case 2
            shape='diamond';
        case 3
            shape='circle';
        case 4
            shape='club';
        case 5
            shape='cross';
        case 6
            shape='star';     
    end

    switch p(2)
        case 1
            color='r';
        case 2
            color='o';
        case 4
            color='g';
        case 3
            color='y';
        case 5
            color='b';
        case 6
            color='p';
    end
    
    picked=strcat(shape,'_',color,'.png');
end