function decoded = RMdecodeSCD(bits, N, r, m, p)
    n = 2^m;
    decoded_u = zeros(N, n);
    
    indices = 0:n-1;
    degs = m - sum(de2bi(indices, m), 2); 
    
    unfrozen_positions = find(degs <= r);
    k = length(unfrozen_positions);

    decoded = zeros(N, k);
    
    frozen = ones(1, n);
    frozen(unfrozen_positions) = 0;
    
    for i = 1:N
        y = bits(i,:);
        decoded_u(i,:) = decodeSCD(y, frozen, p);
        decoded(i,:)=decoded_u(i,unfrozen_positions);
    end
end