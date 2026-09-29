function decoded = PolarDecodeML(bits, A, m)
    k=size(A,2);
    disp(k);
    n = 2^m;
    message = de2bi(0:(2^k)-1,k);
    message_size = size(message,1);
    codebook = zeros(message_size, n);
    for i = 1:message_size
        codebook(i,:) = Polarencode(m,A,message(i,:));
    end
    decoded = decodeML(bits,codebook,message)

end