/****** An input bit pattern is coming in. Determine at any point if the number is divisible by 5 or not. ******/

/**** Divisibility by 5 logic

n = 1: n%5 = 1 not divisible by 5
n = 2: n%5 = 2 not divisible by 5
n = 3: n%5 = 3 not divisible by 5
n = 4: n%5 = 4 not divisible by 5
n = 5: n%5 = 5     divisible by 5

We will model these remainders as states for the state machine
Remainder = 0 => S0 (Divisible by 5)
Remainder = 1 => S1
Remainder = 2 => S2
Remainder = 3 => S3
Remainder = 4 => S4

If current_state == S0 => Then the input stream of numbers is divisible by 5

State Transitions
Current State | Input | Next State | Output
S0               1          S1        0
S0               0          S0        1  
S1               1          S3        0 
S1               0          S2        0
S2               1          S0        1 
S2               0          S4        0 
S3               1          S2        0              
S3               0          S1        0      
S4               1          S4        0
S4               0          S3        0      

****/

module modulo_5(
    input clk,
    input rst_n,
    input input_data,
    output logic output_detect
);

    typedef enum logic[2:0] {S0,S1,S2,S3,S4} state_t;
    state_t state, next_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= S0;
            output_detect <= 1;
        end
        else begin
            state <= next_state;
            output_detect <= (next_state == S0);
        end
    end

    always_comb begin
        next_state = state;
        case(state)
            S0: begin
                next_state = input_data?S1:S0;
            end
            S1: begin
                next_state = input_data?S3:S2;
            end
            S2: begin
                next_state = input_data?S0:S4;
            end
            S3: begin
                next_state = input_data?S2:S1;
            end
            S4: begin
                next_state = input_data?S4:S3;
            end
        endcase
    end
endmodule

module test;
    logic clk;
    logic rst_n;
    logic input_data;
    logic output_detect;
    logic input_test_data[] = '{1,0,1,0,1,1,1,0,1,0,0,0,1,0,1,1,0,0,1,0,1,1,1,1,0,1};

    modulo_5 dut(.*);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waves/modulo_5.vcd");
        $dumpvars(0, test);
    end

    initial begin
        rst_n = 0;
        input_data = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;

        foreach(input_test_data[i]) begin
            input_data <= input_test_data[i];
            @(posedge clk);
        end

        @(posedge clk);
        $finish;
    end


endmodule