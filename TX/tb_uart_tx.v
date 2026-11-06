`include "uart_tx.v"
`timescale 1ns / 1ps


module tb_uart_tx();

    // Testbench Signals
    reg        clk;
    reg        rst;
    reg        parity_type;
    reg        parity_en;
    reg  [7:0] p_data;
    reg        data_valid;
    
    wire       tx_out;
    wire       busy;

    // Instantiate the Top Module
    uart_tx DUT(
        .clk(clk),
        .rst(rst),
        .parity_type(parity_type),
        .parity_en(parity_en),
        .p_data(p_data),
        .data_valid(data_valid),
        .tx_out(tx_out),
        .busy(busy)
    );

    // Clock Generation: 200 MHz -> 5 ns period -> 2.5 ns half-period[cite: 5]

    always #2.5 clk = ~clk;

    // saving waveforms
    initial begin
        $dumpfile("uart_tx.vcd");
        $dumpvars(0, tb_uart_tx);
    end

    // Test Sequence
    initial begin
        // Initialize Inputs
        clk = 1'b0;
        rst = 1'b1;
        parity_type = 1'b0;
        parity_en = 1'b0;
        p_data = 8'h00;
        data_valid = 1'b0;

        // Apply Asynchronous Active Low Reset[cite: 3]
        #10 rst = 1'b0;
        #10 rst = 1'b1;
        #10;

        // =====================================================================
        // Test Case 1: Send 8'hA5 with Even Parity[cite: 4]
        // =====================================================================
        // Expected Frame: Start(0) -> Data(A5) -> Even Parity -> Stop(1)[cite: 5]
        parity_en   = 1'b1; // Enable parity[cite: 3]
        parity_type = 1'b0; // Even parity[cite: 3]
        p_data      = 8'hA5; // 10100101 -> Even Parity bit = 0
        
        @(negedge clk);
        data_valid = 1'b1; // High for exactly 1 clock cycle[cite: 3]
        @(negedge clk);
        data_valid = 1'b0;
        
        // Wait for transmission to finish (busy goes low)[cite: 3]
        wait(!busy);
        #20;

        // =====================================================================
        // Test Case 2: Send 8'hF3 with No Parity[cite: 4]
        // =====================================================================
        // Expected Frame: Start(0) -> Data(F3) -> Stop(1)[cite: 5]
        parity_en   = 1'b0; // Disable frame parity bit[cite: 3]
        parity_type = 1'b0; // Don't care
        p_data      = 8'hF3; // 11110011
        
        @(negedge clk);
        data_valid = 1'b1; // High for exactly 1 clock cycle[cite: 3]
        @(negedge clk);
        data_valid = 1'b0;
        
        wait(!busy);
        #20;

        // =====================================================================
        // Test Case 3: Send 8'hA5 with Odd Parity[cite: 4]
        // =====================================================================
        // Expected Frame: Start(0) -> Data(A5) -> Odd Parity -> Stop(1)[cite: 5]
        parity_en   = 1'b1; // Enable parity[cite: 3]
        parity_type = 1'b1; // Odd parity[cite: 3]
        p_data      = 8'hA5; // 10100101 -> Odd Parity bit = 1
        
        @(negedge clk);
        data_valid = 1'b1; // High for exactly 1 clock cycle[cite: 3]
        @(negedge clk);
        data_valid = 1'b0;
        
        // Attempt to send data while busy (UART should ignore it)[cite: 3]
        #15;
        p_data = 8'hFF;
        data_valid = 1'b1;
        @(negedge clk);
        data_valid = 1'b0;

        wait(!busy);
        #50;
        
        $display("All test cases completed.");
        $finish;
    end

    // Monitor Output
    //initial begin
    //    $monitor("Time=%0t | rst=%b | data_valid=%b | p_data=%h | parity_en=%b | parity_type=%b || tx_out=%b | busy=%b", 
    //             $time, rst, data_valid, p_data, parity_en, parity_type, tx_out, busy);
    //end

endmodule