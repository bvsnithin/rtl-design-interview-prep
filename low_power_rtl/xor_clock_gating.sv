/********************

XOR Clock Gating

- The problem we solve with XOR based clock gating is for redundant register writes.
- Imagine we have a register that doesn't have an explicit write-enable signal
- If the input to the register is always the same for 100 consecutive clock cycles, in that case
  we have to rewrite the same value to the register over and over again. This consumes lot of dynamic power

Example code:

always_ff @(posedge clk) begin
    q <= d;
end

- If value is 8'hAA for 100 clock cycles, then each cycle we have to re-write with the same value
- This could be easily solved with the following adjustment

if(q!=d) begin  
    q <= d;
end

- This means we only perform the write when a new value arrives. However, during synthesis this will
  create a multiplexer. 
  1) select d when q != d 
  2) select q when q == d

- The other issue is the clock pin is still toggling even when there is a redundant write. That means it will
  continue to consume dynamic power

How XOR Clock Gating Solves

- Using the XOR of d and q, we will create an xor_enable signal which will then be fed as the input to the 
  clock gating cell's enable input to generate a gated clock
- The register now get's triggered on posedge of gated clock

*********************/

module clock_gating(
    input in_clk, 
    input enable,
    output gated_clk
);
    logic enable_latched;

    always_latch begin
        if(!in_clk) begin
            enable_latched <= enable;
        end
    end

    assign gated_clk = in_clk & enable_latched;
endmodule

module xor_gating(
    input        clk, 
    input        rst_n,
    input  logic [7:0]  d,
    output logic [7:0] q 
);
    logic xor_enable;
    logic gated_clk;

    assign xor_enable = !rst_n ? 1'b1 : |(d ^ q);

    clock_gating icg(
        .in_clk(clk),
        .enable(xor_enable),
        .gated_clk(gated_clk)
    );

    always_ff @(posedge gated_clk) begin
        if(!rst_n) begin
            q <= 8'h0;
        end
        else q <= d;
    end


endmodule

module test;
    logic clk;
    logic [7:0] d;
    logic rst_n;
    logic [7:0] q;

    initial clk = 0;
    always #5 clk = ~clk;

    xor_gating dut(.*);

    initial begin
        $dumpfile("waves/xor_gating.vcd");
        $dumpvars(0,test);
    end

    initial begin
        
        rst_n = 0;
        d=0;
        repeat(2) @(posedge clk);
        rst_n = 1;
        repeat(5) begin
            @(posedge clk);
            d <= 8'h66;
        end

        repeat(10) begin
            @(posedge clk);
            d <= $urandom();
        end

        $finish;

    end
endmodule