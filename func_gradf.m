function out = func_gradf(x,z1,z2,as)

    [l,c] = size(x);
    Temp = zeros(l,c);
    for s=1:4
        Lsx = func_Ls(x,s);
        Lsz = func_Ls(z2,s);
        
        Zs = imhistmatch(Lsx,Lsz);
        
        Temp=Temp+as(s)*func_LsT(Lsx-Zs,s);
    end
    out = 2*(x-z1)+2*Temp;

end

%EOF