// Checking parity bit for transmission errors

module parity_check(
    input wire parity_check_en,
    input wire sampled_bit,
    input wire parity_type,
    input wire [7:0] p_data,
    input wire rst,
    input wire clk,

    output reg parity_err
);

reg expected_parity;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
      parity_err <= 1'b0;
      expected_parity <= 1'b0;
    end
    else if(parity_check_en) begin
      if(parity_type == 1'b0) begin // even parity
        expected_parity <= ^p_data;
      end
      else begin
        expected_parity <= ~^p_data;
      end

      parity_err <= (expected_parity != sampled_bit);
    end
end

endmodule