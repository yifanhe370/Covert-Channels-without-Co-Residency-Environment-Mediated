// Pseudo-random background noise generator for internal interference modeling
module background_noise (
    input  wire clk,
    input  wire rst,
    input  wire enable,

    output wire noise_out            // Internal signal only
);

    wire [7:0]  noise_level = 8'd32; // Noise intensity
    wire [15:0] rnd;
    reg  [31:0] noise_regs;

    // LFSR-based random source
    lfsr_noise u_lfsr (
        .clk   (clk),
        .rst   (rst),
        .noise (rnd)
    );

    integer i;
    always @(posedge clk) begin
        if (rst)
            noise_regs <= 32'b0;
        else if (enable) begin
            for (i = 0; i < 32; i = i + 1) begin
                if (rnd[i % 16] && (i < noise_level))
                    noise_regs[i] <= ~noise_regs[i];
            end
        end
    end

    // Reduction output to avoid optimization removal
    assign noise_out = ^noise_regs;

endmodule
