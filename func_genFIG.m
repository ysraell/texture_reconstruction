function [z1_,z2_,x_,l_pos_,c_pos_] = func_genFIG(fig_file,rblur,N1,N2,tau,patch_Rand,pimage)

im = rgb2gray(imread(fig_file));
[l,c]=size(im);

% Choosing N1 = 256*256, p.e., the new resolution
% will be approximately N. It is recomended choose
% figures with higher resolution.
res = round([l c].*sqrt(N1/(l*c)));

% High resolution image of interest
x_ = imresize(im,res,'bicubic');

% z1 = DBx+wgn(0,tau)
% D: down-sampling, B: some blur effect. Using a consecutive down and 
% up-sampling, we achive the same effect from DB.
% At first, z1 have the same dimensions of x.
z1 = imresize(imresize(x_,res./(2^rblur),'bicubic'),res,'bicubic');
z1_ = uint8(int16(z1)+int16(tau.*randn(res)));
% z1_ = z1;

% Extract a patch from x (just to compare)
[l,c]=size(x_);

% Choosing N2 = 256*256 <=N1 (In this case, to compare. )
if (N2<0.9*N1)
    res = round([l c].*sqrt(N2/(l*c)));
    % Randomly choose the center of the patch extracted from x to obtain z2.
    if patch_Rand
        lr = randi(l-res(1));
        cr = randi(c-res(2));
    else
        lr = round((l-res(1))/2);
        cr = round((c-res(2))/2);
    end
    l2 = lr:lr+res(1)-1;
    c2 = cr:cr+res(2)-1;
    z2_ = x_(l2,c2);
    
    l_pos_ = l2;
    c_pos_ = c2;
    
else
    z2_ = x_;
    l_pos_ = l;
    c_pos_ = c;
    
end


if pimage
    
    xz = func_MTz(z2_,l_pos_,c_pos_,l,c);
    
    figure;
    subplot(2,2,1)
    imagesc(x_)
    colormap gray;
    subplot(2,2,2)
    imagesc(z1_)
    colormap gray;
    subplot(2,2,3)
    imagesc(z2_)
    colormap gray;
    subplot(2,2,4)
    imagesc(xz)
    colormap gray;
end

end