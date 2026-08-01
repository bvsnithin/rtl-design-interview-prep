/**** Design a finite state machine FSM for a serial two’s complement block ****/

/******
To convert a normal representation to 2's complement representation we follow the following steps
1) Moving from LSB -> MSB, retain all the bits until a 1 is seen. Retain the 1 bit as well
2) Invert all the bits after the 1st one is seen

Example: 0111 (7 in binary unsigned representation)
1) Retain all bits till a 1 is seen: output => 1
2) Since we found 1 at the very first index, we retain and invert everything after that: output => 1001(-7 in signed 2's complement form)

Example: 0100 (4 in binary unsigned representation)
1) Retain all bits till 1 is seen: output => 100
2) Since we found 1 at index 2 from the lsb, we invert bits after that: output => 1100 (-4 in signed 2's complement form)

FSM Design
State A: We have not yet found the first 1 bit from the LSB
State B: We have found the first high bit (1),let's invert everything after that

State Transition Table
Current State | Input | Next State | Output
     A        |   0   |     A      |    0 
     A        |   1   |     B      |    1 
     B        |   0   |     B      |    1
     B        |   1   |     B      |    0

Next State = Current State or Input
Output = Current State xor Input

******/

module twos_complement(
     input clk,
     input rst_n,
     input in,
     output logic out
);

     logic state; // state A is logic 0 and state B is logic 1
     logic next_state;

     always_ff @(posedge clk or negedge rst_n) begin
          if(!rst_n) begin
               state <= 0;
          end
          else state <= next_state;
     end

     always_comb begin
          next_state = state | in;
          out = state ^ in;
     end
endmodule


// Reference model testbench
module test;

     logic clk;
     logic rst_n;
     logic in;
     logic out;

     twos_complement dut(.*);

     initial clk = 0;
     always #5 clk = ~clk;

     initial begin
          $dumpfile("waves/twos_complement.vcd");
          $dumpvars(1, test);
     end

     /**** Task to test a 4bit input word ****/
     task automatic test_word(input logic[3:0] word);

          logic[3:0] expected;       // Expected result of 2's complement for given input

          expected = (~word)+1; // 2's complement

          $display("Input word: %04b", word);
          $display("Expected word: %04b", expected);

          // Reset
          rst_n = 0;
          in = 0;
          repeat(2) @(posedge clk);
          rst_n = 1;
          @(posedge clk);
          for(int i =0;i<4;i++) begin
               @(negedge clk);
               in = word[i];

               #1;
               if(out != expected[i]) begin
                    $error("Bit %0d failed: in = %0b, out = %b, expected out = %b", i,in,out,expected[i]);
               end
               else begin
                    $display("Bit %0d passed: in = %0b, out = %b, expected out = %b", i,in,out,expected[i]);
               end
               @(posedge clk);
          end

     endtask

     initial begin
          in =0;
          rst_n =1;

          test_word(4'b0000);
          test_word(4'b0001);

          test_word(4'b0111);
          test_word(4'b0100);

          test_word(4'b0010);
          test_word(4'b0011);
          test_word(4'b0101);
          test_word(4'b1111);
          test_word(4'b1000);
          test_word(4'b1010);
          test_word(4'b1101);

          $finish;
     end
endmodule