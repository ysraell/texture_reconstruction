function [x_,z1_,z2_,x_o_,times_] = func_fbpd(fig_file,rblur,N1,N2,tau,omega,gamma,delta,K,Bloc_size,T,as,CPP)

    pimage = false;
    patch_Rand = false;
    disp('Generating images (x, z1 and z2)...')
    time=tic;
    [z1,z2,x_o,l_pos,c_pos] = func_genFIG(fig_file,rblur,N1,N2,tau,patch_Rand,pimage);
    z1 = double(z1);
    z2 = double(z2);
    x_o = double(x_o);
    
    disp('Calculating w_ij for i = 1,...,N1 and j = 1,...,K.')
    
    if CPP 
        [W,J] = func_WJcpp(z2,z1,K,delta,Bloc_size);
    else
        [W,J] = func_WJ(z2,z1,K,delta,Bloc_size);
    end
    
    x = z1;
    [lx,cx] = size(z1);
    xp = zeros(lx,cx);
    xc = zeros(lx,cx);
    y = zeros(K*lx*cx,1);
    for l=1:T
        
        xc = func_gradf(x,z1,z2,as)+ reshape(func_Ty(y,z2,W),lx,cx); %+reshape(x(:).*(W*y),lx,cx);
        xp = func_P(x-tau.*xc,z2,l_pos,c_pos,pimage);
        if l<T
           % yc = func_Tx(2.*xp(:)-x(:),z2(:),W);
           % y = prox_l12(y+omega.*yc, gamma);
           y = prox_l12(y+omega.*func_Tx(2.*xp(:)-x(:),z2(:),W), omega*gamma);
        end
    end
    times_ = toc(time);
    z2_=z2;
    z1_=z1;
    x_o_=x_o;
    x_=xp;


end

%EOF