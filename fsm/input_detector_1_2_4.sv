/*
This is not a fsm question but I am adding it here for now. 

Let's say we have a 3 bit signal coming in, we want the output to be high when the input is 1, 2 and 4. 
How will you design that? 
*/

module input_detector(
    input clk,
    input rst_n,

    input logic [2:0] in,
    output logic out
);

    always_ff @(posedge clk or negedge rst_n ) begin 
        if(!rst_n) begin
            out <= 0;
        end
        else begin
            out <= (in == 3'h1 || in == 3'h2 || in == 3'h4);
        end
    end

endmodule

module test;
    logic clk;
    logic rst_n;

    logic [2:0] in;
    logic out;

    input_detector dut(.*);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waves/input_detector.vcd");
        $dumpvars(0, test);
    end

    initial begin
        rst_n = 0;
        in = '0;
        repeat(2) @(negedge clk);
        rst_n = 1;

        repeat(10) begin
            @(negedge clk);
            std::randomize(in);
            @(posedge clk);
            #1;
            $display("[TIME = %0t], in = %0d, out = %0b", $time, in, out);
        end

        @(posedge clk);
        $finish;
    end
endmodule