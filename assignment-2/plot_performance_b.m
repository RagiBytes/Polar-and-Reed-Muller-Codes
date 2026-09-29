p_range = [0.01, 0.1];
N_values = length(p_range);
N = 100;

m_a = 8;
r_a = 1;
n_a = 2^m_a; % n = 16 (Codeword blocklength)
k_rm_a = 9;
k_polar_a = 9;
Afile_a = 'Polar_A_file_n_256_k_9.mat';

Pce_RM_ML  = zeros(N_values, 1);
Pce_RM_SCD = zeros(N_values, 1);
Pce_RM_MLD = zeros(N_values, 1);
Pce_Polar_ML = zeros(N_values, 1);
Pce_Polar_SCD = zeros(N_values, 1);

fprintf('Running Case (b): RM(r=1, m=8) and Polar(n=16, k=11)\n');

for i = 1:N_values
    p_current = p_range(i);
    fprintf('  Processing p = %g\n', p_current);
    
    base_filename = sprintf('n_%d_k_%d_p_%g.txt', n_a, k_rm_a, p_current);
    input_filepath = fullfile('HW3', base_filename);

    % ML (1)
    RMdecode(r_a, m_a, 1, p_current, input_filepath);
    out_file = strrep(input_filepath, '.txt', '_out_ml.txt');
    Pce_RM_ML(i) = calculate_pce_from_bitstream(out_file, N, k_rm_a);
    
    % SCD (2)
    RMdecode(r_a, m_a, 2, p_current, input_filepath);
    out_file = strrep(input_filepath, '.txt', '_out_scd.txt');
    Pce_RM_SCD(i) = calculate_pce_from_bitstream(out_file, N, k_rm_a);
    
    % MLD (3)
    RMdecode(r_a, m_a, 3, p_current, input_filepath);
    out_file = strrep(input_filepath, '.txt', '_out_mld.txt');
    Pce_RM_MLD(i) = calculate_pce_from_bitstream(out_file, N, k_rm_a);

    % ML (1)
    PolarDecode(m_a, Afile_a, 1, p_current, input_filepath);
    out_file = strrep(input_filepath, '.txt', '_out_ml.txt');
    Pce_Polar_ML(i) = calculate_pce_from_bitstream(out_file, N, k_rm_a);
    
    % SCD (2)
    PolarDecode(m_a, Afile_a, 2, p_current, input_filepath);
    out_file = strrep(input_filepath, '.txt', '_out_scd.txt');
    Pce_Polar_SCD(i) = calculate_pce_from_bitstream(out_file, N, k_rm_a);
end

figure;

plot(p_range, Pce_RM_ML,  'r-o', 'DisplayName', 'RM ML (1)', 'LineWidth', 2);
hold on;
plot(p_range, Pce_RM_SCD, 'r--s', 'DisplayName', 'RM SCD (2)', 'LineWidth', 2);
plot(p_range, Pce_RM_MLD, 'r-.^', 'DisplayName', 'RM MLD (3)', 'LineWidth', 2);

plot(p_range, Pce_Polar_ML, 'b-o', 'DisplayName', 'Polar ML (1)', 'LineWidth', 2);
plot(p_range, Pce_Polar_SCD, 'b--s', 'DisplayName', 'Polar SCD (2)', 'LineWidth', 2);

title('Case (b): RM(1, 8) vs Polar(16, 11)');
xlabel('Bit Flipping Probability (p)');
ylabel('Codeword Error Probability (P_{ce})');
legend('Location', 'northwest');
grid on;
hold off;

savefig('case_b_plot.fig');

fprintf('Case (b) plot saved to case_b_plot.fig\n');

function pce = calculate_pce_from_bitstream(output_filename, N, k)
    try
        fid = fopen(output_filename, 'r');
        numeric_stream = fread(fid, 'ubit1')';
        %disp(numeric_stream);
        fclose(fid);
    catch
        error('Failed to read file: %s. Check if the file exists and the path is correct.', output_filename);
    end
    
  
    
    expected_length = N * k;
    actual_length = length(numeric_stream);
    
    if actual_length == 0
        error('File %s is empty or contains no bits.', output_filename);
    end
    
    if actual_length ~= expected_length
        numeric_stream = numeric_stream(1:expected_length);
    end
    
    recovered_codewords = reshape(numeric_stream, k, N)';
    codeword_error_flags = any(recovered_codewords, 2);
    
    num_errors = sum(codeword_error_flags);
    pce = num_errors / N;
    
end