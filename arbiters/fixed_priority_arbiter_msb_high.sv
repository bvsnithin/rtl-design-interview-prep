/*********** 
Fixed priority (MSB has highest priority, decreasing toward LSB)
***********/

module arbiter#(
    parameter N = 4
)(
    input clk, 
    input rst_n,
    input logic[N-1:0] in,
    output logic [N-1:0] grant, 
    output logic [$clog2(N)-1:0] grant_index
);

    logic[N-1:0] next_grant;
    logic[$clog2(N)-1:0] next_grant_index;

    int i;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            grant <= 0;
            grant_index <= 0;
        end
        else begin
            grant <= next_grant;
            grant_index <= next_grant_index;
        end
    end

    always_comb begin
        next_grant = 0;
        next_grant_index = 0;

        for(i = N-1;i>=0;i--) begin
            if(in[i] && (next_grant == 0)) begin
                next_grant = 1'b1 << i;
                next_grant_index = i;
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

    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        $dumpfile("waves/fp_arbiter_msb.vcd");
        $dumpvars(1, test);
    end

    initial begin
        rst_n = 0;
        in = 0;

        repeat(2) @(posedge clk);
        rst_n = 1;

        repeat(10) begin
            @(negedge clk) begin
                in <= $urandom;
            end
        end
        @(posedge clk);
        $finish;
    end

    initial $monitor("%0t in=%b grant=%b idx=%0d", $time, in, grant, grant_index);
endmodule