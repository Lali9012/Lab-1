//this is the display module form HEX0 - HEX6 
// output: it output to  6, 7 bit with HEX display module port as input 
//	input: and take 1,  5bit counter as indcate how many car in the lot
module display (
	output logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,
	input logic [4:0]counter
	);
	
	//tranfer from binary to decimal
	 
	logic [3:0]digit_1,digit_2;
	assign digit_1 = counter%10;
	assign digit_2 = counter /10;
	
	//seting upt HEX0
	always_comb 
		case(digit_1)
			4'd0:HEX0 = 7'b1000000;
			4'd1 : HEX0=7'b1111001;
			4'd2 : HEX0=7'b0100100;
			4'd3:HEX0=7'b0110000;
			4'd4 : HEX0=7'b0011001;
			4'd5 :HEX0=7'b0010010;
			4'd6 : HEX0=7'b0000010;
			4'd7 : HEX0=7'b1111000;
			4'd8 :HEX0= 7'b0000000;
			4'd9 : HEX0=7'b0010000;
			default: HEX0=7'b1111111;
		endcase 
	
	//seting up HEX1
	always_comb begin
		if(digit_2)
			HEX1=7'b1111001;
		else if(counter == 5'b00000)
			HEX1 = 7'b0101111;
		else 
			HEX1=7'b1111111;
	end
	
	//seting up HEX2
	always_comb begin
		if(counter == 5'd18)
			HEX2=7'b1000111;
		else if(counter == 5'd00)
			HEX2 = 7'b0001000;
		else 
			HEX2=7'b1111111;
	end
		
	//seting up HEX3
	always_comb begin
		if(counter == 5'd18)
			HEX3=7'b1000111;
		else if(counter == 5'd00)
			HEX3 = 7'b0000110;
		else 
			HEX3=7'b1111111;
	end
	
	//seting up HEX4
	always_comb begin
		if(counter == 5'd18)
			HEX4=7'b1000001;
		else if(counter == 5'd00)
			HEX4 = 7'b1000111;
		else 
			HEX4=7'b1111111;
	end
	
	//seting up HEX5
	always_comb begin
		if(counter == 5'd18)
			HEX5=7'b0001110;
		else if(counter == 5'd00)
			HEX5 = 7'b1000110;
		else 
			HEX5=7'b1111111;
	end

		
		
	 
	 


endmodule  
