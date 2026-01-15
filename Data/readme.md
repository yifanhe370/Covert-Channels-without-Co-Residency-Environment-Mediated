# Dataset Overview

This directory contains four sub-datasets used to generate the figures and evaluations in the paper, each corresponding to a different experimental aspect of the covert channel.

- **`snr_layout_cycle/`**  
  Repeated-measurement datasets used to compute SNR under different antenna layouts and loop cycle counts (Fig. 7).  
  Each subfolder contains paired noise (`*_0`) and signal (`*_1`) measurements for statistical averaging.

- **`distance_probe/`**  
  Near-field probe measurements at different distances, used for time-domain visualization and distance-dependent SNR analysis (Fig. 6).  
  These data characterize how signal strength degrades with probe distance.

- **`temperature_effect/`**  
  Temperature-dependent measurements used to analyze signal stability and thermal sensitivity (Fig. 8 and Fig. 9), including both discrete-temperature snapshots and continuous temperature sweeps.

- **`cloud_fpga_returned_data/`**  
  Processed cloud FPGA status traces exported from AXI BRAM, used to analyze and verify lock–unlock behavior and internal state transitions.

Each subfolder contains its own `README.md` describing the corresponding data format, processing method, and the figures derived from it.
