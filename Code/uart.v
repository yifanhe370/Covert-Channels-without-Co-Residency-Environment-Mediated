// Fixed-baud UART transmitter and receiver with counter-based timing and FSM-controlled RX

`timescale 1ns/1ps
module uart_simple (
    input        clk,          // system clock
    input        rstn,           // active-low reset
    input  [7:0] tx_data,       // transmit data
    input        tx_start,      // transmit request
    output       tx_busy,       // transmitter busy
    output reg   txd,           // UART TX line

    input        rxd,           // UART RX line
    output reg [7:0] rx_reg,    // received data
    output reg       rx_ready   // receive valid flag
);

    // -------------------------------------------------
    // UART timing parameters
    // -------------------------------------------------
    parameter  CLK_FREQ  = 100_000_000;
    parameter  BAUD_RATE = 115200;
    localparam BAUD_TICK = CLK_FREQ / BAUD_RATE;
    localparam HALF_BAUD_TICK = BAUD_TICK / 2;

    // =================================================
    // Transmitter (TX)
    // =================================================
    reg [9:0]  tx_shift;        // start + data + stop
    reg [13:0] tx_tick_cnt;     // baud counter
    reg [3:0]  tx_bit_cnt;      // bit counter
    reg        tx_active;       // TX enable

    assign tx_busy = tx_active;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            txd <= 1'b1;        // idle high
            tx_active <= 0;
            tx_bit_cnt <= 0;
            tx_tick_cnt <= 0;
        end else begin
            if (tx_start && !tx_active) begin
                tx_shift <= {1'b1, tx_data, 1'b0};
                tx_active <= 1;
                tx_bit_cnt <= 0;
                tx_tick_cnt <= 0;
            end else if (tx_active) begin
                if (tx_tick_cnt == BAUD_TICK - 1) begin
                    tx_tick_cnt <= 0;
                    txd <= tx_shift[0];
                    tx_shift <= {1'b1, tx_shift[9:1]};
                    tx_bit_cnt <= tx_bit_cnt + 1;
                    if (tx_bit_cnt == 9)
                        tx_active <= 0;
                end else begin
                    tx_tick_cnt <= tx_tick_cnt + 1;
                end
            end
        end
    end

    // =================================================
    // Receiver (RX)
    // =================================================
    // RX state machine
    localparam RX_IDLE  = 2'b00;
    localparam RX_START = 2'b01;
    localparam RX_DATA  = 2'b10;
    localparam RX_STOP  = 2'b11;

    reg [1:0]  rx_state;
    reg [3:0]  rx_bit_cnt;      // received bit count
    reg [13:0] rx_tick_cnt;     // baud counter
    reg [7:0]  rx_shift;        // shift register
    reg        rx_got_data;     // data received flag

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            rx_state    <= RX_IDLE;
            rx_bit_cnt  <= 0;
            rx_tick_cnt <= 0;
            rx_ready    <= 0;
            rx_shift    <= 0;
            rx_reg      <= 0;
            rx_got_data <= 0;
        end else begin
            rx_ready <= 0;       // default

            case (rx_state)
                RX_IDLE: begin
                    if (!rxd) begin
                        rx_state    <= RX_START;
                        rx_tick_cnt <= HALF_BAUD_TICK;
                    end
                end

                RX_START: begin
                    if (rx_tick_cnt == 0) begin
                        if (!rxd) begin
                            rx_state    <= RX_DATA;
                            rx_bit_cnt  <= 0;
                            rx_tick_cnt <= BAUD_TICK - 1;
                        end else
                            rx_state <= RX_IDLE;
                    end else
                        rx_tick_cnt <= rx_tick_cnt - 1;
                end

                RX_DATA: begin
                    if (rx_tick_cnt == 0) begin
                        rx_shift   <= {rxd, rx_shift[7:1]};
                        rx_bit_cnt <= rx_bit_cnt + 1;
                        rx_tick_cnt <= BAUD_TICK - 1;
                        if (rx_bit_cnt == 7)
                            rx_state <= RX_STOP;
                    end else
                        rx_tick_cnt <= rx_tick_cnt - 1;
                end

                RX_STOP: begin
                    if (rx_tick_cnt == 0) begin
                        if (rxd) begin
                            rx_reg   <= rx_shift;
                            rx_ready <= 1;
                            rx_got_data <= 1;
                        end
                        rx_state <= RX_IDLE;
                    end else
                        rx_tick_cnt <= rx_tick_cnt - 1;
                end
            endcase
        end
    end
endmodule
