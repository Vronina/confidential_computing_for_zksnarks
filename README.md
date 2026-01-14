# confidential_computing_for_zk_snarks

This frameworks provides code for benchmarking a zk-SNARK proving the pre-image knowledge of a SHA-256 hash.
The zk-SNARK has been implemented for four different frameworks: 
Bellman: https://github.com/zkcrypto/bellman
Halo2: https://github.com/privacy-scaling-explorations/halo2/
Gnark: https://github.com/Consensys/gnark 
Circom: https://github.com/iden3/circom

Exemplary benchmark results are included in the folder Benchmark_results.

## zk-Harness
The benchmarks for Bellman, Circom, and Halo2 are adapted from the benchmarking framework zk-Harness: https://github.com/zkCollective/zk-Harness
Further, we rely on their input files as test vectors. 
The authors also published their findings in a paper: https://doi.org/10.1007/978-3-031-71070-4_3

## Gnark on Icicle Benchmarking
The benchmark for Gnark is based on this implementation: https://github.com/MAYA-ZK/Gnark_on_Icicle_benchmarking

