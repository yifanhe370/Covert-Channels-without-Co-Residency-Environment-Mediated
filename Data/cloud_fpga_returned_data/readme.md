# FPGA Lock/Unlock Status Data (Processed TXT Files)

This folder contains processed `.txt` files exported from the FPGA AXI BRAM and used for lock–unlock status analysis.

Each line in the generated text files corresponds to one complete data record composed of **four hexadecimal bytes** (without the `0x` prefix).

- The byte value **`03`** represents the **lock signal status**, indicating whether the system is in a locked or unlocked state.
- The value **`7a`** is a manually fixed marker:
  - The **first byte** is the high byte.
  - The **second byte** is the low byte.  
  This marker is used only for alignment and consistency checking and does **not** participate in lock-state judgment.
- The remaining bytes are auxiliary or reserved fields.

These processed data are used to verify correct FPGA status output and serve as the raw input for analysis and figures presented in the manuscript.
