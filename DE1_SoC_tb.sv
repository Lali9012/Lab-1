/* testbench for the DE1_SoC */
module DE1_SoC_tb();

  // define signals
  logic       CLOCK_50;
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  logic [9:0] LEDR;
  wire [35:0] V_GPIO;
  
  // define parameters
  parameter T = 20;
   logic outer, inner,reset;
	
  // instantiate module
    DE1_SoC dut (
    .CLOCK_50(CLOCK_50),
    .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
    .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
    .LEDR(LEDR),
    .V_GPIO(V_GPIO)
  );
  
  
  assign V_GPIO[23] = outer;
  assign V_GPIO[24] = inner;
  assign V_GPIO[28] = reset;
  // define simulated clock
  initial begin
    CLOCK_50 <= 0;
    forever  #(T/2)  CLOCK_50 <= ~CLOCK_50;
  end  // initial clock
  
  
  initial begin
  integer i;
  reset = 1;@(posedge CLOCK_50);
  reset = 0;@(posedge CLOCK_50);
  
  //testing enter
    for (i = 0; i < 19; i++) begin
      outer = 0; inner = 0; @(posedge CLOCK_50);
      outer = 1;            @(posedge CLOCK_50);
      inner = 1;            @(posedge CLOCK_50);
      outer = 0;            @(posedge CLOCK_50);
      inner = 0;            @(posedge CLOCK_50);
    end

    // leaving
    for (i = 0; i < 19; i++) begin
      outer = 0; inner = 0; @(posedge CLOCK_50);
      inner = 1;            @(posedge CLOCK_50);
      outer = 1;            @(posedge CLOCK_50);
      inner = 0;            @(posedge CLOCK_50);
      outer = 0;            @(posedge CLOCK_50);
    end

  $stop;
  end
  
  
endmodule  // DE1_SoC_tb
