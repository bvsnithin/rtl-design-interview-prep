/*************
Fixed priority (LSB has highest priority, decreasing toward MSB)
*************/

module arbiter#(
    parameter N = 8
)(
    input clk,
    input rst_n,
    input [N-1:0] in,
    output logic [N-1:0] grant,
    output logic [$clog2(N)-1:0] grant_index
);

    logic[N-1:0] next_grant;
    logic[$clog2(N)-1:0] next_index;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            grant <= '0;
            grant_index <= '0;
        end
        else begin
            grant <= next_grant;
            grant_index <= next_index;
        end
    end

    
    int i;

    always_comb begin
        //Default values for next_grant and next_index
        next_grant = 0;
        next_index = 0;

        for(i = 0;i<N;i++) begin

            if(in[i] && (next_grant == 0)) begin
                next_grant = 1'b1 << i;
                next_index = i;
            end 

        end
    end
endmodule

module test;

    localparam N = 4;
    logic clk;
    logic rst_n;
    logic [N-1:0] in;
    logic [N-1:0] grant;
    logic [$clog2(N)-1:0] grant_index;
    arbiter #(.N(N)) dut(.*);

    // Clock Generation
    initial clk = 0;
    always #5 clk = ~clk;


    // Waveform
    initial begin
        $dumpfile("waves/fp_arbiter_lsb.vcd");
        $dumpvars(1, test);
    end

    initial begin
        rst_n = 0;
        in = '0;
        repeat(2) @(posedge clk);
        rst_n = 1;
        repeat(10) begin
            @(negedge clk) begin
                in <= $urandom;
            end
        end
        $finish;
    end 
endmodule