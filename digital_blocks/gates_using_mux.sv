/***** NOT GATE USING 2:1 MUX *****/

/*:::: NOT GATE ::::*/
module not_gate(
    input a,
    output inv_a
);

    assign inv_a = a?0:1;

endmodule

/*:::: AND GATE ::::*/
module and_gate(
    input a,
    input b,
    output a_and_b
);
    assign a_and_b = a ? b : 0;
endmodule

/*:::: OR GATE ::::*/
module or_gate(
    input a, 
    input b,
    output a_or_b
);

    assign a_or_b = a ? 1 : b;

endmodule

/*:::: NAND GATE ::::*/
module nand_gate(
    input a,
    input b,
    output a_nand_b
);
    assign a_nand_b = a ? (b ? 0 : 1) : 1;
endmodule

/*:::: NOR GATE ::::*/
module nor_gate(
    input a,b,
    output a_nor_b
);
    assign a_nor_b = a ? 0 : (b ? 0 : 1);
endmodule


/******************* TEST BENCH *******************/
module test;
    logic a;
    logic b;
    logic inv_a;
    logic a_and_b;
    logic a_or_b;
    logic a_nand_b;
    logic a_nor_b;

    not_gate dut1(.*);
    and_gate dut2(.*);
    or_gate dut3(.*);
    nand_gate dut4(.*);
    nor_gate dut5(.*);

    initial begin
        $display("a | b | inv_a | a_and_b | a_or_b | a_nand_b | a_nor_b");
        
        a = 0;
        b = 0;
        #1;

        repeat(8) begin
            std::randomize(a);
            std::randomize(b);
            #1;
            $display("%0d | %0d |   %0d   |    %0d    |     %0d  |     %0d    |     %0d    ",a,b,inv_a,a_and_b, a_or_b,a_nand_b, a_nor_b);
        end
    end
endmodule