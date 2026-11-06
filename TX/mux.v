// Mux to output the UART Data Stream

module mux(
    input wire [1:0] mux_sel, // Four inputs available in mux, hence four combinations needed
    input wire ser_data,
    input wire parity_bit,

    output reg tx_out
);

// Defining start bit (0) and stop bit (1)
localparam START_BIT = 1'b0,
           STOP_BIT = 1'b1;

// Defining inputs to MUX
localparam IN_START_BIT = 2'b00,
           IN_STOP_BIT = 2'b11,
           IN_SER_DATA = 2'b01,
           IN_PARITY_BIT = 2'b10;

always @(*) begin
    case(mux_sel)
    IN_START_BIT : tx_out = START_BIT;
    IN_STOP_BIT : tx_out = STOP_BIT;
    IN_SER_DATA : tx_out = ser_data;
    IN_PARITY_BIT : tx_out = parity_bit;
    default: tx_out = STOP_BIT;
    endcase
end

endmodule