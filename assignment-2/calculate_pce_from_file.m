function pce = calculate_pce_from_file(output_filename,k,N)
    % Load the N x n matrix of recovered codewords
    % Assuming the file is space-delimited text
    bitstream = load(output_filename);
    
    recovered_codewords = reshape(numeric_stream, k, N)';
    
    % A codeword is in error if *any* bit is 1 (since c=0)
    codeword_error_flags = any(recovered_codewords, 2);
    
    num_errors = sum(codeword_error_flags);
    
    pce = num_errors / N;
end