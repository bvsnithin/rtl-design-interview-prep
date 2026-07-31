/******* Binary To Gray Convertor *******/
 
module binary_to_gray#(
    parameter N = 4
)(
    input logic [N-1:0] bin_in,
    output logic [N-1:0] gray_out
 );
    assign gray_out = {bin_in[N-1],{bin_in[N-1:1] ^ bin_in[N-2:0]}};
 endmodule

/******* Gray To Binary Convertor *******/
module gray_to_binary#(
    parameter N = 4
)(
    input logic [N-1:0] gray_in,
    output logic [N-1:0] bin_out
);
    always_comb begin
        bin_out[N-1] = gray_in[N-1];
        for(int i =N-2;i>-1;i--) begin
            bin_out[i] = bin_out[i+1] + gray_in[i];
        end
    end
endmodule

/******* Test Bench *******/
module test;
    localparam N = 4;
    logic [N-1:0] gray_in;
    logic [N-1:0] gray_out;
    logic [N-1:0] bin_in;
    logic [N-1:0] bin_out;
    logic[3:0] test_cases[16];
    int mismatches;

    binary_to_gray #(.N(N)) dut1(.*);
    gray_to_binary #(.N(N)) dut2(.*);

    initial begin
        $dumpfile("waves/binary_gray_conversions.vcd");
        $dumpvars(1, test);
    end

    initial begin
        bin_in = '0;
        gray_in = '0;
        mismatches = 0;
        #1;
        test_cases = '{4'd0,4'd1,4'd2,4'd3,4'd4,4'd5,4'd6,4'd7,4'd8,4'd9,4'd10,4'd11,4'd12,4'd13,4'd14,4'd15};
        foreach(test_cases[i]) begin
            bin_in = test_cases[i];
            #1;
            gray_in = gray_out;
            #1;
            $display(":::::::::::::::::::::\n\nBINARY TO GRAY: Input Binary = %04b, Output Gray: %04b", bin_in, gray_out);
            $display("GRAY TO BINARY: Input Gray = %04b, Output Binary: %04b \n:::::::::::::::::::::\n", gray_in, bin_out);
            if(bin_in!=bin_out) begin
                mismatches++;
            end
        end
        if(mismatches!=0) begin
            $display("Check logs, conversion failed");
        end
        $finish;
    end

endmodule