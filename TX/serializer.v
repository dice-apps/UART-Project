// Converting parallel data bits to serial bits
// UART TX

module serializer(
    input wire [7:0] p_data,
    input wire ser_en, data_valid, busy,
    input wire rst,
    input wire clk,

    output reg ser_done,
    output reg ser_data
);

reg [7:0] shift_reg; // To store parallel data in
reg [2:0] bit_count; // To count the number of bits serialized

always @(posedge clk or negedge rst) begin
    if(!rst) begin
      shift_reg <= 8'b0;
      bit_count <= 3'b0;
      ser_done <= 1'b0;
      ser_data <= 1'b0;
    end
    else if(data_valid && !busy) begin
      shift_reg <= p_data;
      bit_count <= 3'b0;
      ser_done <= 1'b0;
    end
    else if(ser_en) begin
      ser_data <= shift_reg[0];
      shift_reg <= {1'b0, shift_reg[7:1]};
      if(bit_count == 3'd7) begin
        ser_done <= 1'b1;
        bit_count <= 3'b0;
      end
      else begin
        bit_count <= bit_count + 1'b1;
        ser_done <= 1'b0;
      end
    end
    else begin
      ser_done <= 1'b0;
    end
    
end


endmodule