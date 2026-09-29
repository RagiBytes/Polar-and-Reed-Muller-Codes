function decoded = PolarDecodeSCD(bits,N,A,m,p)
    n=2^m;
    k=length(A);
    frozen = ones(1,n);
    frozen(A)=0;

    decoded_u = zeros(N,n);
    decoded = zeros(N,k);

    for i = 1:N
        y = bits(i,:);
        decoded_u(i,:) = decodeSCD(y, frozen, p);
        decoded(i,:)=decoded_u(i,A);
    end
end