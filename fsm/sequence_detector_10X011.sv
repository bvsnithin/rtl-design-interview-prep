/*
Design a circuit that can detect 10X011 (X can be either 0 or 1)

Below is a moore machine fsm design for the sequence detector. 
*/

module fsm(
    input clk, 
    input rst_n,
    input in, 
    output detect
);

    typedef enum logic[2:0] {
        IDLE,
        S1,
        S10,
        S10X,
        S10X0,
        S10X01,
        FINAL
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end

    always_comb begin
        case(state) 
            IDLE: begin
                next_state = in?S1:IDLE;
            end 

            S1: begin
                next_state = in?S1:S10;
            end 

            S10: begin
                next_state = S10X;
            end 

            S10X: begin
                next_state = in?S1:S10X0;
            end 

            S10X0: begin
                next_state = in?S10X01:IDLE;
            end

            S10X01: begin
                next_state = in?FINAL:S10;
            end 

            FINAL: begin
                next_state = in?S1:S10;
            end  
            
            default : begin
                next_state = IDLE;
            end
        endcase
    end

    assign detect = (state == FINAL);

endmodule

module test;
    logic clk;
    logic rst_n;
    logic in;
    logic detect;
    logic  test_array[] = '{1,0,0,0,1,1,1,0,1,1,1,0,1,1,0,1,0,1,1,1,1,0,1,1,1,1,1,0,1,1,0,0,0,1};

    fsm dut(.*);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waves/fsm_10X011.vcd");
        $dumpvars(1, test);
    end

    initial begin
        rst_n = 0;
        in = 0;
        repeat(2) @(negedge clk);
        rst_n = 1;

        foreach(test_array[i]) begin
            @(negedge clk);
            in = test_array[i];

            @(posedge clk);
            #1;
            $display("TIME: %0t, in = %0b, detect = %0b, state = %0s",$time, in, detect, dut.state.name());
        end
        
        @(posedge clk);
        $finish;
    end

endmodule