// Edge bit counter
// Responsible for tracking the oversampling ticks

module edge_bit_counter(
    input wire enable,
    input wire [5:0] prescale, // Precale values 8, 16, 32
    input wire rst,
    input wire clk,

    output reg [3:0] bit_count,
    output reg [5:0] edge_count
);


always @(posedge clk or negedge rst) begin
    if(!rst) begin
      edge_count <= 6'b0;
      bit_count <= 4'b0;
    end
    else if(enable) begin
      if(edge_count == prescale - 1) begin
        edge_count <= 6'b0;
        bit_count <= bit_count + 1'b1;
      end
      else begin
        edge_count <= edge_count + 1'b1;
      end
    end
    else begin
      edge_count <= 6'b0;
      bit_count <= 4'b0;
    end
end

endmodule