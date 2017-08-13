function D = dictionary_learn(X,L,K,T,B)
    D = randn(size(X,2),L);
    for l = 1:L
        D(:,l) = D(:,l) / norm(D(:,l));
    end
    
    mD = zeros(size(D));
    nD = zeros(size(D));
    mu = 0.25;
    nu = 0.25;
    
    for t = 1:T
        disp(t);
        idxs = (1:size(X,1))';
        rper = randperm(size(idxs,1));
        idxs = idxs(rper(1:B));
        
        x = X(idxs,:)';
        a = zeros(L,B);
        for b = 1:B
            a(:,b) = omp_with_mil(D,x(:,b),K,1e-4);
        end
        
        idxa = (1:B)';
        y = x-D*a;
%         for l = 1:L
%             D(:,l) = 0.0;
%             g = a(l,:)';
%             d = y*g;
%             d = d / norm(d);
%             g = y'*d;
%             D(:,l) = d;
%             a(l,:) = g';
%             y = x-D*a;
%         end
%         
        mD = mu*mD+(1.0-mu)*y*a';
        nD = nu*nD+(1.0-nu)*(y*a').^2;
        
        mD_ = mD / (1.0-mu^t);
        nD_ = nD / (1.0-nu^t);
        
        D = D + 1e-3*mD_ ./ (sqrt(nD_)+1e-8);
        
        for l = 1:L
            D(:,l) = D(:,l) / norm(D(:,l));            
        end
        
    end
end