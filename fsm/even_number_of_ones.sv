/*************
Design a circuit to detect even number of 1s
*************/

/*
Two states: EVEN and ODD
On reset -> EVEN
On input bit == 1 -> ODD
On input bit == 1 -> EVEN
On input bit == 0 -> SAME STATE
Output == 1 when state == EVEN
*/

module even_ones(
    input clk,
    input rst_n,
    input in,
    output detect
);
    typedef enum logic {EVEN, ODD} state_t;
    state_t state, next_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= EVEN;
        end
        else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        case(state)
            EVEN: next_state = in?ODD:EVEN;
            ODD: next_state = in?EVEN:ODD; 
        endcase
    end

    assign detect = (!rst_n)?0:(state == EVEN);
endmodule

module test;
    logic clk;
    logic rst_n;
    logic in;
    logic detect;

    even_ones dut(.*);

    initial begin
        $dumpfile("waves/even_ones.vcd");
        $dumpvars(1,test);
    end

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        in = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;
        repeat(10) begin
            @(negedge clk);
            std::randomize(in);
        end
        @(posedge clk);
        $finish;
    end


endmodule