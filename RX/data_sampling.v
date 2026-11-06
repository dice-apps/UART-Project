// Data Sampling
// Checking whether the same bit is present in multiple edges

module data_sampling(
    input wire data_sample_en,
    input wire rx_in,
    input wire [5:0] edge_count,
    input wire [5:0] prescale,
    input wire rst,
    input wire clk,

    output reg sampled_bit
);

reg [2:0] samples;
wire [5:0] mid = (prescale >> 1); // Right shift by 1 is division by 2^1

always @(posedge clk or negedge rst) begin
    if(!rst) begin
      samples <= 3'b0;
      sampled_bit <= 1'b0;
    end
    else if(data_sample_en) begin
      if(edge_count == mid - 1) begin
        samples[0] <= rx_in;
      end
      else if(edge_count == mid) begin
        samples[1] <= rx_in;
      end
      else if(edge_count == mid + 1) begin
        samples[2] <= rx_in;
      end
      
      if(edge_count == mid + 2'd2) begin
        sampled_bit <= (samples[0] & samples[1]) | (samples[1] & samples[2]) | (samples[0] & samples[2]);
      end
      // sampled_bit will be holding the same value
    end
end

endmodule