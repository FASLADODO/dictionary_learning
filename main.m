w = 4;
DIR = dir('att_faces');
X = [];
C = [];
for i = 3:length(DIR)
    dirname = strcat('att_faces/',DIR(i).name);
    disp(dirname);
    AUX_DIR = dir(dirname);
    for j = 3:length(AUX_DIR)        
        auxfilename = strcat(dirname,'/',AUX_DIR(j).name);
        aux = double(imread(auxfilename))/255.0;
        mean_aux  = zeros([size(aux,1)/w,size(aux,2)/w]);
        d = size(mean_aux);
        kk = 1;
        ll = 1;
        for k = 1:w:size(aux,1)
            ll = 1;
            for l = 1:w:size(aux,2)
                aux3 = aux(k:k+w-1,l:l+w-1,:);
                mean_aux(kk,ll,:)  = mean(mean(aux3));
                ll = ll + 1;
            end
            kk = kk + 1;
        end
        %d = size(aux2);
        X = [X ; reshape(mean_aux,[1,numel(mean_aux)]) ];
        C = [C ; i-3];
    end
end

L = 100;
K = 20;
T = 1000;
B = 100;
D = dictionary_learn(X,L,K,T,B);

figure;
for l = 1:L
    aux = D(:,l);
    aux = aux - min(aux);
    aux = aux / (1e-4+max(aux));
    subplot(ceil(sqrt(L)),ceil(sqrt(L)),l);
    imshow(kron(reshape(aux,d),ones(w,w)));
end