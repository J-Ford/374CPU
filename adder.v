module B_cell(x,y,carry_in,sum, propagate_out, generate_out);
	input x,y,carry_in;
	output sum, propagate_out, generate_out;
	reg sum, propagate_out, generate_out;

	always @(x | y) fork //WHEN X AND Y CHANGE
		generate_out <= x & y;
		propagate_out <= x ^ y;
	join
	
	always @(carry_in) begin // WHEN CARRY CHANGES
		sum <= propagate_out^carry_in;
	end
endmodule

module CLA4(x, y, carry_in, sum, p_out, g_out);
	input[3:0] x , y;
	input carry_in;
	output[3:0] sum;
	output p_out, g_out;
	wire[3:0] carry, p_in, g_in;
	reg p_out, g_out;
	
	B_cell b0(x[0], y[0], carry[0], sum[0], p_in[0], g_in[0]);
	B_cell b1(x[1], y[1], carry[1], sum[1], p_in[1], g_in[1]);
	B_cell b2(x[2], y[2], carry[2], sum[2], p_in[2], g_in[2]);
	B_cell b3(x[3], y[3], carry[3], sum[3], p_in[3], g_in[3]);
	
	always @(*) fork
		carry[0] <= carry_in;
		carry[1] <= g_in[0] | (p_in[0]&carry_in);
		carry[2] <= g_in[1] | (p_in[1]&g_in[0]) | (p_in[1]&p_in[0]&carry_in);
		carry[3] <= g_in[2] | (p_in[2]&g_in[1]) | (p_in[2]&p_in[1]&g_in[0]) | (p_in[2]&p_in[1]&p_in[0]&carry_in);
			
		p_out <= p_in[0]&p_in[1]&p_in[2]&p_in[3];
		g_out <=  g_in[3] | (p_in[3]&g_in[2]) | (p_in[3]&p_in[2]&g_in[1]) | (p_in[3]&p_in[2]&p_in[1]&g_in[0]);
	join	
endmodule 

module adder(x, y, carry_in, sum, carry_out);
	input[15:0] x , y;
	input carry_in;
	output[15:0] sum;
	output carry_out; //p_out, g_out;
	wire[3:0] carry, p_in, g_in;
	//reg p_out, g_out

	CLA4 cla4_0(x[3:0], y[3:0], carry[0], sum[3:0], p_in[0], g_in[0]);
	CLA4 cla4_1(x[7:4], y[7:4], carry[1], sum[7:4], p_in[1], g_in[1]);
	CLA4 cla4_2(x[11:8], y[11:8], carry[2], sum[11:8], p_in[2], g_in[2]);
	CLA4 cla4_3(x[15:12], y[15:12], carry[3], sum[15:12], p_in[3], g_in[3]);

	always @(*) fork
		carry[0] <= carry_in;
		carry[1] <= g_in[0] | (p_in[0]&carry_in);
		carry[2] <= g_in[1] | (p_in[1]&g_in[0]) | (p_in[1]&p_in[0]&carry_in);
		carry[3] <= g_in[2] | (p_in[2]&g_in[1]) | (p_in[2]&p_in[1]&g_in[0]) | (p_in[2]&p_in[1]&p_in[0]&carry_in);
		carry_out <= g_in[3] | (p_in[3]&g_in[2]) | (p_in[3]&p_in[2]&g_in[1]) | (p_in[3]&p_in[2]&p_in[1]&g_in[0]) | (p_in[3]&p_in[2]&p_in[1]&p_in[0]&carry_in);
			
			//p_out <= p_in[0]&p_in[1]&p_in[2]&p_in[3];
			//g_out <=  g_in[3] | (p_in[3]&g_in[2]) | (p_in[3]p_in[2]g_in[1]) | (p_in[3]&p_in[2]&p_in[1]&g_in[0]);
	join
endmodule


//module TestModule;
//
//	// Inputs
//	reg [3:0] a;
//	reg [3:0] b;
//	reg c_in;
//
//	// Outputs
//	wire [3:0] sum;
//	wire c_out;
//
//	// Instantiate the Unit Under Test (UUT)
//	adder uut (
//		.a(a), 
//		.b(b), 
//		.cin(c_in), 
//		.sum(sum), 
//		.cout(c_out)
//	);
//
//	initial begin
//		// Initialize Inputs
//		a = 0;
//		b = 0;
//		c_in = 0;
//
//		// Wait 100 ns for global reset to finish
//		#100;
//        
//		a = 5;
//		b = 6;
//		c_in = 1;
//
//		// Wait 100 ns for global reset to finish
//		#100;
//	end
//      
//endmodule