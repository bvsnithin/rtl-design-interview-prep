/**** Half Adder ****/

// Behavioral Modelling
// In this type of modelling we describe what the circuit does using procedural staements
// Procedural statements are - always, if, case, arithmetic operators

module half_adder_behavioral(
    input a, 
    input b,
    output logic sum_behavioral, 
    output logic carry_behavioral
);

    always_comb begin
        {carry_behavioral, sum_behavioral} = a+b;
    end

endmodule

// Dataflow Modelling
// In this type we describe how data flows using continuous assignments and operators

module half_adder_dataflow(
    input a, 
    input b,
    output sum_dataflow, 
    output carry_dataflow
);

    assign sum_dataflow = a^b;
    assign carry_dataflow = a&b;

endmodule

// Gatelevel modelling
// In this type we describe a circuit using logic gates

module half_adder_gatelevel(
    input a,
    input b,
    output sum_gatelevel, 
    output carry_gatelevel
);
    xor(sum_gatelevel, a, b);
    and(carry_gatelevel, a,b);
endmodule

// Testbench
module test;
    logic a;
    logic b;
    logic sum_behavioral;
    logic sum_dataflow;
    logic sum_gatelevel;
    logic carry_behavioral;
    logic carry_dataflow;
    logic carry_gatelevel;

    half_adder_behavioral dut1(.*);
    half_adder_dataflow dut2(.*);
    half_adder_gatelevel dut3(.*);

    initial begin
        $dumpfile("waves/half_adder.vcd");
        $dumpvars(1,test);
        a = 0;
        b = 0;
        #1

        repeat(10) begin
            a = $urandom_range(0,1);
            b = $urandom_range(0,1);
            #1;
        end 

    end

endmodule



