`timescale 1ns / 1ps

//============================================================
// System top-level integration module
//============================================================
module top(
    input  clk,                // System clock
    input  enable,             // Global enable control
    input  UART_RX,            // UART receive line
    output UART_TX,            // UART transmit line
    output end_led,            // Measurement end indicator
    output locked_led          // MMCM lock status indicator
    );

// Antenna excitation and clock generation
antenna_top u_antenna_top(
    .antenna_clk(clk)
);

// MMCM monitoring and UART reporting
mmcm_receive_top u_mmcm_receive_top(
    .clk(clk),
    .enable(enable),
    .RXD(UART_RX),
    .TXD(UART_TX),
    .end_led(end_led),
    .locked_led(locked_led)
);

endmodule
