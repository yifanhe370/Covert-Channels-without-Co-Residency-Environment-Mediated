`timescale 1ns/1ps

//============================================================
// Event counter for MMCM unlock behavior
//============================================================
module counter (
    input clk,                 // System clock
    input rstn,                 // Active-low global reset
    input mmcm_rstn,            // Active-low MMCM reset
    input locked,               // MMCM lock status
    output reg [31:0] counter   // Event counter output
);

always @(posedge clk ) begin
    if (!rstn)
        counter <= 0;           // Global reset
    else if(!mmcm_rstn)
        counter <= 'b0;         // Reset during MMCM reinitialization
    else if (!locked && mmcm_rstn)
        counter <= counter+'b1;// Count cycles while MMCM is unlocked
end

endmodule //counter
