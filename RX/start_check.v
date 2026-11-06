// Checking start bit

module start_check(
    input wire start_check_en,
    input wire sampled_bit,
    input wire rst,
    input wire clk,

    output reg start_glitch
);

always @(posedge clk or negedge rst) begin
    if(!rst) begin
      start_glitch <= 1'b0;
    end
    else if(start_check_en) begin
      start_glitch <= (sampled_bit == 1'b1);
    end
    
end

endmodule