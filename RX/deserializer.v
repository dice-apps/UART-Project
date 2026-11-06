// Deserializer
// Reconstructs a parallel 8 bit frame by a sequence of serial data

module deserializer(
    input wire deser_en,
    input wire sampled_bit,
    input wire [5:0] edge_count,
    input wire [5:0] prescale,
    input wire rst,
    input wire clk,

    output reg [7:0] p_data
);

always @(posedge clk or negedge rst) begin
    if(!rst) begin
      p_data <= 8'b0;
    end
    else if(deser_en) begin
      if(edge_count == prescale - 1) begin // shifting/adding data at the very end of the oversampled bit period
        p_data <= {sampled_bit, p_data[7:1]};
      end
    end
    
end

endmodule