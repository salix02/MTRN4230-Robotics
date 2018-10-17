function shape=shape_filter(circularity)
%shape_filter
%   the function takes in circularity and returns shape accordingly
%
%   See also color_filter
    if circularity>=2.3 && circularity<3.44
        shape=5;%cross; 
    end
    if circularity>=3.44
        shape=6;%star;
    end
    if circularity <1.0324
        shape=3;%circle;
    end
    if circularity>=1.6 && circularity<2.3
        shape=4;%club;
    end
    if circularity>=1.0324 && circularity<1.6
        shape=1;%square;
    end
end