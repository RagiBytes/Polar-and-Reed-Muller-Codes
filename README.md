# Polar and Reed–Muller Codes

MATLAB implementations of decoding algorithms for Reed–Muller
and Polar error-correcting codes over a Binary Symmetric Channel.

## Implemented Decoders

### Reed–Muller Codes
- Maximum Likelihood / Minimum Distance decoding
- Successive Cancellation decoding
- Majority Logic decoding

### Polar Codes
- Maximum Likelihood / Minimum Distance decoding
- Successive Cancellation decoding

## Experiments

Codeword error rates are evaluated for different code parameters
and BSC crossover probabilities.

Experiments include:

- RM(2, 4), n = 16, k = 11
- RM(1, 8), n = 256, k = 9
- RM(2, 8), n = 256, k = 37
- RM(3, 8), n = 256, k = 93

The performance of the different decoding algorithms is compared
using codeword error probability.
