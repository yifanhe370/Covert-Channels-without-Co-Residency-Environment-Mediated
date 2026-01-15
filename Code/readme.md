# CCS Artifact: Covert Channel on Cloud FPGA

This folder contains the complete RTL source code and constraint files used in our CCS paper for reproducing the FPGA-based covert channel prototype.

The design demonstrates a bidirectional covert communication mechanism based on clock behavior and near-field coupling on cloud FPGAs. All modules pass standard synthesis and implementation flows and do not rely on explicitly prohibited primitives.

---

## File Overview

| File | Description |
|------|-------------|
| `top.v` | Top-level integration module used for synthesis. Connects all functional blocks. |
| `antenna_top.v` | Wrapper for the loop antenna structure and transmitter logic. |
| `antenna.v` | Implements the loop antenna structure used to generate near-field disturbances. |
| `transmitter.v` | Core transmitter logic that modulates the signal pattern. |
| `mmcm_receive_top.v` | Receiver-side logic based on MMCM behavior and lock-time observation. |
| `counter.v` | Generic counter used for timing and state tracking. |
| `uart.v` | Lightweight UART implementation for debugging and data output. |
| `place.xdc` | Placement constraints used to enforce spatial proximity and routing characteristics. |
| `background_noise.v` *(optional)* | Optional module for injecting background noise to emulate environmental interference. |
| `lfsr_noise.v` *(optional)* | Optional pseudo-random noise generator based on LFSR, used with `background_noise.v`. |

> **Note:**  
> `background_noise.v` and `lfsr_noise.v` are *optional*.  
> They are only used to emulate environmental noise and improve experimental robustness.  
> The core covert channel works without these two files, and they can be safely removed for a minimal reproduction.

---

## Build & Reproduction

1. Create a new Vivado project (tested with Vivado 2022+).
2. Add all `.v` files in this folder to the project.
3. Add `place.xdc` as a constraint file.
4. Set `top.v` as the top module.
5. Synthesize and implement normally.

If you want to enable background noise injection:

- Include `background_noise.v` and `lfsr_noise.v`.
- Instantiate the noise module in `top.v` (or `antenna_top.v`) as indicated in the comments.
- Re-synthesize the design.

Otherwise, simply omit these two files for a clean baseline configuration.

---

## Notes on Cloud FPGA Deployment

- The design uses only standard user-accessible primitives (MMCM, LUTs, counters, etc.).
- No privileged interfaces, DMA paths, PCIe channels, or shell-level resources are required.
- The covert channel is realized through the interaction between clock behavior, placement, and physical coupling effects.

This artifact is intended for academic research and reproducibility purposes only.
