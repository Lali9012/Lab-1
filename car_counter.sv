// car_counter: synchronous up/down counter, capped 0–18
//
// Inputs:  clk, reset, incr, decr
// Output:  count [4:0]  (holds values 0 to 18)

module car_counter (
    input  logic       clk, reset,
    input  logic       incr, decr,
    output logic [4:0] count
);
    localparam logic [4:0] MAX = 5'd18;

    always_ff @(posedge clk) begin
        if (reset)
            count <= 5'd0;
        else if (incr && !decr && count < MAX)
            count <= count + 5'd1;
        else if (decr && !incr && count > 5'd0)
            count <= count - 5'd1;
        // simultaneous incr & decr: no change
    end

endmodule // car_counter
