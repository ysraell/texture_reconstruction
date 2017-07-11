function out = func_wij(ji,jz,z2,delta,Bloc_size)


        % ATENTION: the input for ji is j-bar^i, not i.
    
        [lz,cz] = size(z2);
        [icj,jcj] = pixel2ij(jz,lz);
        [icji,jcji] = pixel2ij(ji,lz);
                  
        % convert to impair, keep if impair.
        Bloc_size = 2*floor(Bloc_size/2)+1;
        r = (Bloc_size-1)/2;
        
        
        ic=icj;jc=jcj;
        pc = zeros(2*r+1);
        si=0;
        for ii=[ic-r:ic+r]
            si=si+1;
            sj=0;
            for jj=[jc-r:jc+r]
                sj=sj+1;
                if (ii<=0)||(jj<=0)||(ii>lz)||(jj>cz)
                    pc(si,sj) = 0;
                else
                    pc(si,sj) = z2(ii,jj);
                end
                
            end
        end
        pj=pc;
        
        ic=icji;jc=jcji;
        pc = zeros(2*r+1);
        si=0;
        for ii=[ic-r:ic+r]
            si=si+1;
            sj=0;
            for jj=[jc-r:jc+r]
                sj=sj+1;
                if (ii<=0)||(jj<=0)||(ii>lz)||(jj>cz)
                    pc(si,sj) = 0;
                else
                    pc(si,sj) = z2(ii,jj);
                end
                
            end
        end
        pji=pc;

        if delta>0
            out = exp(-delta*norm(pji-pj)^2);
        else
            out = exp(-(norm(pji-pj)/norm(pji))^2);
        end
    
    
end

%EOF