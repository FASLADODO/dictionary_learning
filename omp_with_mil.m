function a = omp_with_mil(D,x,K,tol)
    a = zeros(size(D,2),1);
    k = 1;
    
    O = [];
    
    r = x;
    
    I0 = D'*x;
    Ik = I0;

    G = D'*D;
    
    C = [];
    
    ak = [];
    
    while k <= K
        [~,ik] = max(abs(Ik));        
        if k == 1
            C = D(:,ik);
            Ik = I0 - G(:,ik)*I0(ik);
                        
            ak = I0(ik);
            O = ik;
        else
            h = C'*D(:,ik);
            
            p = D(:,O)*h;
            v = D(:,ik)-p;

            L = 1.0/(norm(D(:,ik))^2-norm(p)^2);

            C = [C - L*v*h',  L*v];
            
            
            T = L*(I0(ik)-I0(O)'*h);
            ak = [ak - T * h; T];

            O = [O;ik];            
            Ik = I0 - G(:,O)*ak;
        end
        k = k+1;
        if norm(D(:,O)*ak-x) < tol
            break;
        end
    end
    a(O) = ak;
end