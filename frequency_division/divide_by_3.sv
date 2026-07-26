/* Write RTL to perform frequency division by 3 */

// Frequency division with 33% duty cycle - High for 1 cycle and low for 2 cycles
module divide_by_3_33(
    input clk, 
    input rst_n,
    output clk_3_33
);
    logic [1:0] counter;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            counter <= 0;
        end
        else if(counter == 2'b10) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end

    assign clk_3_33 = (counter==2'b01);
endmodule

// Frequency division with 50% duty cycle - Equal number of high and low cycles
module divide_by_3_50(
    input clk, 
    input rst_n,
    output clk_3_50
);

    logic pos_pulse; //33% duty cycle
    logic neg_pulse; //33% duty cycle but delayed
    logic [1:0] counter;

    // Counter logic
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            counter <= 0;
        end
        else if(counter == 2'b10) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end

    // Create a 33% duty cycle pulse
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            pos_pulse <= 0;
        end
        else if(counter == 2'd00) begin
            pos_pulse <= 1;
        end
        else begin
            pos_pulse <= 0;
        end
    end

    // Delay pos_pulse
    always_ff @(negedge clk or negedge rst_n) begin
        if(!rst_n) begin
            neg_pulse <= 0;
        end
        else neg_pulse <= pos_pulse;
    end

    assign clk_3_50 = pos_pulse | neg_pulse;

endmodule

module test;
    logic clk; 
    logic rst_n;
    logic clk_3_33;
    logic clk_3_50;

    initial clk = 0;
    always #5 clk = ~clk;

    divide_by_3_33 dut1(.*);
    divide_by_3_50 dut2(.*);

    initial begin
        $dumpfile("waves/div_by_3.vcd");
        $dumpvars(0, test);

        rst_n = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;

        repeat(20) @(posedge clk); 
        $finish;
    end
endmodule