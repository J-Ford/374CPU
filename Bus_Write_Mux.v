module Bus_Write_Mux(busMuxOut, Bus_enable, in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, 
		in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23);
	input[31:0] Bus_enable, in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, 
		in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23;
	output[31:0] busMuxOut;
	wire[4:0] Encoded_Signals;
	Encoder32_5 bus_encoder(Encoded_Signals, Bus_enable);
	mux24 select_input(busMuxOut, Encoded_Signals, in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, 
		in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23);
endmodule	

module Encoder32_5(out, in);
	input[31:0] in;
	output[4:0] out;
	reg[4:0] out;

	always @ (*)begin
		case (in)
			32'h00000001: out = 5'b00000;
			32'h00000002: out = 5'b00001; 
			32'h00000004: out = 5'b00010; 
			32'h00000008: out = 5'b00011;
			32'h00000010: out = 5'b00100; 
			32'h00000020: out = 5'b00101; 
			32'h00000040: out = 5'b00110; 
			32'h00000080: out = 5'b00111; 
			32'h00000100: out = 5'b01000; 
			32'h00000200: out = 5'b01001;
			32'h00000400: out = 5'b01010; 
			32'h00000800: out = 5'b01011; 
			32'h00001000: out = 5'b01100; 
			32'h00002000: out = 5'b01101; 
			32'h00004000: out = 5'b01110; 
			32'h00008000: out = 5'b01111; 
			32'h00010000: out = 5'b10000; 
			32'h00020000: out = 5'b10001; 
			32'h00040000: out = 5'b10010; 
			32'h00080000: out = 5'b10011; 
			32'h00100000: out = 5'b10100; 
			32'h00200000: out = 5'b10101; 
			32'h00400000: out = 5'b10110; 
			32'h00800000: out = 5'b10111; 
			32'h01000000: out = 5'b11000; 
			32'h02000000: out = 5'b11001;
			32'h04000000: out = 5'b11010;
			32'h08000000: out = 5'b11011;
			32'h10000000: out = 5'b11100;
			32'h20000000: out = 5'b11101;
			32'h40000000: out = 5'b11110;
			32'h80000000: out = 5'b11111;
			default: out = 5'b11111;
		endcase
	end
endmodule
	
module  mux24(out, select, in_0, in_1, in_2 ,in_3, in_4,in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16,
	in_17, in_18, in_19, in_20, in_21, in_22, in_23);
	input[31:0] in_0, in_1, in_2 ,in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16,
		in_17, in_18, in_19, in_20, in_21, in_22, in_23;
	input[5:0] select;
	output[31:0] out;
	reg[31:0] out;
	always @(*) begin
		case (select)
			5'b00000: out = in_0;
			5'b00001: out = in_1;
			5'b00010: out = in_2;
			5'b00011: out = in_3;
			5'b00100: out = in_4;
			5'b00101: out = in_5;
			5'b00110: out = in_6;
			5'b00111: out = in_7;
			5'b01000: out = in_8;
			5'b01001: out = in_9;
			5'b01010: out = in_10;
			5'b01011: out = in_11;
			5'b01100: out = in_12;
			5'b01101: out = in_13;
			5'b01110: out = in_14;
			5'b01111: out = in_15;
			5'b10000: out = in_16;
			5'b10001: out = in_17;
			5'b10010: out = in_18;
			5'b10011: out = in_19;
			5'b10100: out = in_20;
			5'b10101: out = in_21;
			5'b10110: out = in_22;
			5'b10111: out = in_23;		
			default: out = 32'h00000000;
		endcase
	end
endmodule