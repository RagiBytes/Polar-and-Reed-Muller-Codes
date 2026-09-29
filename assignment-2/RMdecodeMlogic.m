function f_coeffs_u = RMdecodeMlogic(Y, r, m)


    n = 2^m;
    Y = mod(Y(:), 2); 
    
    X = false(n,m);
    for idx = 0:n-1
        for b = 1:m 
            X(idx+1,b) = bitget(idx, b); 
        end
    end
    
    [f_coeffs, ~] = decode_r(Y, m, r, X);
    
    indices = 0:n-1
    degs = m - sum(de2bi(indices, m), 2); 
    
    unfrozen_positions = find(degs <= r);
    f_coeffs_u=f_coeffs(unfrozen_positions);

end


function [f_coeffs, f_eval] = decode_r(Yi, m, r, X)
    n = 2^m;
    
    if r < 0
        f_coeffs = zeros(n, 1);
        f_eval   = zeros(n, 1);
        return;
    end
    
    coeffs_r = decode_degree_r(Yi, m, r, X);
    
    Cr = eval_polynomial(coeffs_r, m, X);
    
    Yi_next = mod(Yi + Cr, 2);
    
    [f_low, f_low_eval] = decode_r(Yi_next, m, r-1, X);
    
    f_coeffs = mod(f_low + coeffs_r, 2);
    f_eval = mod(f_low_eval + Cr, 2);
end

function coeff_vec = decode_degree_r(Yi, m, r, X)
    n = 2^m;
    coeff_vec = zeros(n, 1);
    
    if r == 0
        mask = 0;
        coeff_vec(mask+1) = majority_of_checks(Yi, X, mask, m);
        return;
    end
    
    subsets = nchoosek(1:m, r);
    numSub = size(subsets, 1);
    
    for k = 1:numSub
        S = subsets(k, :);
        mask = 0;

        for v = S
            mask = bitor(mask, bitshift(1, v-1));
        end

        coeff_vec(mask+1) = majority_of_checks(Yi, X, mask, m);
    end
end

function a_hat = majority_of_checks(Yi, X, mask, m)
    
    S = find(bitget(mask, 1:m));
    T = setdiff(1:m, S);
    n = size(X, 1);
    
    dimT = numel(T);
    d = numel(S);
    numChecks = 2^dimT;
    
    if isempty(T)
        keys = zeros(n, 1, 'uint32');
    else
        pow2v = uint32(2.^(0:dimT-1));
        keys = uint32( double(X(:, T)) * double(pow2v(:)) ); 
    end
    
    onesCount = 0;
    for b = 0:numChecks-1
        idx = (keys == b);
        
        if any(idx)
            s = mod(sum(Yi(idx)), 2); 
            onesCount = onesCount + s;
        end
    end
    
    if onesCount > numChecks / 2
        a_hat = 1;
    else
        a_hat = 0;
    end
end

function E = eval_polynomial(coeffs, m, X)
    n = 2^m;
    E = zeros(n, 1);
    
    for mask = 0:n-1
        if coeffs(mask+1) == 0, continue; end
        
        if mask == 0
            mon_eval = ones(n, 1);
        else
            vars = find(bitget(mask, 1:m));
            mon_eval = true(n, 1);
            for v = vars
                mon_eval = mon_eval & X(:, v);
            end
            mon_eval = double(mon_eval);
        end
        
        E = mod(E + mon_eval, 2);
    end
end