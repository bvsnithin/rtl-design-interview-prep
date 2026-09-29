/*
Write the Verilog behavior of a traffic light controller. 
The controller has two inputs: "clock" and "pedx" (pedestrain crossing), and one output "light" which can be "green", "yellow" or "red". 

Normally, the light will repeat the following: "green" for 120 clock cycles, then "yellow" for 20 clock cycles, and then "red" for 30 cycles. 
On positive edge of "pedx", if the light is green, the light will terminate the current "green" cycle and go to the next "yellow" cycle.
*/

module traffic_light_controller(
    clock, 
    pedx,
    light
);
    parameter GREEN = 2'b00;
    parameter YELLOW = 2'b01;
    parameter RED = 2'b10;

    input wire clock;
    input wire pedx;  // Input signals clock and pedx(pedestrian crossing)
    output reg [1:0] light = GREEN; // Output - green, yellow, and red

    reg[6:0] count = 0;

    always @(posedge clock) begin

        case(light)
            GREEN: begin
                // Pedestrian crossing request
                if(pedx || count == 119) begin
                    light <= YELLOW;
                    count <= 7'd0;
                end
                else begin
                    count <= count + 1'b1;
                end
            end

            YELLOW: begin
                if(count == 19) begin
                    light <= RED;
                    count <= 7'd0;
                end
                else begin
                    count <= count + 1'b1;
                end
            end

            RED: begin
                if(count == 29) begin
                    light <= GREEN;
                    count <= 7'd0;
                end
                else begin
                    count <= count + 1'b1;
                end
            end

            default: begin
                light <= GREEN;
                count <= 7'd0;
            end
        endcase
    end

endmodule

module tb;

    reg clock;
    reg pedx;
    wire [1:0] light;

    parameter GREEN  = 2'b00;
    parameter YELLOW = 2'b01;
    parameter RED    = 2'b10;

    initial clock = 0;
    always #5 clock = ~clock;

    traffic_light_controller dut(.*);

    initial begin
        $dumpfile("waves/traffic_light_controller.vcd");
        $dumpvars(0, tb);
    end

    // Stimulus
    initial begin

        pedx = 0;

        $monitor("Time = %0t | clock = %b | pedx = %b | light = %b | state = %s | count = %0d",
                 $time, clock, pedx, light,
                 (light == GREEN)  ? "GREEN"  :
                 (light == YELLOW) ? "YELLOW" :
                 (light == RED)    ? "RED"    : "UNKNOWN",
                 dut.count);

        // Wait for normal GREEN -> YELLOW -> RED -> GREEN
        #1700;

        // Test pedestrian crossing
        // At this point controller should be in GREEN
        $display(":::::: TESTING PEDESTRIAN CROSSING ::::::");

        #30;
        pedx = 1;
        #10;
        pedx = 0;

        #500;

        $display(":::::: TESTBENCH COMPLETED ::::::");
        $finish;
    end

endmodule

