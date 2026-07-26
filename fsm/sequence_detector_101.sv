/***** Basic Verilog question - Write a Sequence Detector for 101 *****/

module fsm(
    input clk,
    input rst_n,
    input in,
    output logic detected
);
    typedef enum logic [1:0] {
        IDLE,
        S1,
        S10,
        S101
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
        end
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in) next_state = S1;
                else    next_state = IDLE;
            end
            S1: begin
                if (in) next_state = S1;
                else    next_state = S10;
            end
            S10: begin
                if (in) next_state = S101;
                else    next_state = IDLE;
            end
            S101: begin
                if (in) next_state = S1;
                else    next_state = S10;
            end
            default: next_state = IDLE;
        endcase
    end

    assign detected = (state == S101);

endmodule

/***** TESTBENCH *****/
module test;
    logic clk;
    logic rst_n;
    logic in;
    logic detected;

    fsm dut(.*);

    initial begin
        clk = 0;
        $dumpfile("waves/fsm_101.vcd");
        $dumpvars(0, test);
    end

    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        in = 0;

        repeat(2) @(posedge clk);
        rst_n = 1;

        @(posedge clk);
        in <= 1;
        @(posedge clk);
        in <= 0;
        @(posedge clk);
        in <= 1;

        repeat(10) begin
            @(posedge clk);
            in <= $random();
        end

        @(posedge clk);
        $finish;
    end
endmodule