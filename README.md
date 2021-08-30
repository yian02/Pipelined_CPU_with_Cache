# Pipelined-CPU

> A Simple Implementation of a Pipelined CPU with Cache and Off-Chip Memory

This is a 5-Stage-Pipelined CPU which supports the following RISC-V instructions:

### R-Type Instructions

- `and`
- `xor`
- `sll`
- `add`
- `sub`

### I-Type Instructions

- `mul`
- `addi`
- `srai`
- `lw`

### S-Type Instructions

- `sw`

### SB-Type Instructions

- `beq`

### Futher Information

This pipelined CPU also supports the following features:

- Branch prediction strategy is "always not taken"
- Forwarding unit to solve the data hazard caused by arithmetic operations
- Hazard detection unit that detects the load-use hazard and stall the pipeline
- Hazard detection unit that detects the control hazard and flush the pipeline

This CPU has a cache and off-chip memory

- The capacity of the cache is 1KB, and 32-byte per cache line
- The cache is two-way associative with replacement policy being LRU.
- Applies write back policy to handle wrtie hit
- Applies write allocate policy to handle write miss
- It has a cache controller that controls the cache and stalls the pipeline if necessary
- The cache miss penalty is 10 cycles
