function [i,j] = pixel2ij(n,size_l)

    d = floor(n/size_l);
    m = mod(n,size_l);

    if m==0
        j = d;
        i = size_l;
    else
        j = d+1;
        i = m;
    end
    
    
end

%EOF