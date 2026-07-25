/******* What is clock gating? *******

- Clock gating is a low power design technique.
- Through clock gating we can dynamically disable the clock signal to specific registers or blocks when they are idle 
  or do not need to change state
- A simple clock gated design is show in this file. However, this design is prone to glitches when enable signal changes during
  a positive clock cycle or negativ clock cycle. 
- If enable goes low mid-way through a high clock cycle, clk_out drops to 0 prematurely, 
  creating a short clock pulse that can cause setup/hold violations or state corruption in the destination registers.
- Hence a negative level sensitive latch is used

Why Latch over a Flip Flop?
- Because latch is smaller in area and consumers lower power than flipflops

*************************************/

module clock_gating(
    input clk, 
    input enable,
    output clk_out
);
    assign clk_out = clk & enable;
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
        $dumpfile("waves/enable_clock_gating.vcd");
        $dumpvars(1, test);
    end

    initial begin
        enable = 0;
        #20;
        enable = 1;
        #20;
        enable = 0;
        #30;
        enable = 1;
        //--- This causes glitch in output ---
        #2;
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
        $finish;
    end
endmodule