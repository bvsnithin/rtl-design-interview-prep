/* Write RTL to perform frequency division by 4 */

module divide_by_4(
    input clk, 
    input rst_n,
    output clk_4
);
    logic [1:0] counter;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end

    assign clk_4 = (counter[1]==1);
endmodule

module test;
    logic clk;
    logic rst_n;
    logic clk_4;

    divide_by_4 dut(.*);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waves/div_by_4.vcd");
        $dumpvars(1, test);

        rst_n = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;

        repeat(20) @(posedge clk); 
        $finish;
    end
endmodule