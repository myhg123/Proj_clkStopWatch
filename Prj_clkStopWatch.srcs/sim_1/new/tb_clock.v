`timescale 1ns / 1ps

module tb_clock ();
    reg         clk;
    reg         reset;
    reg         selMode;
    reg         minSet;
    reg         secSet;
    wire [13:0] clockData;

    prjClock dut (
        .clk      (clk),
        .reset    (reset),
        .selMode  (selMode),
        .minSet   (minSet),
        .secSet   (secSet),
        .clockData(clockData)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        selMode = 1'b1;
        minSet = 1'b0;
        secSet = 1'b0;
    end

    initial begin
        #10 reset = 1'b0;
        #100 selMode = 1'b0;
        #100 minSet = 1'b1;
        #10 minSet = 1'b0;
        #100 secSet = 1'b1;
        #10 secSet = 1'b0;
        #10 reset = 1'b1;
        #10 reset = 1'b0;
        #200 selMode = 1'b1;
        #100 minSet = 1'b1;
        #10 minSet = 1'b0;
        #100 secSet = 1'b1;
        #10 secSet = 1'b0;
        #10 reset = 1'b1;
        #10 reset = 1'b0;
    end

endmodule
