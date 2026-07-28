/**** Ripple Carry Adder ****/
/*
- With ripple carry adders we can add multi bit binary numbers using a full adder block
- This means we compute addition of two bits one at a time
- Although it's a simple design, the propagation delay is a big drawback for ripple carrry adder
*/

module full_adder(
    input a, b, cin, 
    output sum, cout
);
    assign {cout, sum} = a + b + cin;
endmodule

module ripple_carry_adder#(
    parameter N = 4
)(
    input [N-1:0] a,
    input [N-1:0] b,
    input cin, 
    output [N-1:0] sum,
    output cout
);

    logic [N:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for(i = 0;i<N;i++) begin
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate
    assign cout = carry[N];

endmodule


module test;
    localparam N = 4;
    logic [N-1:0] a,b, sum;
    logic cin, cout;

    logic [N-1:0] expected_sum = 0;
    logic expected_cout = 0;

    ripple_carry_adder dut(.*);

    initial begin
        $dumpfile("waves/ripple_carry_adder.vcd");
        $dumpvars(1,test);

        a = '0;
        b = '0;
        cin = '0;
        #5;
        for(logic[N*N-1:0] i = 0;i<N*N;i++) begin
            a = $urandom();
            b = $urandom();
            cin = $urandom_range(0,1);
            {expected_cout, expected_sum} = a+b+cin;
            #1;
            $display("A = %0d, B = %0d, Cin = %0d, Sum = %0d, Carry = %0d, ", a, b, cin, sum, cout);
            if(expected_sum != sum || expected_cout!=cout) begin
                $display(":::MISMATCH!::: Expected Sum = %0d, Actual Sum = %0d, Expected Carry out = %0d, Actual Carry out = %0d", expected_sum, sum, expected_cout, cout);
            end
        end 
    end
endmodule