/*** Decoder ***/

/*
- It works opposite to encoder
- It converts binary input to onehot signal
- It is used in chip select signal generation
- Number of input signals = N
- Number of output signalsl = 2**N;
*/

module decoder #(
    parameter N = 4
)(
    input logic [N-1:0] in,
    output logic [(2**N)-1:0] out
);
    int i;
    always_comb begin
        out = 0;
        out[in] = 1;
    end
endmodule

module test;
    localparam N = 4;
    logic [N-1:0] in;
    logic [(2**N)-1:0] out;

    decoder #(.N(N)) dut(.*);

    initial begin
        $dumpfile("waves/decoder.vcd");
        $dumpvars(1, test);
    end

    initial begin
        in = 0;
        #1;
        repeat(10) begin
            in = $urandom;
            #1;
        end
        $finish;
    end

    initial $monitor("Time: [%0t], Input = %0d, Output = %0d",$time, in, out);
endmodule