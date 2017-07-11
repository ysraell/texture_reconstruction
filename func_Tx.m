function out = func_Tx(x,z2,W)

    N = size(x,1);
    K = size(W,2);
       
    TEMP = zeros(N,K);
    
    for i=1:N
        for j=1:K
            
            TEMP(i,j) = sqrt(W(i,j))*(x(i)-z2(j));
            
        end
    end

    out = TEMP;

end

%EOF