function PolarDecode(m,Afile,decoder,p,filename)
    load(Afile);
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
        otherwise, error('Invalid decoder type.');
    end
    outname = fullfile(folder, sprintf('%s_%s%s', name, outtag, ext));

     switch decoder
        case 1
            decoded = PolarDecodeML(bits, A, m);
            
        case 2
            decoded = PolarDecodeSCD(bits, N, A, m, p);
        
        otherwise
            error('Unknown decoder type.');
     end


     bitstream = reshape(decoded.', 1, []);
    
    fid = fopen(outname, 'w');
    if fid < 0
        error('Cannot write output file: %s', outname);
    end
    fwrite(fid, bitstream, 'ubit1');
    %disp(bitstream);
    fclose(fid);
    fprintf('Decoded %d codewords (n=%d). Output written to:\n%s\n', N, n, outname);

end