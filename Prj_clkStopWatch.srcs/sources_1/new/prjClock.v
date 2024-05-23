`timescale 1ns / 1ps

module prjClock (
    input         clk,
    input         reset,
    input         selMode,
    input         minSet,
    input         secSet,
    output [13:0] clockData
);
    wire w_clk_1hz;

    clkDiv #(
        // .MAX_COUNT(100_000_000)
        .MAX_COUNT(10)
    ) U_ClkDiv (
        .clk  (clk),
        .reset(reset),
        .o_clk(w_clk_1hz)
    );

    clock U_CLOCK (
        .clk(clk),
        .reset(reset),
        .tick(w_clk_1hz),
        .selMode(selMode),
        .minSet(minSet),
        .secSet(secSet),
        .clockData(clockData)
    );

endmodule

module clock (
    input         clk,
    input         reset,
    input         tick,
    input         selMode,
    input         minSet,
    input         secSet,
    output [13:0] clockData
);
    reg [59:0] count_min = 0;
    reg [59:0] count_sec = 0;

    assign clockData = ((count_min * 100) + count_sec);

    always @(posedge tick) begin
        if (count_sec == 59) begin
            count_sec <= 0;
            if (count_min == 59) begin
                count_min <= 0;
            end else begin
                count_min <= count_min + 1;
            end
        end else begin
            count_sec = count_sec + 1;
        end
    end

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count_min <= 0;
            count_sec <= 0;
        end else begin
            if (!selMode) begin
                if (minSet) count_min <= count_min + 1;
                else if (secSet) count_sec = count_sec + 1;
            end
        end
    end
endmodule

module clkDiv #(
    parameter MAX_COUNT = 100
) (
    input  clk,
    input  reset,
    output o_clk
);
    reg [$clog2(MAX_COUNT)-1:0] counter = 0;
    reg r_tick = 0;

    assign o_clk = r_tick;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter <= 0;
        end else begin
            if (counter == (MAX_COUNT - 1)) begin
                counter <= 0;
                r_tick  <= 1'b1;
            end else begin
                counter <= counter + 1;
                r_tick  <= 1'b0;
            end
        end
    end
endmodule
