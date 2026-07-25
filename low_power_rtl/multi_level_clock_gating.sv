/******** Multi Level Clock Gating ********/

module icg(
    input clk_in, 
    input enable,
    output clk_out
);
    logic enable_latched;

    always_latch begin
        if(!clk_in) begin
            enable_latched <= enable;
        end
    end

    assign clk_out = clk_in & enable_latched;
endmodule

module multi_level_gating(
    input system_clk,
    input system_enable,
    input rst_n,
    input reg1_en,
    input reg2_en,
    input logic [15:0] d1,d2,
    output logic [15:0] q1, q2
);

    logic system_clk_gated;
    logic reg1_clk;
    logic reg2_clk;

    icg icg_1(
        .clk_in(system_clk),
        .enable(system_enable),
        .clk_out(system_clk_gated)
    );

    icg icg_2(
        .clk_in(system_clk_gated),
        .enable(reg1_en),
        .clk_out(reg1_clk)
    );

    icg icg_3(
        .clk_in(system_clk_gated),
        .enable(reg2_en),
        .clk_out(reg2_clk)
    );

    always_ff @(posedge reg1_clk or negedge rst_n) begin
        if(!rst_n) begin
            q1 <= '0;
        end
        else begin
            q1 <= d1;
        end
    end

    always_ff @(posedge reg2_clk or negedge rst_n) begin
        if(!rst_n) begin
            q2 <= '0;
        end
        else begin
            q2 <= d2;
        end
    end
endmodule

module test;
    logic        system_clk = 0;
    logic        system_enable = 0;
    logic        rst_n = 0;
    logic        reg1_en = 0;
    logic        reg2_en = 0;
    logic [15:0] d1 = 0;
    logic [15:0] d2 = 0;
    logic [15:0] q1;
    logic [15:0] q2;

    always #5 system_clk = ~system_clk;

    multi_level_gating dut (
        .system_clk(system_clk),
        .system_enable(system_enable),
        .rst_n(rst_n),
        .reg1_en(reg1_en),
        .reg2_en(reg2_en),
        .d1(d1),
        .d2(d2),
        .q1(q1),
        .q2(q2)
    );

    initial begin
        $dumpfile("waves/multi_level_clock_gating.vcd");
        $dumpvars(0, test);
    end

    initial begin
        rst_n = 0;
        system_enable = 1;
        reg1_en = 1;
        reg2_en = 1;
        #15;
        rst_n = 1;
        #5;

        system_enable = 0;
        reg1_en = 1;
        reg2_en = 1;
        d1 = 16'hAAAA;
        d2 = 16'hBBBB;
        repeat(3) @(posedge system_clk);

        system_enable = 1;
        reg1_en = 1;
        reg2_en = 0;
        d1 = 16'h1111;
        d2 = 16'h2222;
        repeat(3) @(posedge system_clk);

        reg1_en = 0;
        reg2_en = 1;
        d1 = 16'h3333;
        d2 = 16'h4444;
        repeat(3) @(posedge system_clk);

        reg1_en = 1;
        reg2_en = 1;
        d1 = 16'h5555;
        d2 = 16'h6666;
        repeat(3) @(posedge system_clk);

        $finish;
    end
endmodule