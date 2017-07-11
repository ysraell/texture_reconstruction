function out = func_LsT(x,s)

    switch s
        case 1
            out = x;
        case 2
            [l,c]= size(x);
            out = imresize(x,[l+1 c+1],'bicubic');
        case 3
            out = x;
        case 4
            out = x;
    end

end

%EOF