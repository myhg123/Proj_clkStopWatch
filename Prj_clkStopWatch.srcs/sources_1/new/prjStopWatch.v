`timescale 1ns / 1ps

module prjStopWatch (
    input clk,
    input reset,
    input tick,
    input btn1_Tick,  // run_stop
    input btn2_Tick,  // clear
    input btn_Mode,
    output [13:0] count
);

    localparam STOP = 0, START = 1, CLEAR = 2;

    reg [1:0] state, state_next;
    reg [13:0] counter_reg, counter_next;

    assign count = counter_reg;

    // State register
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= STOP;
            counter_reg <= 0;
        end else begin
            state <= state_next;
            counter_reg <= counter_next;
        end
    end

    // Next state combinational logic
    always @(*) begin
        state_next   = state;
        counter_next = counter_reg;

        if (btn_Mode) begin
            case (state)
                STOP: begin
                    if (btn1_Tick) begin
                        state_next = START;
                    end else if (btn2_Tick) begin
                        state_next = CLEAR;
                    end
                end
                START: begin
                    if (btn1_Tick) begin
                        state_next = STOP;
                    end else if (tick) begin
                        if (counter_reg == 9999) begin
                            counter_next = 0;
                        end else begin
                            counter_next = counter_reg + 1;
                        end
                    end else if (btn2_Tick) begin
                        state_next = CLEAR;
                    end
                end
                CLEAR: begin
                    state_next   = STOP;
                    counter_next = 0;  // 넣어야되나?
                end
            endcase
        end
    end

    // Output combinational logic
    always @(*) begin
        if (btn_Mode) begin
            case (state)
                STOP: begin
                    counter_next = counter_reg;
                end
                START: begin
                    if (tick) begin
                        if (counter_reg == 9999) begin
                            counter_next = 0;
                        end else begin
                            counter_next = counter_reg + 1;
                        end
                    end
                end
                CLEAR: begin
                    counter_next = 0;
                end

            endcase
        end
    end

    // always @(posedge tick) begin
    //     if (btn_Mode) begin
    //         case (state)
    //             STOP: begin
    //                 counter_next = counter_reg;
    //             end
    //             START: begin
    //                     if (counter_reg == 9999) begin
    //                         counter_next = 0;
    //                     end else begin
    //                         counter_next = counter_reg + 1;
    //                     end
    //             end
    //             CLEAR: begin
    //                 counter_next = 0;
    //             end

    //         endcase
    //     end
    // end

endmodule







