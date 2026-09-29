function decoded = decodeML(received, codebook, message)

    N = size(received,1);
    M = size(codebook,1);
    n = size(codebook,2);
    k = size(message,2)
    decoded = zeros(N, k);
    
    codebook_numeric = double(codebook);
    
    for i = 1:N
        y = double(received(i,:));
        
        dists = sum(xor(codebook_numeric, y), 2);
        
        [~, idx_min] = min(dists);

        decoded(i,:) = message(idx_min,:); 
    end
end