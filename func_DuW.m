function [out] = func_DuW(x,z,pimage)

        xz = imhistmatch(x,z);
        out = 2.*(x-xz);
        
        
if pimage
    figure;
    subplot(2,2,1)
    imagesc(x)
    colormap gray;
    subplot(2,2,2)
    imagesc(z)
    colormap gray;
    subplot(2,2,3)
    imagesc(out./2)
    colormap gray;
    subplot(2,2,4)
    imagesc(xz)
    colormap gray;
end
        
end

%EOF