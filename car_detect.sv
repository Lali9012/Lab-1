// car_detect: Moore FSM detecting enter/exit sequences
//
// Inputs:  clk, reset, outer, inner
// Outputs: enter, exit (each pulses high for one clock cycle)
//
// Sensor encoding: {outer, inner}
//   2'b00 = both clear
//   2'b10 = outer blocked
//   2'b11 = both blocked
//   2'b01 = inner blocked
//
// Enter sequence: 00 → 10 → 11 → 01 → 00  (enter pulses on last 00)
// Exit  sequence: 00 → 01 → 11 → 10 → 00  (exit  pulses on last 00)
module car_detect(
    input  logic clk, reset,
    input  logic outer, inner,
    output logic enter, exit
);
    typedef enum logic [3:0] {
        IDLE,
        ENTER_OUTER,
        ENTER_BOTH,
        ENTER_INNER,
        EXIT_INNER,
        EXIT_BOTH,
        EXIT_OUTER,
        INVALID
    } state_t;

    state_t ps, ns;

    // Next-state logic
    always_comb begin
        ns = IDLE;
        case (ps)
            IDLE: begin
                case ({outer, inner})
                    2'b10:   ns = ENTER_OUTER;
                    2'b01:   ns = EXIT_INNER;
                    2'b00:   ns = IDLE;
                    default: ns = INVALID;     // 11 from IDLE is invalid
                endcase
            end
            ENTER_OUTER: begin
                case ({outer, inner})
                    2'b11:   ns = ENTER_BOTH;
                    2'b10:   ns = ENTER_OUTER; // hold
                    2'b00:   ns = IDLE;         // retreated
                    default: ns = INVALID;
                endcase
            end
            ENTER_BOTH: begin
                case ({outer, inner})
                    2'b01:   ns = ENTER_INNER;
                    2'b11:   ns = ENTER_BOTH;  // hold
                    default: ns = INVALID;
                endcase
            end
            ENTER_INNER: begin
                case ({outer, inner})
                    2'b00:   ns = IDLE;         // done → enter will pulse
                    2'b01:   ns = ENTER_INNER;  // hold
                    default: ns = INVALID;
                endcase
            end
            EXIT_INNER: begin
                case ({outer, inner})
                    2'b11:   ns = EXIT_BOTH;
                    2'b01:   ns = EXIT_INNER;  // hold
                    2'b00:   ns = IDLE;         // retreated
                    default: ns = INVALID;
                endcase
            end
            EXIT_BOTH: begin
                case ({outer, inner})
                    2'b10:   ns = EXIT_OUTER;
                    2'b11:   ns = EXIT_BOTH;   // hold
                    default: ns = INVALID;
                endcase
            end
            EXIT_OUTER: begin
                case ({outer, inner})
                    2'b00:   ns = IDLE;         // done → exit will pulse
                    2'b10:   ns = EXIT_OUTER;  // hold
                    default: ns = INVALID;
                endcase
            end
            INVALID: begin
                // Wait for sensors to clear before returning to IDLE
                if ({outer, inner} == 2'b00) ns = IDLE;
                else                          ns = INVALID;
            end
            default: ns = IDLE;
        endcase
    end

    // State register
    always_ff @(posedge clk) begin
        if (reset) ps <= IDLE;
        else       ps <= ns;
    end

    // Output logic (Moore: based on present state + next state)
    // Pulse for exactly one cycle on the transition back to IDLE
    assign enter = (ps == ENTER_INNER) && (ns == IDLE);
    assign exit  = (ps == EXIT_OUTER)  && (ns == IDLE);

endmodule // car_detect
