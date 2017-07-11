function J_ = func_jbarra(i,z2,zc,K,Bloc_size)

        [lz,cz] = size(z2);     
        [lc,cc] = size(zc); 
        
        % convert to impair, keep if impair.
        Bloc_size = 2*floor(Bloc_size/2)+1;
        
        r = (Bloc_size-1)/2;

        [ic,jc] = pixel2ij(i,lc);
        
        pc = zeros(2*r+1);
        
        si=0;
        for ii=[ic-r:ic+r]
            si=si+1;
            sj=0;
            for jj=[jc-r:jc+r]
                sj=sj+1;
                if (ii<=0)||(jj<=0)||(ii>lc)||(jj>cc)
                    pc(si,sj) = 0;
                else
                    pc(si,sj) = zc(ii,jj);
                end
                
            end
        end
        
        N = lz*cz;
        J = zeros(N,1);

        for n=1:N
            [ic,jc] = pixel2ij(n,lz);

            pz = zeros(2*r+1);
            si=0;
            for ii=[ic-r:ic+r]
                si=si+1;
                sj=0;
                for jj=[jc-r:jc+r]
                    sj=sj+1;

                    if (ii<=0)||(jj<=0)||(ii>lz)||(jj>cz)
                        pz(si,sj) = 0;
                    else
                        pz(si,sj) = z2(ii,jj);
                    end
                    
                end
            end
%             imagesc(pz)
%             pause
            J(n) = norm(pc-pz);
            
        end        
        [~,temp] = sort(J,'ascend');
        J_ = temp(1:K);
        
end

%EOF