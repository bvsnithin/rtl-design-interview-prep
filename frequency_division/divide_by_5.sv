/*** Frequency division by 5 ***/


// Generates a frequency division by 5 with 40% duty cycle - High for 2 cycles and low for 3 cycles
module divide_by_5_40(
    input clk, 
    input rst_n,
    output clk_5_40
);

    logic [2:0] count;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            count <= 0;
        end
        else if(count == 3'd4) begin
            count <= 0;
        end
        else begin
            count <= count + 1;
        end
    end

    assign clk_5_40 = (count <= 3'd1);

endmodule


// Generates a frequency division by 5 with 50% duty cycle - High for 2.5 cycles and low for 2.5 cycles
module divide_by_5_50(
    input clk,
    input rst_n, 
    output clk_5_50
);

    logic [2:0] count;
    logic pos_pulse, neg_pulse;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            count <= 0;
        end
        else if(count == 3'd4) begin
            count <= 0;
        end
        else begin
            count <= count + 1;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            pos_pulse <= 0;
        end
        else if(count <= 3'd1) begin
            pos_pulse <= 1;
        end
        else begin
            pos_pulse <= 0;
        end
    end

    always_ff @(negedge clk or negedge rst_n ) begin
        if(!rst_n) begin
            neg_pulse <= 0;
        end
        else begin
            neg_pulse <= pos_pulse;
        end
    end

    assign clk_5_50 = (pos_pulse | neg_pulse);

endmodule

module test;
    logic clk;
    logic rst_n;
    logic clk_5_40;
    logic clk_5_50;

    divide_by_5_40 dut1(.*);
    divide_by_5_50 dut2(.*);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waves/div_by_5.vcd");
        $dumpvars(1,test);

        rst_n = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;
        repeat(20) @(posedge clk);
        $finish;
    end
endmodule