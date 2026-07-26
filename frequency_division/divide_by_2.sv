/* Write RTL to perform frequency division by 2 */

module divide_by_2(
    input clk,
    input rst_n,
    output logic clk_2
);
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            clk_2 <=0;
        end
        else begin
            clk_2 <= ~clk_2;
        end
    end
endmodule

module test;
    logic clk;
    logic rst_n;
    logic clk_2;

    divide_by_2 dut(.*);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waves/div_by_2.vcd");
        $dumpvars(1, test);

        rst_n = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;

        repeat(20) @(posedge clk); 
        $finish;
    end
endmodule