/******* Round Robin Arber *******/


module arbiter(
    input clk, 
    input rst_n,
    input [3:0] in,
    output logic [3:0] grant,
    output logic [1:0] grant_index,
    output logic grant_valid
);

    logic [3:0] next_grant;
    logic [1:0] next_grant_index;
    logic next_grant_valid;

    logic[1:0] last_index; //We need to remember the last granted request
    logic[1:0] next_last_index;


    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            grant <= '0;
            grant_index <= '0;
            grant_valid <= 0;
            last_index <= 2'd3;      // This means we will start with the order 0->1->2->3 after reset
        end
        else begin
            grant <= next_grant;
            grant_index <= next_grant_index;
            grant_valid <= next_grant_valid;
            last_index <= next_last_index;
        end
    end

    always_comb begin
        next_grant = 0;
        next_grant_index = 0;
        next_grant_valid = 0;
        next_last_index = last_index;
        
        for(int i = 1;i<5;i++) begin
            logic[1:0] index;
            index = (last_index + i[1:0])%4;

            if((next_grant_valid == 0) && in[index]) begin
                next_grant[index] = 1;
                next_grant_index = index;
                next_last_index = index;
                next_grant_valid = 1;
            end
        end
    end
    

endmodule


module test;
    logic clk;
    logic rst_n;
    logic [3:0] in;
    logic [3:0] grant;
    logic [1:0] grant_index;
    logic grant_valid;

    arbiter dut(.*);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waves/round_robin_arbiter.vcd");
        $dumpvars(1, test);
    end

    initial begin
        rst_n = 0;
        in = '0;

        repeat(2) @(posedge clk);
        rst_n = 1;

        repeat(2) begin
            @(negedge clk);
            in = 4'b0000; //No incoming requests from any of the requesters. 
        end

        repeat(10) begin
            @(negedge clk);
            in = $urandom;
        end

        $finish;
    end

    //Assertions

    // 1) Grant signal is one hot only
    property grant_one_hot;
        @(posedge clk)
        disable iff(!rst_n)
        $onehot0(grant);
    endproperty

    assert_grant_one_hot: assert property (grant_one_hot)
    else $error("Assertion failed: Grant is not one hot");

    // 2) If current input and past input are same one-hot value, then the current grant and past grant will be the same
    property back_to_back_same_onehot;
        @(posedge clk)
        disable iff(!rst_n)
        in == $past(in) && $onehot(in) |-> grant == $past(grant);
    endproperty

    assert_back_to_back_same_onehot: assert property (back_to_back_same_onehot)
    else $error("Assertion failed: Back to Back Same Onehot signals but grant is not same");

endmodule