/**********************
Write RTL code to detect toggle (0 -> 1 or 1->0)
**********************/

// This detects 0 to 1 toggle
module toggle_detector(
    input clk,
    input in,
    output toggle_detect
);

    logic in_delayed; // Registered input

    always_ff @(posedge clk) begin
        in_delayed <= in;
    end

    assign toggle_detect = in & ~in_delayed; // input is high but the previous input was low -> means there is a toggle from 0 to 1!
    // Use xor(^) to detect both 0->1 and 1->0

endmodule

module test;
    logic clk;
    logic in;
    logic toggle_detect;

    initial begin
        $dumpfile("waves/toggle_detector.vcd");
        $dumpvars(1, test);
    end

    toggle_detector dut(.*);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        in = 0;
        repeat(2) @(negedge clk);
        in = 1;
        repeat(15) begin
            @(posedge clk);
            in <= $urandom_range(0,1); // Use NBA to drive the input to avoid any race conditions. 
        end
        @(posedge clk);
        $finish();
    end

    always @(posedge clk) begin
        $strobe("[TIME: %0t] | Input = %0b | Output Toggle Detect = %0b", $time, in, toggle_detect);
    end
endmodule