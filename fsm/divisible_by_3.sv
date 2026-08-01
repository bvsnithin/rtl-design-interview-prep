/*** Check Whether the incoming stream of data is divisible by 3 at any point of time ***/

/** Division by 3 **/
/*
1/3 => remainder = 1
2/3 => remainder = 2
3/3 => remainder = 0

States
S0 -> Divisible by 3
S1 -> Remainder 1
S2 -> Remainder 2

State Transition Table
Current State | Incoming Data Bit | Next State | Output
S0                  0                   S0         1
S0                  1                   S1         0 
S1                  0                   S2         0 
S1                  1                   S0         1
S2                  0                   S1         0 
S2                  1                   S2         0  
*/

module divisible_by_3(
    input clk,
    input rst_n,
    input in,
    output detect
);
    typedef enum logic[1:0] {S0, S1, S2} state_t;

    state_t state, next_state;

    always_ff @(posedge clk or negedge rst_n ) begin
        if(!rst_n) begin
            state <= S0;
        end
        else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        case(state)
            S0: begin
                next_state = in?S1:S0; 
            end
            S1: begin
                next_state = in?S0:S2; 
            end
            S2: begin
                next_state = in?S2:S1; 
            end
        endcase
    end
    
    assign detect = (!rst_n)?0:(state == S0);

endmodule

/** Testbench **/
module test;
    logic clk;
    logic rst_n;
    logic in;
    logic detect;
    logic test_cases[12];

    divisible_by_3 dut(.*);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waves/modulo_3.vcd");
        $dumpvars(1,test);
    end

    initial begin
        rst_n = 0;
        in = 0;
        test_cases = '{1,1,0,1,1,0,1,0,1,1,1,0};
        repeat(2) @(posedge clk);
        rst_n = 1;

        foreach(test_cases[i]) begin
            @(negedge clk);
            in = test_cases[i];
        end

        $finish;
        
    end
endmodule