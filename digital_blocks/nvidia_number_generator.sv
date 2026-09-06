/* Number Generator */

/*
Question from NVIDIA - Number generator. Synchronous reset-while reset is asserted, the first post-reset output should be 1. 
Generate the sequence 1, 4, 9, 16, 25, 36, 49, … without using multipliers. How many adders are needed?
*/

module number_generator(
    input clk,
    input reset,
    output logic[31:0] num
);
    logic [31:0] odd_counter;

    always_ff @(posedge clk) begin
        if(reset) begin
            num <= 1;
            odd_counter <= 32'd3;
        end
        else begin
            num <= num + odd_counter;               // First Adder
            odd_counter <= odd_counter + 32'd2;     // Second Adder
        end
    end
endmodule

module test;
    logic clk;
    logic reset;
    logic[31:0] num;

    number_generator dut(.*);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1;
        repeat(2) @(negedge clk);
        reset = 0;
        repeat(5) @(negedge clk);
        reset = 1;
        repeat(2) @(negedge clk);
        reset = 0;
        repeat(5) @(negedge clk);
        $finish;
    end

    initial begin
        $monitor("[TIME: %0t], RESET: %0b, NUM: %0d", $time, reset, num);
    end

endmodule