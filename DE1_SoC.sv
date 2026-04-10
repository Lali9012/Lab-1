/* Top-level module for LandsLand hardware connections to implement the parking lot system.*/

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO);
  input  logic       CLOCK_50;  // 50MHz clock
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;  // active low
  output logic [9:0] LEDR;
  inout  logic [35:0] V_GPIO;  // expansion header 0 (LabsLand board)
  
  // Turn off all 7-seg displays (active low: 1 = off, 0 = on)
  //assign HEX0 = 7'b1111111;
  //assign HEX1 = 7'b1111111;
  //assign HEX2 = 7'b1111111;
  //assign HEX3 = 7'b1111111;
	  //assign HEX4 = 7'b1111111;
  //assign HEX5 = 7'b1111111;
  
  
  //clock divider and set up system clk
  logic [31:0] clk;
  clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
  logic system_clk;
  //assign system_clk = clk[20];
  assign system_clk = CLOCK_50;
  
  //car_detection
  logic reset,outer, inner,enter, exit;
  car_detect detection(.clk(system_clk), .reset(reset),.outer(outer), .inner(inner)
							,.enter(enter), .exit(exit));
  
  //car_counting
  logic incr, decr;
  logic [4:0] count;
  assign incr = enter;
  assign decr = exit;
  car_counter counter (.clk(system_clk), .reset(reset),.incr(incr), 
							.decr(decr),.count(count));
							
	//display the count in HEX 0-6						
	display Hex_display(.HEX0(HEX0),.HEX1(HEX1),.HEX2(HEX2),.HEX3(HEX3),
								.HEX4(HEX4),.HEX5(HEX5),.counter(count));
								
	//connect things to vgipio
	assign outer=V_GPIO[23];
	assign inner=V_GPIO[24];
	assign reset=V_GPIO[28];
	assign V_GPIO[32]= enter ;
	assign V_GPIO[34]= exit;

  
  
  
endmodule  // DE1_SoC
