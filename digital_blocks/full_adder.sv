/**** Full Adder ***/

module full_adder_behavioral(
    input a,
    input b,
    input cin, 
    output logic sum_behavioral, 
    output logic carry_behavioral
);

    always_comb begin
        {carry_behavioral, sum_behavioral} = a+b+cin;
    end

endmodule


module full_adder_dataflow(
    input a,
    input b,
    input cin, 
    output sum_dataflow, 
    output carry_dataflow
);

    assign sum_dataflow = a ^ b ^ cin;
    assign carry_dataflow = (a & b) | (a & cin) | (cin & b);
endmodule


module test;
    logic a, b, cin;
    logic sum_behavioral, carry_behavioral, sum_dataflow, carry_dataflow;

    full_adder_behavioral dut1(.*);
    full_adder_dataflow dut2(.*);

    initial begin
        $dumpfile("waves/full_adder.vcd");
        $dumpvars(1, test);
        a = 0;
        b = 0;
        cin = 0;
        #1;
        repeat(12) begin
            a = $urandom_range(0,1);
            b = $urandom_range(0,1);
            cin = $urandom_range(0,1);

            #1;
        end

    end
endmodule