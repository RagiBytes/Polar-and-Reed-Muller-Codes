function decoded = RMdecodeML(bits, r, m)

    n = 2^m;
    
    k = 0;
    for i = 0:r
        k = k + nchoosek(m,i);
    end

    message = de2bi(0:(2^k)-1, k);
    num_msgs = size(message,1);
    codebook = zeros(num_msgs, n);
    for i = 1:num_msgs
        codebook(i,:) = RMencode(r, m, message(i,:));
    end
    
    decoded = decodeML(bits, codebook,message);
end