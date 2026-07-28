/*** Frequency division by 10 ***/
/** Clock divide by 10 with a duty cycle of 40 **/

module divide_by_10(
    input clk, 
    input rst_n,
    output clk_10_40
);

    logic [3:0] count;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            count <= 0;
        end
        else if(count == 4'd9) begin
            count <= 0;
        end
        else begin
            count<= count+1;
        end
    end

    assign clk_10_40 = count<=4'd3;
endmodule

module test;
    logic clk;
    logic rst_n;
    logic clk_10_40;


    divide_by_10 dut(.*);

    initial begin
        clk = 0;
        $dumpfile("waves/div_by_10.vcd");
        $dumpvars(1,test);
    end

    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;
        repeat(20) @(posedge clk);
        $finish;
    end
endmodule