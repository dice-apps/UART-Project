// FSM

module fsm(
    input wire rx_in,
    input wire parity_en,
    input wire [3:0] bit_count,
    input wire [5:0] edge_count,
    input wire [5:0] prescale,
    input wire parity_error,
    input wire start_glitch,
    input wire stop_error,
    input wire rst,
    input wire clk,

    output reg data_sample_en,
    output reg enable,
    output reg parity_check_en,
    output reg start_check_en,
    output reg stop_check_en,
    output deser_en,
    output data_valid
);

localparam IDLE  = 3'b000,
           START = 3'b001,
           DATA  = 3'b011,
           PARITY = 3'b010,
           STOP = 3'b110,
           VALID = 3'b111;

reg [2:0] current_state, next_state;

// state transition logic
always @(posedge clk or negedge rst) begin
    if(!rst) begin
      current_state <= IDLE;
    end
    else begin
      current_state <= next_state;
    end
end

// next state logic
always @(*) begin
    
end

endmodule