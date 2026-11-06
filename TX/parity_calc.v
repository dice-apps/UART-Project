// Parity Calculator for UART TX

module parity_calc(
    input wire [7:0] p_data,
    input wire data_valid, parity_type,
    input wire rst,
    input wire clk,

    output reg parity_bit
);

always @(posedge clk or negedge rst) begin
    if(!rst) begin
      parity_bit <= 1'b0;
    end
    else if(data_valid) begin
      if(!parity_type) begin // parity_type = 0, for even parity
        parity_bit <= ^p_data; // bitwise XOR operation | XOR -> Odd detector
      end
      else begin
        parity_bit <= ~^p_data;
      end
    end
end

endmodule