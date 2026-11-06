// Top module of UART_TX

`include "mux.v"
`include "parity_calc.v"
`include "serializer.v"
`include "fsm.v"

module uart_tx(
    input wire [7:0] p_data,
    input wire parity_en, parity_type,
    input wire data_valid,
    input wire rst,
    input wire clk,

    output wire tx_out,
    output wire busy
);

wire ser_done;
wire ser_en;
wire parity_bit;
wire ser_data;
wire [1:0] mux_sel;

// fsm implementation
fsm tx_fsm(
    .clk(clk),
    .rst(rst),
    .parity_en(parity_en),
    .data_valid(data_valid),
    .ser_done(ser_done),
    .mux_sel(mux_sel),
    .busy(busy),
    .ser_en(ser_en)
);

// MUX implementation
mux tx_mux(
    .mux_sel(mux_sel),
    .ser_data(ser_data),
    .parity_bit(parity_bit),
    .tx_out(tx_out)
);

// serializer implementation
serializer tx_serializer(
    .p_data(p_data),
    .ser_en(ser_en),
    .data_valid(data_valid),
    .busy(busy),
    .rst(rst),
    .clk(clk),
    .ser_done(ser_done),
    .ser_data(ser_data)
);

// Parity calculation
parity_calc tx_parity_calc(
    .p_data(p_data),
    .data_valid(data_valid),
    .parity_type(parity_type),
    .rst(rst),
    .clk(clk)
);

endmodule