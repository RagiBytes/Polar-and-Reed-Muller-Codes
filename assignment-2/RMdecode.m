function RMdecode(r, m, decoder, p, filename)
    
    fid = fopen(filename, 'r');
    if fid < 0
        error('Cannot open input file: %s', filename);
    end
    bits = fread(fid, 'ubit1')';
    fclose(fid);
    
    n = 2^m;
    
    L = numel(bits);
    if mod(L, n) ~= 0
        error('File contains %d bits, which is not divisible by n=%d', L, n);
    end
    N = L / n;
   
    bits = reshape(bits, n, N)';
    
    [folder, name, ext] = fileparts(filename);
    switch decoder
        case 1, outtag = 'out_ml';
        case 2, outtag = 'out_scd';
        case 3, outtag = 'out_mld';
        otherwise, error('Invalid decoder type.');
    end
    outname = fullfile(folder, sprintf('%s_%s%s', name, outtag, ext));
      
    switch decoder
        case 1
            %disp("entering RMdecodeML")
            decoded = RMdecodeML(bits, r, m);
            
        case 2
            decoded = RMdecodeSCD(bits, N, r, m, p);
        case 3
            k=0;
            for i = 0:r
                k = k + nchoosek(m,i);
            end
            decoded = zeros(N, k);
            for i = 1:N
                decoded(i,:) = RMdecodeMlogic(bits(i,:), r, m);
            end
        otherwise
            error('Unknown decoder type.');
    end

    %disp(decoded);
    bitstream = reshape(decoded.', 1, []);
    %disp(size(bitstream));
    
    fid = fopen(outname, 'w');
    if fid < 0
        error('Cannot write output file: %s', outname);
    end
    fwrite(fid, bitstream, 'ubit1');
    %disp(bitstream);
    fclose(fid);
    fprintf('Decoded %d codewords (n=%d). Output written to:\n%s\n', N, n, outname);
end