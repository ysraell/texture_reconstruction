function out = func_Errx(x,u)


    [l,c]=size(x);
    out = norm(u-imhistmatch(u,x))/(l*c);
    

end

%EOF