function codeword = decodeSCD(y, frozen, e)
    
n = length(y);
if bitand(n, n-1) ~= 0
    error('Length of y must be a power of 2');
end
m = log2(n);
if abs(m - round(m)) > 0
    error('log2(n) must be integer');
end
m = round(m);

P = cell(m+1,1);
C = cell(m+1,1);
for lambda = 0:m
    len = 2^(m - lambda);
    P{lambda+1} = zeros(len, 2);
    C{lambda+1} = zeros(len, 2);
end

for beta = 0:(n-1)
    idx = beta + 1;
    if y(idx) == 0
        P{1}(idx, 1) = 1 - e;   
        P{1}(idx, 2) = e;       
    else
        P{1}(idx, 1) = e;
        P{1}(idx, 2) = 1 - e;
    end
end

for phi = 0:(n-1)
    recursivelyCalcP(m, phi);
    
    if frozen(phi+1) == 1
        decided = 0;
    else
        if P{m+1}(1,1) > P{m+1}(1,2)
            decided = 0;
        else
            decided = 1;
        end
    end
    
    C{m+1}(1, mod(phi, 2) + 1) = decided;
    
    if mod(phi, 2) == 1
        recursivelyUpdateC(m, phi);
    end
end

codeword = C{1}(:, 1).'; 

    function recursivelyCalcP(lambda, phi)
        if lambda == 0
            return;
        end
        psi = floor(phi / 2);
        
        if mod(phi, 2) == 0
            recursivelyCalcP(lambda - 1, psi);
        end
        
        len_curr = 2^(m - lambda);
        Pprev = P{lambda};    
        Pcurr = zeros(len_curr, 2);
        
        for b = 0:(len_curr - 1)
            bidx_curr = b + 1;
            bidx_prev1 = b + 1;
            bidx_prev2 = b + len_curr + 1;
        
            if mod(phi, 2) == 0
                for u = 0:1
                    s = 0;
                    for up = 0:1
                        idx1 = xor(u, up) + 1; 
                        idx2 = up + 1;         
                        s = s + Pprev(bidx_prev1, idx1) * Pprev(bidx_prev2, idx2);
                    end
                    Pcurr(bidx_curr, u+1) = s;
                end
            else
                uhat = C{lambda}(bidx_prev1, 1); 
                for u = 0:1
                    idx1 = xor(uhat, u) + 1; 
                    idx2 = u + 1;            
                    Pcurr(bidx_curr, u+1) = Pprev(bidx_prev1, idx1) * Pprev(bidx_prev2, idx2);
                end
            end
        end
        P{lambda+1} = Pcurr;
    end

    function recursivelyUpdateC(lambda, phi)
        if lambda == 0
            return;
        end
        psi = floor(phi / 2);
        len_curr = 2^(m - lambda);
        
        Clambda = C{lambda+1};
        Clower = C{lambda};
        
        for b = 0:(len_curr - 1)
            u1_hat = Clambda(b+1, 1);
            u2_hat = Clambda(b+1, 2);
            
            bidx_low1 = b + 1;               
            bidx_low2 = b + len_curr + 1;    

            Clower(bidx_low1, 1) = mod(u1_hat + u2_hat, 2);
        
            Clower(bidx_low2, 2) = u2_hat; 
        end
        C{lambda} = Clower;
        
        if mod(psi, 2) == 1
            recursivelyUpdateC(lambda - 1, psi);
        end
    end
end