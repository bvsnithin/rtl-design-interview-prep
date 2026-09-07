/*****
Design a 4-bit Maximal-Length LFSR in SystemVerilog using the Fibonacci configuration with the following feedback polynomial
x^4 + x^3 + 1

What is the maximum sequence length (period) for this 4-bit LFSR?
- For 4 bit LFSR maximum sequence length = 2^4-1 = 15

What is the "lockup state" (illegal state), and how do you handle initialization?
- Lockup state = 0000. 
- Because the feedback path uses XOR logic, all zero states will produce a feedback of zero
- Inorder to avoid this, we need a reset logic to seed the register with a non zero value. 

Write the SystemVerilog module.

*****/

/****
LFSR: Linear Feedback Shift Register
- It is a shift register whose input bit is driven a linear function of it's previous state. 
- Though the sequence appears random, it is entirely predictable once the initial state (called as seed) and polynomial are known.

Maximal Length - It is an n-bit LFSR that steps through every possible non-zero state before repeating. 

Types of LFSR
1) Fibonacci - Also known as External/Many to one 
- Taps are taken from multiple flip-flop outputs, XORed together externally, and fed back into a single input stage. 
- It is simple to conceptualize, but long XOR chains slow down the max clock speed.

2) Galois - Known as Internal/One to many
- Output bit is fed back simultaneously and XORed internally between individual flip-flop stages. 
- Offers much higher operational speeds due to parallel XOR operations.

3) Non-Linear Feedback Shift Register
- Uses non-linear functions (AND, OR) instead of pure linear gates (XOR/XNOR) to generate unpredictable sequences 
- Has application in cryptography.

****/

module lfsr(
    input clk,
    input rst_n,
    output logic [3:0] q
);

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            q <= 4'b0001;
        end
        else begin
            q <= {q[2:0], q[3] ^ q[2]};
        end
    end

endmodule

module test;
    logic clk;
    logic rst_n;
    logic [3:0] q;

    lfsr dut(.*);

    initial clk =0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;

        repeat(10) @(posedge clk);
        rst_n = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;
        repeat(20) @(posedge clk);

        $finish;
    end

    initial begin
        $monitor("[TIME: %0t], LFSR value = %04b", $time, q);
    end
endmodule