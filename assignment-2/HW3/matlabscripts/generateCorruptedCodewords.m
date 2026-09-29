N=100;
% n=2^8;
% p=0.1;
% cap = 1+(p*log(p)+(1-p)*log(1-p))/log(2);

paramslist = [16, 11; 256, 9; 256, 37; 256, 93];

for p=[0.01 0.1]
    for i=4%1:size(paramslist, 1)
        n = paramslist(i,1);
        k = paramslist(i, 2);
        fname=['n_' num2str(n) '_k_' num2str(k) '_p_' num2str(p) '.txt'];
        fi = fopen(fname,"w");
        err = (rand(n*N,1) <= p);
        fwrite(fi, err, 'ubit1');
        fclose(fi);
    end
end