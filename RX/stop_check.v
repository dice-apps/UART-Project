// Check stop bit

module stop_check(
    input wire stop_check_en,
    input wire sampled_bit,
    input wire rst,
    input wire clk,

    output reg stop_err
);

always @(posedge clk or negedge rst) begin
    if(!rst) begin
      stop_err <= 1'b0;
    end
    else if(stop_check_en) begin
      if(sampled_bit == 1'b1) stop_err <= 1'b0;
      else stop_err <= 1'b1;
    end
end

endmodule