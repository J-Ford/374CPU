module datapathP1(ALU_signals, Mdata_in, Mdata_out, Maddress_out, reset, clk, Bus, 
	Mem_read, Mem_write,
	R0_write_enable, R1_write_enable, R2_write_enable, R3_write_enable, R4_write_enable, R5_write_enable,
	R6_write_enable, R7_write_enable, R8_write_enable, R9_write_enable, R10_write_enable, R11_write_enable,
	R12_write_enable, R13_write_enable, R14_write_enable, R15_write_enable, Z_write_enable,
	HI_write_enable, LO_write_enable, Zhi_write_enable, Zlo_write_enable, PC_write_enable, 
	MDR_write_enable, MAR_write_enable, InPort_write_enable, OutPort_write_enable, Y_write_enable, IR_write_enable,
	Bus_select_R0, Bus_select_R1, Bus_select_R2, Bus_select_R3, Bus_select_R4, Bus_select_R5, Bus_select_R6, Bus_select_R7, Bus_select_R8, Bus_select_R9, 
	Bus_select_R10, Bus_select_R11, Bus_select_R12, Bus_select_R13, Bus_select_R14, Bus_select_R15, Bus_select_HI, Bus_select_LO, Bus_select_Zhi, Bus_select_Zlo, Bus_select_PC, Bus_select_MDR, 
	Bus_select_INPort, Bus_select_C); // signals will be generated internally in the future
	input[31:0] Mdata_in;
	input[3:0] ALU_signals;
	input reset;
	output[31:0] Maddress_out, Mdata_out;
	input clk;
	input Mem_read, Mem_write,
	R0_write_enable, R1_write_enable, R2_write_enable, R3_write_enable, R4_write_enable, R5_write_enable,
	R6_write_enable, R7_write_enable, R8_write_enable, R9_write_enable, R10_write_enable, R11_write_enable,
	R12_write_enable, R13_write_enable, R14_write_enable, R15_write_enable, Z_write_enable,
	HI_write_enable, LO_write_enable, Zhi_write_enable, Zlo_write_enable, PC_write_enable, 
	MDR_write_enable, MAR_write_enable, InPort_write_enable, OutPort_write_enable, Y_write_enable, IR_write_enable,
	Bus_select_R0, Bus_select_R1, Bus_select_R2, Bus_select_R3, Bus_select_R4, Bus_select_R5, Bus_select_R6, Bus_select_R7, Bus_select_R8, Bus_select_R9, 
	Bus_select_R10, Bus_select_R11, Bus_select_R12, Bus_select_R13, Bus_select_R14, Bus_select_R15, Bus_select_HI, Bus_select_LO, Bus_select_Zhi, Bus_select_Zlo, Bus_select_PC, Bus_select_MDR, 
	Bus_select_INPort, Bus_select_C;
	output [31:0] Bus;
	

	
		
	//Register output wires
	wire[31:0] R0_output, R1_output, R2_output, R3_output, R4_output, R5_output, R6_output, R7_output, R8_output, R9_output, R10_output, 
		R11_output, R12_output, R13_output, R14_output, R15_output, HI_output, LO_output, Zhi_output, Zlo_output, PC_output, MDR_output, InPort_output, C_sign_extended; 
	
	//other wires
	wire clk, Mem_read, Mem_write;
	wire[31:0] Bus, MDMux_out, MDR_data, ALU_Y_input, Bus_enable, BusMuxIn[31:0];
	wire[63:0] ALU_output;
	wire[31:0] CLU_in; //goes to ALU
	wire[31:0] IOdata_out, IOdata_in;

	//initialise clock
	//clock synchronous_clock(clk);
	
	//initialise ALU
	ALU Alu(Bus, ALU_Y_input, ALU_output, ALU_signals);
	
	//initialise bus multiplexer
	Bus_Write_Mux Bus_Mux(Bus, Bus_enable, R0_output, R1_output, R2_output, R3_output, R4_output, R5_output, R6_output, R7_output, R8_output, R9_output, R10_output, 
		R11_output, R12_output, R13_output, R14_output, R15_output, HI_output, LO_output, Zhi_output, Zlo_output, PC_output, MDR_output, InPort_output, C_sign_extended);
	
	
	//initialise registers
	reg32 R0(R0_output, reset, clk, R0_write_enable, Bus);
	reg32 R1(R1_output, reset, clk, R1_write_enable, Bus);
	reg32 R2(R2_output, reset, clk, R2_write_enable, Bus);
	reg32 R3(R3_output, reset, clk, R3_write_enable, Bus);
	reg32 R4(R4_output, reset, clk, R4_write_enable, Bus);
	reg32 R5(R5_output, reset, clk, R5_write_enable, Bus);
	reg32 R6(R6_output, reset, clk, R6_write_enable, Bus);
	reg32 R7(R7_output, reset, clk, R7_write_enable, Bus);
	reg32 R8(R8_output, reset, clk, R8_write_enable, Bus);
	reg32 R9(R9_output, reset, clk, R9_write_enable, Bus);
	reg32 R10(R10_output, reset, clk, R10_write_enable, Bus);
	reg32 R11(R11_output, reset, clk, R11_write_enable, Bus);
	reg32 R12(R12_output, reset, clk, R12_write_enable, Bus);
	reg32 R13(R13_output, reset, clk, R13_write_enable, Bus);
	reg32 R14(R14_output, reset, clk, R14_write_enable, Bus);
	reg32 R15(R15_output, reset, clk, R15_write_enable, Bus);
	
	reg32 HI(HI_output, reset, clk, HI_write_enable, Bus);
	reg32 LO(LO_output, reset, clk, LO_write_enable, Bus);
	reg32 PC(PC_output, reset, clk, PC_write_enable, Bus);
	
	reg32_MDR MDR(Mdata_out, MDR_output, reset, clk, MDR_write_enable, Mem_write, Mem_read, Bus, Mdata_in); //change Mem_write to Mem_write_enable
	
	reg32 MAR(Maddress_out, reset, clk, MAR_write_enable, Bus);
	reg32 InPort(InPort_output, reset, clk, InPort_write_enable, IOdata_in); //*note always accept new data from IO 
	reg32 OutPort(IOdata_out, reset, clk, OutPort_write_enable, Bus);//*
	
	reg32 IR(CLU_in, reset, clk, IR_write_enable, Bus);
	
	reg32 Y(ALU_Y_input, reset, clk, Y_write_enable, Bus); //write to Y
	reg64 Z(Zhi_output, Zlo_output, reset, clk, Z_write_enable, ALU_output);// writes to low and hi
	
	assign Bus_enable[23:0] = {Bus_select_R0, Bus_select_R1, Bus_select_R2, Bus_select_R3, Bus_select_R4, Bus_select_R5, Bus_select_R6, Bus_select_R7, Bus_select_R8, Bus_select_R9, 
	Bus_select_R10, Bus_select_R11, Bus_select_R12, Bus_select_R13, Bus_select_R14, Bus_select_R15, Bus_select_HI, Bus_select_LO, Bus_select_Zhi, Bus_select_Zlo, Bus_select_PC, Bus_select_MDR, 
	Bus_select_INPort, Bus_select_C};
	
	
endmodule


module ALU(A, B, C, opperation_signal);
	input[31:0] A, B;
	input[3:0] opperation_signal;
	output[63:0] C;
	reg[63:0] C;
	integer rotateCount;
	
	always @ (*) begin
		case (opperation_signal)
		//ADD
		0: C[31:0] = A + B; 
		//SUB
		1: C[31:0] = A - B;
		//MUL
		2: C = A * B;
		//DIV
		3: C = A / B;
		//SHR
		4: C[31:0] = A >> B;
		//SHL
		5: C[31:0] = A << B;
		//ROR
		6: begin
		rotateCount = 0;
			C[31:0] = A;
			while((B > rotateCount) && (rotateCount < 32)) begin
				C = {C[0] , C[31:1]};
				rotateCount = rotateCount + 1;
				end
			end
		//ROL
		7:begin
		rotateCount = 0;
			C[31:0] = A;
			while((B > rotateCount) && (rotateCount < 32)) begin
				C = {C[30:0] , C[31]};
				rotateCount = rotateCount + 1;
				end
			end
		//AND
		8: C[31:0] = A & B;
		//OR
		9: C[31:0] = A | B;
		//NEG
		10: C[31:0] = ~A + 1;
		//NOT
		11: C[31:0] = ~A;
		//Inc_PC
		12: C[31:0] = A + 1;
		
		default: C = 0;
		endcase
	end
endmodule
	
	
	
	
	end
endmodule





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

	always @ (*) begin
		if (in == 32'h00000002) begin
			out = 5'b00001; 
		end
		else if (in == 32'h00000004) begin
			out = 5'b00010; 
		end
		else if (in == 32'h00000008) begin
			out = 5'b00011; 
		end
		else if (in == 32'h00000010) begin
			out = 5'b00100; 
		end
		else if (in == 32'h00000020) begin
			out = 5'b00101; 
		end
		else if (in == 32'h00000040) begin
			out = 5'b00110; 
		end
		else if (in == 32'h00000080) begin
			out = 5'b00111; 
		end
		else if (in == 32'h00000100) begin
			out = 5'b01000; 
		end
		else if (in == 32'h00000200) begin
			out = 5'b01001; 
		end
		else if (in == 32'h00000400) begin
			out = 5'b01010; 
		end
		else if (in == 32'h00000800) begin
			out = 5'b01011; 
		end
		else if (in == 32'h00001000) begin
			out = 5'b01100; 
		end
		else if (in == 32'h00002000) begin
			out = 5'b01101; 
		end
		else if (in == 32'h00004000) begin
			out = 5'b01110; 
		end
		else if (in == 32'h00008000) begin
			out = 5'b01111; 
		end
		else if (in == 32'h00010000) begin
			out = 5'b10000; 
		end
		else if (in == 32'h00020000) begin
			out = 5'b10001; 
		end
		else if (in == 32'h00040000) begin
			out = 5'b10010; 
		end
		else if (in == 32'h00080000) begin
			out = 5'b10011; 
		end
		else if (in == 32'h00100000) begin
			out = 5'b10100; 
		end
		else if (in == 32'h00200000) begin
			out = 5'b10101; 
		end
		else if (in == 32'h00400000) begin
			out = 5'b10110; 
		end
		else if (in == 32'h00800000) begin
			out = 5'b10111; 
		end
		else if (in == 32'h01000000) begin
			out = 5'b11000; 
		end
	end
endmodule
	
module  mux24(out, select, in_0, in_1, in_2 ,in_3, in_4,in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16,
	in_17, in_18, in_19, in_20, in_21, in_22, in_23);
	input[31:0] in_0, in_1, in_2 ,in_3, in_4,in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16,
		in_17, in_18, in_19, in_20, in_21, in_22, in_23;
	input[4:0] select;
	output[31:0] out;
	reg[31:0] out;
	always @ (*) begin
		if (select == 5'b00000) begin
			out = in_0; 
		end
		else if (select == 5'b00001) begin
			out = in_1; 
		end
		else if (select == 5'b00010) begin
			out = in_2; 
		end
		else if (select == 5'b00011) begin
			out = in_3; 
		end
		else if (select == 5'b00100) begin
			out = in_4; 
		end
		else if (select == 5'b00101) begin
			out = in_5; 
		end
		else if (select == 5'b00110) begin
			out = in_6; 
		end
		else if (select == 5'b00111) begin
			out = in_7; 
		end
		else if (select == 5'b01000) begin
			out = in_8; 
		end
		else if (select == 5'b01001) begin
			out = in_9; 
		end
		else if (select == 5'b01010) begin
			out = in_10; 
		end
		else if (select == 5'b01011) begin
			out = in_11; 
		end
		else if (select == 5'b01100) begin
			out = in_12; 
		end
		else if (select == 5'b01101) begin
			out = in_13; 
		end
		else if (select == 5'b01110) begin
			out = in_14;
		end
		else if (select == 5'b01111) begin
			out = in_15;
		end
		else if (select == 5'b10000) begin
			out = in_16; 
		end
		else if (select == 5'b10001) begin
			out = in_17; 
		end
		else if (select == 5'b10010) begin
			out = in_17; 
		end
		else if (select == 5'b10011) begin
			out = in_19; 
		end
		else if (select == 5'b10100) begin
			out = in_20; 
		end
		else if (select == 5'b10101) begin
			out = in_21; 
		end
		else if (select == 5'b10110) begin
			out = in_22; 
		end
		else if (select == 5'b10111) begin
			out = in_23; 
		end
		else begin
			out = 32'h00000000;
		end
	end
endmodule

module reg32_MDR(Memory_output, Bus_output,  clr, clk, MDR_write_enable, Memory_write_enable, Memory_read_enable, Bus_input, Memory_input);
	input clr,clk, Memory_write_enable, Memory_read_enable, MDR_write_enable;
	input [31:0] Bus_input, Memory_input;
	output [31:0]Memory_output, Bus_output;
	reg[31:0] Rout;
	wire[31:0] register;

	MDMux_in input_select(Bus_input, Memory_input, Memory_read_enable, register);
	MDMux_out output_select(Rout, Memory_write_enable, Bus_output, Memory_output);

	always @ (posedge clk)begin
		if(clr) begin
			Rout = 32'h00000000;
			end
		if(MDR_write_enable) begin
			Rout = register;
			end
	end
endmodule

module MDMux_in(Bus_data, Mdata_in, Mem_read_enable, MDMux_out); //BusMuxOut
	input Mem_read_enable;
	input[31:0] Bus_data, Mdata_in;
	output[31:0] MDMux_out;
	assign MDMux_out = (Mem_read_enable & Mdata_in) | (!Mem_read_enable & Bus_data);
endmodule

module MDMux_out(MDR_data, Mem_write_enable, BusData_out, Mdata_out); 
	input Mem_write_enable;
	input[31:0] MDR_data;
	output[31:0] BusData_out, Mdata_out;
	assign Mdata_out = MDR_data & Mem_write_enable;
	assign BusData_out = MDR_data & (!Mem_write_enable);
endmodule

module reg32(Rout, clr, clk, write_enable, BusMuxOut);
	input clr,clk, write_enable;
	input [31:0] BusMuxOut;
	output [31:0]Rout;
	reg[31:0] Rout;

	initial begin
		Rout <= 0;
	end
	
	always @ (posedge clk)begin
		if(clr == 1) begin
			Rout <= 0;
			end
		else if(write_enable == 1) begin
			Rout <= BusMuxOut;
		end
	end
endmodule
	
module reg64(Rout_hi, Rout_low, clr, clk, write_enable, input_value);
	input clr,clk, write_enable;
	input [63:0] input_value;
	output [31:0]Rout_hi, Rout_low;
	reg[31:0] Rout_hi, Rout_low;

	always @ (posedge clk)begin
		if(write_enable == 1) begin
			Rout_hi = input_value[63:32];
			Rout_low = input_value[31:0];
			end
		else if(clr) begin
			Rout_hi = 0;
			Rout_low = 0;
			end
	end
	
endmodule
