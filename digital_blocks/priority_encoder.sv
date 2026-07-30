/*** Priority Encorder ***/
/*
- Encoder is a combinational circuit that converts multiple input lines into a smaller binary code. 
- Usually it has 2^n input lines with only one input active at a time
- The output tells which input line is active.

- Where are they used?
=> Priority encoders are used for interrupt controllers 
=> Encoders are also used to convert one hot signals into binary
*/

module priority_encoder #(
    parameter N = 4
)(
    input logic [(2**N)-1:0] in,
    output logic [N-1:0] out
);
    int i;
    always_comb begin
        out = '0;
        for(i = 0;i<2**N;i++) begin
            if(in[i]) out = i;
        end
    end
endmodule

module test;
    localparam N = 4;
    logic [(2**N)-1:0] in;
    logic [N-1:0] out;

    priority_encoder #(.N(N)) dut(.*);

    initial begin
        $dumpfile("waves/priority_encoder.vcd");
        $dumpvars(1, test);
    end

    initial begin
        in = 0;
        #1;
        repeat(10) begin
            void'(std::randomize(in) with {
                $countones(in)==1;
            });
            #1;
        end
        $finish;
    end

    initial $monitor("Time: [%0t], Input = %0d, Output = %0d",$time, in, out);
endmodule

