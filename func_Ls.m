function out = func_Ls(x,s)

    switch s
        case 1
            out = x;
        case 2
            out = diff(diff(x,1,1),1,2);
        case 3
            h = zeros(3);
            h(1) = -1;
            h(end) = 1;
            out = imfilter(x,h);
        case 4
            h = fspecial('laplacian');
            out = imfilter(x,h);
    end

end

%EOF