# Benchmarks

Benchmarks were captured using the AMD SEV-SNP TEE as well as Intel TDX based on a QEMU container. To compare TEE usage to conventional proof generation, the memory, CPU and time consumption were captured both inside the TEE as well as using a plain QEMU container without TEE enabled.
This folder contains all benchmark results for the time consumption. However, due to the larger size of the monitored memory and CPU consumption, these files are not fully included here. Instead, files for the smalles input file $2^5$ are included here exemplarily.

## AMD SEV-SNP
Results were collected in a private testbed using an AMD EPYC 9354 with 32 vCPUs and 128 GB of RAM. 


## Intel TDX
We used an INTEL XEON SILVER 4514Y chip with 32 vCPUs and 128 GB of RAM. 

## This folder is structured as follows:

### Time consumption:
Measurement of the time consumption for setup and proving phases.
Contains all captured results for the runtime of all four frameworks across both TEE.

### CPU consumption:
Top capture focusing on the CPU usage, capture approximately every 250 ms.
Due to the large size of many files, this folder only exemplarily contains the results for Bellman.

### Memory consumption:
Top capture focusing on the RAM usage, capture approximately every 250 ms.
Due to the large size of many files, this folder only exemplarily contains the results for Bellman.