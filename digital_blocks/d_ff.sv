/********
Write the RTL for D FF with different reset modes
********/

// Synchronous Reset
module dff_s(
    input clk, 
    input reset,
    input d,
    output logic q_s
);
    always @(posedge clk) begin
        if(reset) begin
            q_s <= 0;
        end
        else begin
            q_s <= d;
        end
    end
endmodule

// Asynchronous Reset - Active low
module dff_a(
    input clk, 
    input rst_n,
    input d,
    output logic q_d
);
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            q_d <= 0;
        end
        else begin
            q_d <= d;
        end
    end
endmodule

module test;
    logic clk;
    logic reset;
    logic rst_n;
    logic d;
    logic q_s;
    logic q_d;

    initial begin
        $dumpfile("waves/dff.vcd");
        $dumpvars(1, test);
    end

    initial clk = 0;
    always #5 clk = ~clk;

    dff_s dut1(.*);
    dff_a dut2(.*);

    initial begin
        reset = 1;
        rst_n = 0;
        d = 0;
        repeat(2) @(negedge clk);
        reset = 0;
        rst_n = 1;
        repeat(10) begin
            @(negedge clk);
            d <= $urandom_range(0,1);
        end
        @(posedge clk);
        $finish();
    end

    always @(posedge clk) begin
        $strobe("[TIME: %0t] | D = %0b | Q_S = %0b | Q_A = %0b", $time, d, q_s, q_d);
    end

endmodule