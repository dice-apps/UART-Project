// Adding the sequence logic

module fsm(
    input wire parity_en,
    input wire data_valid, ser_done,
    input rst,
    input clk,

    output reg [1:0] mux_sel,
    output reg busy,
    output reg ser_en
);

// Defining MUX input selectors
localparam IN_START_BIT = 2'b00,
           IN_STOP_BIT = 2'b11,
           IN_SER_DATA = 2'b01,
           IN_PARITY_BIT = 2'b10;

// Defining states
localparam IDLE = 3'b000,
           START = 3'b001,
           DATA = 3'b010,
           PARITY = 3'b011,
           STOP = 3'b100;

reg [2:0] current_state, next_state;

// State transition logic (always sequential)
always @(posedge clk or negedge rst) begin
    if(!rst) begin
      current_state <= IDLE;
    end
    else begin
      current_state <= next_state;
    end
end

// Next state logic (always combinational)
always @(*) begin
    case(current_state)
    IDLE: begin
      if(data_valid) next_state = START;
      else next_state = IDLE;
    end
    START: begin
      next_state = DATA;
    end
    DATA: begin
      if(parity_en && ser_done) next_state = PARITY;
      else if(!parity_en && ser_done) next_state = STOP;
      else next_state = DATA;
    end
    PARITY: begin
      next_state = STOP;
    end
    STOP: begin
      next_state = IDLE;
    end
    default: next_state = IDLE;
    endcase
end

// output logic (always combinational)
// moore machine
always @(*) begin
    mux_sel = IN_STOP_BIT;
    busy = 1'b1;
    ser_en = 1'b0;

    case(current_state)
    IDLE: begin
      busy = 1'b0;      
    end
    START: begin
      mux_sel = IN_START_BIT;
    end
    DATA: begin
      mux_sel = IN_SER_DATA;
      ser_en = 1'b1;
    end
    PARITY: begin
      mux_sel = IN_PARITY_BIT;
    end
    STOP: begin
      mux_sel = IN_STOP_BIT;
    end
    endcase
end

endmodule