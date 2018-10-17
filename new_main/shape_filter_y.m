function shape=shape_filter_y(circularity)
%shape_filter
%   the function takes in circularity and returns shape accordingly
%
%   See also color_filter
    if circularity>=2.12 && circularity<2.15
        shape=5;%cross; 
    end
    if circularity>=2.15
        shape=6;%star;
    end
    if circularity <1.0324
        shape=3;%circle;
    end
    if circularity>=1.6 && circularity<2.12
        shape=4;%club;
    end
    if circularity>=1.0324 && circularity<1.6
        shape=1;%square;
    end
end