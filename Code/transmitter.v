`timescale 1ns/1ps

// Predefined excitation waveform generator
module transmitter (
    input  clk,
    input  mmcm_locked,
    output reg sig_out
);

// Fixed waveform ROM
reg [383:0] rom = 384'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_0000_0000_0000_0000_0000_0000_0000_0000_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_0000_0000_0000_0000_0000_0000_0000_0000_0000_1010_1010_1010_1010_1010_1010_1010;

reg [8:0] addr;                // ROM address
reg data = 'b0;

// Sequential waveform output
always @(posedge clk) begin
  if (mmcm_locked & (addr <= 9'd383)) begin
    addr    <= addr + 'b1;
    sig_out <= data;
    data    <= rom[addr];
  end
  else begin
    addr    <= 'b0;
    sig_out <= 'b0;
  end
end

endmodule
