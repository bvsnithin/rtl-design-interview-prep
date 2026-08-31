/***** Basic Verilog question - Write a Sequence Detector for 101011 *****/

// This is a registered mealy machine logic. 

module fsm(
    input clk,
    input rst_n,
    input in, 
    output logic detect
);
    
    typedef enum logic[2:0] {
        IDLE, 
        S1,
        S10,
        S101,
        S1010,
        S10101
    } state_t;

    state_t state, next_state;
    logic next_detect;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
            detect <= 0;
        end
        else begin
            state <= next_state;
            detect <= next_detect;
        end
    end

    always_comb begin
        next_state = IDLE;
        next_detect = 0;
        case(state)
            IDLE: begin
                next_state = in ? S1: IDLE;
            end
            S1: begin
                next_state = in ? S1: S10;
            end
            S10: begin
                next_state = in ? S101: IDLE;
            end
            S101: begin
                next_state = in ? S1: S1010;
            end
            S1010: begin
                next_state = in ? S10101: IDLE;
            end
            S10101: begin
                next_state = in ? S1: S1010;
                next_detect = in?1:0;
            end
        endcase
    end
endmodule

module test;
    logic clk;
    logic rst_n;
    logic in;
    logic detect;
    logic input_test_data[] = '{1,0,1,0,1,1,1,0,1,0,0,0,1,0,1,0,1,1,0,0,1,1,1,1,0,1};

    fsm dut(.*);

    initial begin
        $dumpfile("waves/fsm_101011.vcd");
        $dumpvars(1, test);
    end

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        in = 0;
        repeat(2) @(negedge clk);
        rst_n = 1;
        
        foreach(input_test_data[i]) begin
            @(negedge clk);
            in = input_test_data[i];
        end

        @(posedge clk);
        $finish;
    end
endmodule