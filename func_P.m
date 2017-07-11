function out = func_P(x,z,l_pos,c_pos,pimage)

   [lx,cx] = size(x);
   zx = z-x(l_pos,c_pos);
   out = x+func_MTz(zx,l_pos,c_pos,lx,cx);
   
if pimage
    
    figure;
    subplot(2,2,1)
    imagesc(x)
    colormap gray;
    subplot(2,2,2)
    imagesc(z)
    colormap gray;
    subplot(2,2,3)
    imagesc(out)
    colormap gray;
    subplot(2,2,4)
    imagesc(zx)
    colormap gray;
end


end

%EOF