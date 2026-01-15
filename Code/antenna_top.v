`timescale 1ns / 1ps

//============================================================
// Top-level antenna excitation and clock generation module
//============================================================
module antenna_top(
    input antenna_clk          // Reference clock
    );


// Antenna interface signals (preserved during synthesis)
(*dont_touch="yes"*) wire antenna_in;
(*dont_touch="yes"*) wire antenna_out;
(*dont_touch="yes"*) wire antenna_clk_10m;
(*dont_touch="yes"*) wire antenna_signal;


// Antenna model instance
(*dont_touch="yes"*) antenna u_antenna(
    .in  (antenna_in),
    .out (antenna_out)
);


// MMCM clock generation
wire clkfb;
wire clkfb_out;
wire mmcm_locked;

// 100 MHz input -> 10 MHz output
MMCME2_BASE #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKIN1_PERIOD(10.0),
    .CLKFBOUT_MULT_F(8.0),
    .DIVCLK_DIVIDE(1),
    .CLKOUT0_DIVIDE_F(80.0),
    .CLKOUT0_PHASE(0.0),
    .CLKOUT0_DUTY_CYCLE(0.5),
    .STARTUP_WAIT("FALSE"),
    .REF_JITTER1(0.010)
)
u_mmcm (
    .CLKIN1   (antenna_clk),
    .CLKOUT0  (antenna_clk_10m),
    .CLKFBIN  (clkfb_out),
    .CLKFBOUT (clkfb),
    .RST      (mmcm_rst),
    .PWRDWN   (1'b0),
    .LOCKED   (mmcm_locked)
);


// MMCM feedback buffer
BUFG BUFG_inst (
      .O(clkfb_out),
      .I(clkfb)
);


// 10 MHz excitation clock buffer
wire antenna_clk_10m_o;

BUFG BUFG_inst1 (
      .O(antenna_clk_10m_o),
      .I(antenna_clk_10m)
);


// Transmitter generating antenna excitation
transmitter u_transmitter(
    .clk         (antenna_clk_10m_o),
    .mmcm_locked (mmcm_locked),
    .sig_out     (antenna_signal)
);


// Optional background noise injection (disabled)
/*genvar i;
generate
    for (i = 0; i < 300; i = i + 1) begin : GEN_BACKGROUND_NOISE
        (* dont_touch = "yes" *)
        background_noise u_background_noise (
            .clk    (antenna_clk_10m_o),
            .rst    (1'b0),
            .enable (1'b1)
        );
    end
endgenerate*/


// Drive antenna input
(*dont_touch="yes"*) assign antenna_in = antenna_signal;

endmodule
