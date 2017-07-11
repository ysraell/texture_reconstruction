function out = func_Ty(y,z2,W)

    K = size(W,2);
    N = size(y,1)/K;
       
    TEMP = zeros(N,1);
    
    nk=0;
    for i=1:N
        for j=1:K
         nk=nk+1;   
            TEMP(i) = TEMP(i)+sqrt(W(i,j))*(y(nk)-z2(j));
        end
    end

    out = TEMP;

end

%EOF