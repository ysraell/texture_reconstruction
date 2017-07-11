function [W_,J_] = func_WJ(z2,zc,K,delta,Bloc_size)

    N = size(zc(:),1);
    J = zeros(N,K);
    for i=1:N
        J(i,:) = func_jbarra(i,z2,zc,K,Bloc_size);
    end

    W = zeros(N,K);
    for i=1:N
        ii=J(i,1);
        Ji = J(i,:);
        for j=1:K
            jj=Ji(j);
            W(i,j) = sqrt(func_wij(ii,jj,z2,delta,Bloc_size));
        end
    end

    W_=W;
    J_=J;

end

%OEF