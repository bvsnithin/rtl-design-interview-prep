module clock_gating(
    input clk, 
    input enable,
    output clk_out
);
    // Use a negative level sensitive latch
    logic enable_latched;

    always_latch begin
        if(!clk) begin
            enable_latched <= enable;
        end
    end
    
    assign clk_out = clk & enable_latched;
endmodule

module test;
    logic clk;
    logic enable;
    logic clk_out;

    // Clock Generation: 10ns Clock Period, 100 MHz
    initial clk = 0;
    always #5 clk = ~clk;

    clock_gating dut(.*);

    initial begin
        $dumpfile("waves/glitch_free_enable_clock_gating.vcd");
        $dumpvars(1, test);
    end

    initial begin
        enable = 0;
        #20;
        enable = 1;
        #7;
        enable = 0;
        #12;
        enable  = 1;
        #8;
        enable = 0;
        #30;
        enable = 1;
        $finish;
    end
endmodule