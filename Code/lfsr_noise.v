// 16-bit LFSR-based pseudo-random sequence generator
module lfsr_noise (
    input  wire clk,
    input  wire rst,
    output reg  [15:0] noise
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            noise <= 16'hACE1;   // Non-zero seed
        else begin
            // LFSR feedback polynomial
            noise <= {
                noise[14:0],
                noise[15] ^ noise[13] ^ noise[12] ^ noise[10]
            };
        end
    end

endmodule
