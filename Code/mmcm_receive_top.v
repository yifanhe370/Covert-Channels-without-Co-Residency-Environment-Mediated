`timescale 1ns / 1ps

//============================================================
// MMCM receiver and UART reporting top module
//============================================================
module mmcm_receive_top(
    input  clk,
    input  enable,
    input  RXD,
    output TXD,
    output end_led,
    output locked_led
    );

wire clk_out;                  // Derived clock (unused)
reg  restart = 'b1;
wire locked;

reg  [2:0]  state;             // Transmit state
reg  [10:0] count;             // Data word counter
reg  SEND;
wire READY;

reg  [7:0]  DATA;
wire [7:0]  rxdata;
reg  [7:0]  rrxdata;

wire [31:0] counter;           // MMCM event counter
reg  pll_rstn;
reg  endflag;

wire rx_ready;
reg  rrx_ready;

reg  [5:0]  resetcount;
reg  [23:0] counter_100ms;

assign end_led = endflag;


// UART interface
uart_simple u_uart_simple (
    .clk      ( clk ),
    .rstn     ( enable ),
    .tx_data  ( DATA ),
    .tx_start ( SEND & (!stop_send) & locked ),
    .rxd      ( RXD ),
    .txd      ( TXD ),
    .rx_reg   ( rxdata ),
    .rx_ready ( rx_ready ),
    .tx_busy  ( READY )
);


// MMCM feedback buffering
BUFG u_bufg_fb (
    .I(clkfb),
    .O(clkfb_buf)
);


// 100 ms timing reference
localparam CNT_100MS = 32'd10_000_000;

always @(posedge clk) begin
    if (!enable)
        counter_100ms <= 32'd0;
    else if (counter_100ms >= CNT_100MS - 1)
        counter_100ms <= 32'd0;
    else
        counter_100ms <= counter_100ms + 1'b1;
end


// MMCM instance
wire clkfb, clkfb_buf;

MMCME2_BASE #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKIN1_PERIOD(10.0),
    .CLKFBOUT_MULT_F(10.0),
    .DIVCLK_DIVIDE(1),
    .CLKOUT0_DIVIDE_F(20.0),
    .CLKOUT0_PHASE(0.0),
    .CLKOUT0_DUTY_CYCLE(0.5),
    .STARTUP_WAIT("FALSE"),
    .REF_JITTER1(0.010)
)
u_mmcm (
    .CLKIN1   (clk),
    .CLKOUT0  (clk_out),
    .CLKFBIN  (clkfb_buf),
    .CLKFBOUT (clkfb),
    .RST      (~pll_rstn),
    .PWRDWN   (1'b0),
    .LOCKED   (locked)
);


// MMCM event counter
counter u_counter(
    .clk        (clk),
    .rstn       (enable),
    .mmcm_rstn  (mmcm_rstn),
    .locked     (locked),
    .counter    (counter)
);

reg stop_send;
wire locked_led = locked;


// Control FSM
always @(posedge clk) begin
    if (!enable | (!restart & resetcount > 4)) begin
        // Reset / restart
        stop_send  <= 'b0;
        state      <= 3'b0;
        SEND       <= 1'b0;
        pll_rstn   <= 1'b0;
        rrx_ready  <= 'b0;
        DATA       <= 8'b0;
        count      <= 11'b0;
        endflag    <= 1'b0;
        resetcount <= 6'b0;
        restart    <= 'b1;
    end 
    else if (!locked && (count < 2001) && rxdata != 8'h55) begin
        pll_rstn <= 'b1;
        SEND     <= 'b1;
    end
    else if (locked & !READY & (count < 2001) & !endflag & rxdata != 8'h55) begin
        // Transmit counter (byte-wise)
        case (state)
            3'b000: begin DATA <= counter[31:24]; state <= 3'b001; count <= count + 'b1; end
            3'b001: begin DATA <= counter[23:16]; state <= 3'b010; SEND <= 'b1; end
            3'b010: begin DATA <= counter[15:8];  state <= 3'b100; SEND <= 'b1; end
            3'b100: begin DATA <= counter[7:0];   stop_send <= 'b1; SEND <= 'b0; end
        endcase
    end
    else if (count >= 2001 & rxdata != 8'h55) begin
        endflag <= 'b1;
        SEND    <= 'b0;
    end
    else if (rx_ready) begin
        rrx_ready <= 'b1;
        rrxdata   <= rxdata;
    end
    else if (rrxdata == 8'h55 & rrx_ready) begin
        // Restart command
        resetcount <= resetcount + 'b1;
        if (resetcount > 4)
            restart <= 'b0;
    end
end

endmodule
