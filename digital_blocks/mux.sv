/*** Parameterized MUX ***/

module mux #(
    parameter N = 4
)(
    input logic[31:0] in[N],
    input logic[$clog2(N)-1:0] sel,
    output logic[31:0] out
);

    assign out = in[sel];

endmodule

module test;
    localparam N = 4;
    logic [31:0] in[N];
    logic [$clog2(N)-1:0] sel;
    logic [31:0] out;

    mux dut(.*);

    initial begin
        repeat(5) begin
            std::randomize(in) with {
                foreach(in[i]) {
                    in[i] < 100;
                }
            };
            sel = $urandom_range(0, N-1);
            #1;
            $display("Input = %p", in);
            $display("Select = %0d", sel);
            $display("Output = %0h", out);
            $display(":::::::::::::::::::::::");
        end
    end
endmodule