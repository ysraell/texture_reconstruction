function out = func_MTz(z,l_pos,c_pos,lx,cx)
    
    xtemp = zeros(lx,cx);
    xtemp(l_pos,c_pos) = z;
    out = xtemp;
    
end