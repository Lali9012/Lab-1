// Testbench for car_detect FSM and car_counter
`timescale 1ns/1ps

module car_detect_tb();

    logic clk, reset, outer, inner;
    logic enter, exit;
    logic incr, decr;
    logic [4:0] count;

    parameter T = 20;

    // Instantiate both modules
    car_detect cd (.clk, .reset, .outer, .inner, .enter, .exit);
    car_counter cc (.clk, .reset, .incr(enter), .decr(exit), .count);

    // Clock
    initial begin
        clk = 0;
        forever #(T/2) clk = ~clk;
    end

    // Apply one clock cycle
    task tick(input int n = 1);
        repeat(n) @(posedge clk);
        #1; // small delay so outputs settle before we read them
    endtask

    // Full enter sequence: 00 → 10 → 11 → 01 → 00
    task car_enter();
        outer = 0; inner = 0; tick();
        outer = 1; inner = 0; tick();
        outer = 1; inner = 1; tick();
        outer = 0; inner = 1; tick();
        outer = 0; inner = 0; tick();
    endtask

    // Full exit sequence: 00 → 01 → 11 → 10 → 00
    task car_exit();
        outer = 0; inner = 0; tick();
        outer = 0; inner = 1; tick();
        outer = 1; inner = 1; tick();
        outer = 1; inner = 0; tick();
        outer = 0; inner = 0; tick();
    endtask

    initial begin
        // --- Reset ---
        reset = 1; outer = 0; inner = 0;
        tick(2);
        reset = 0;
        $display("After reset: count=%0d (expect 0)", count);

        // --- Normal enter ---
        car_enter();
        $display("1 car entered: count=%0d (expect 1)", count);

        // --- Normal enter again ---
        car_enter();
        $display("2 cars entered: count=%0d (expect 2)", count);

        // --- Normal exit ---
        car_exit();
        $display("1 car exited: count=%0d (expect 1)", count);

        // --- Exit to empty ---
        car_exit();
        $display("Lot empty: count=%0d (expect 0)", count);

        // --- Underflow protection ---
        car_exit();
        $display("Exit on empty: count=%0d (expect 0, no underflow)", count);

        // --- Fill to 18 ---
        repeat(18) car_enter();
        $display("Lot full: count=%0d (expect 18)", count);

        // --- Overflow protection ---
        car_enter();
        $display("Enter when full: count=%0d (expect 18, no overflow)", count);

        // --- Invalid sequence: 11 directly from IDLE ---
        outer = 1; inner = 1; tick(2);
        outer = 0; inner = 0; tick();
        $display("Invalid (11 from IDLE): count=%0d (expect 18, no change)", count);

        // --- Partial/retreat: outer blocks then clears ---
        outer = 1; inner = 0; tick();
        outer = 0; inner = 0; tick();
        $display("Retreat (10 then 00): count=%0d (expect 18, no change)", count);

        // --- Reset mid-count ---
        reset = 1; tick(2);
        reset = 0;
        $display("Reset: count=%0d (expect 0)", count);

        $display("All tests done.");
        $stop;
    end

endmodule // car_detect_tb
