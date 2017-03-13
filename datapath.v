module datapath(read_signals, write_signals, Mdata_in, IOdata_in, ALU_signals, reset, IOdata_out, Maddress_out, Mdata_out, clk); // signals will be generated internally in the future
	input[26:0] read_signals, write_signals; 
	input[31:0] Mdata_in, IOdata_in;
	input[3:0] ALU_signals;
	input reset;
	output[31:0] IOdata_out, Maddress_out, Mdata_out;
	output clk;
	
	//Register Output Selection Wires
	wire R0_en, R1_en, R2_en, R3_en, R4_en, R5_en, R6_en, R7_en,
		R8_en, R9_en, R10_en, R11_en, R12_en, R13_en, R14_en, R15_en,
		HI_en, LO_en, Zhi_en, Zlo_en, PC_en, MDR_en, InPort_en, C_en;
	
	//Register write wires
	wire R0_write, R1_write, R2_write, R3_write, R4_write, R5_write, R6_write, R7_write,
		R8_write, R9_write, R10_write, R11_write, R12_write, R13_write, R14_write, R15_write,
		HI_write, LO_write, PC_write, MDR_write, MAR_write, InPort_write, OutPort_write, Y_write, IR_write;
	
	//Register output wires
	wire[31:0] BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3,
		BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, BusMuxIn_R7, BusMuxIn_R8,
		BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, BusMuxIn_R12,
		BusMuxIn_R13, BusMuxIn_R14, BusMuxIn_R15,
		BusMuxIn_HI, BusMuxIn_LO, BusMuxIn_Zhi, BusMuxIn_Zlo,
		BusMuxIn_PC, BusMuxIn_MDR, BusMuxIn_InPort, C_sign_extended; //what is C_sign extended
	
	//other wires
	wire clk, Mem_read, Mem_write;
	wire[31:0] Bus, MDMux_out, MDR_data, ALU_Y_input;
	wire[63:0] ALU_output; 
	wire[31:0] CLU_in; //goes to ALU
		
	assign Mem_read = read_signals[26];
	assign Mem_write = write_signals[26];

	//initialise clock
	clock synchronous_clock(clk);
	
	//initialise ALU
	ALU Alu(Bus, ALU_Y_input, ALU_output, ALU_signals);
	
	//initialise multiplexers
	MDMux_in MDR_input_select(Bus, Mdata_in, Mem_read, MDMux_out);
	MDMux_out MDR_output_select(MDR_data, Mem_write, BusMuxIn_MDR, Mdata_out); 
	Mux32to1 Bus_drive_mux(Bus, BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3,
		BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, BusMuxIn_R7, BusMuxIn_R8,
		BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, BusMuxIn_R12,
		BusMuxIn_R13, BusMuxIn_R14, BusMuxIn_R15,
		BusMuxIn_HI, BusMuxIn_LO, BusMuxIn_Zhi, BusMuxIn_Zlo,
		BusMuxIn_PC, BusMuxIn_MDR, BusMuxIn_InPort, C_sign_extended,
		R0_en, R1_en, R2_en, R3_en, R4_en, R5_en, R6_en, R7_en,
		R8_en, R9_en, R10_en, R11_en, R12_en, R13_en, R14_en, R15_en,
		HI_en, LO_en, Zhi_en, Zlo_en, PC_en, MDR_en, InPort_en, C_en);
	
	//initialise registers
	reg32 R0(BusMuxIn_R0, reset, clk, R0_write, Bus);
	reg32 R1(BusMuxIn_R1, reset, clk, R1_write, Bus);
	reg32 R2(BusMuxIn_R2, reset, clk, R2_write, Bus);
	reg32 R3(BusMuxIn_R3, reset, clk, R3_write, Bus);
	reg32 R4(BusMuxIn_R4, reset, clk, R4_write, Bus);
	reg32 R5(BusMuxIn_R5, reset, clk, R5_write, Bus);
	reg32 R6(BusMuxIn_R6, reset, clk, R6_write, Bus);
	reg32 R7(BusMuxIn_R7, reset, clk, R7_write, Bus);
	reg32 R8(BusMuxIn_R8, reset, clk, R8_write, Bus);
	reg32 R9(BusMuxIn_R9, reset, clk, R9_write, Bus);
	reg32 R10(BusMuxIn_R10, reset, clk, R10_write, Bus);
	reg32 R11(BusMuxIn_R11, reset, clk, R11_write, Bus);
	reg32 R12(BusMuxIn_R12, reset, clk, R12_write, Bus);
	reg32 R13(BusMuxIn_R13, reset, clk, R13_write, Bus);
	reg32 R14(BusMuxIn_R14, reset, clk, R14_write, Bus);
	reg32 R15(BusMuxIn_R15, reset, clk, R15_write, Bus);
	
	reg32 HI(BusMuxIn_HI, reset, clk, HI_write, Bus);
	reg32 LO(BusMuxIn_LO, reset, clk, LO_write, Bus);
	reg32 PC(BusMuxIn_PC, reset, clk, PC_write, Bus);
	reg32 MDR(MDR_data, reset, clk, MDR_write, MDMux_out); //* both sides connected to multiplexers
	reg32 MAR(Maddress_out, reset, clk, MAR_write, Bus);
	reg32 InPort(BusMuxIn_InPort, reset, clk, InPort_write, IOdata_in); //*note always accept new data from IO 
	reg32 OutPort(IOdata_out, reset, clk, OutPort_write, Bus);//*
	
	reg32 IR(CLU_in, reset, clk, IR_write, Bus);
	
	reg32 Y(ALU_Y_input, reset, clk, Y_write, Bus); //write to Y
	reg64 Z(BusMuxIn_Zhi, BusMuxIn_Zlo, reset, clk, ALU_output);// writes to low and hi
	
	//assign inputs to Register Selection Wires (will be done by CLU in future)
	assign R0_en = read_signals[0];
	assign R1_en = read_signals[1];
	assign R2_en = read_signals[2];
	assign R3_en = read_signals[3];
	assign R4_en = read_signals[4];
	assign R5_en = read_signals[5];
	assign R6_en = read_signals[6];
	assign R7_en = read_signals[7];
	assign R8_en = read_signals[8];
	assign R9_en = read_signals[9];
	assign R10_en = read_signals[10];
	assign R11_en = read_signals[11];
	assign R12_en = read_signals[12];
	assign R13_en = read_signals[13];
	assign R14_en = read_signals[14];
	assign R15_en = read_signals[15];
	assign HI_en = read_signals[16];
	assign LO_en = read_signals[17];
	assign Zhi_en = read_signals[18];
	assign Zlo_en = read_signals[19];
	assign PC_en = read_signals[20];
	assign MDR_en = read_signals[21];
	assign InPort_en = read_signals[22];
	assign C_en = read_signals[23];
	
	assign R0_write = write_signals[0];
	assign R1_write = write_signals[1];
	assign R2_write = write_signals[2];
	assign R3_write = write_signals[3];
	assign R4_write = write_signals[4];
	assign R5_write = write_signals[5];
	assign R6_write = write_signals[6];
	assign R7_write = write_signals[7];
	assign R8_write = write_signals[8];
	assign R9_write = write_signals[9];
	assign R10_write = write_signals[10];
	assign R11_write = write_signals[11];
	assign R12_write = write_signals[12];
	assign R13_write = write_signals[13];
	assign R14_write = write_signals[14];
	assign R15_write = write_signals[15];
	assign HI_write = write_signals[16];
	assign LO_write = write_signals[17];
	assign Zhi_write = write_signals[18];
	assign Zlo_write = write_signals[19];
	assign PC_write = write_signals[20];
	assign MDR_write = write_signals[21];
	assign OutPort_write = write_signals[22];
	assign InPort_write = 1; //note: always trying to read, this will be updated
	assign MAR_write = write_signals[23];
	assign Y_write = write_signals[24];
	assign IR_write = write_signals[25];
endmodule


module ALU(A, B, C, opperation_signal);
	input[31:0] A, B;
	input[3:0] opperation_signal;
	output[63:0] C;
	reg[63:0] C;
	//reg[31:0]ROR_out, ROL_out;
	//reg ROR_en, ROL_en;
	//ROR rotate_right(A, B, ROR_out);
	//ROL rotate_left(A, B, ROL_out);
	
	
	always @(*) begin
		if (opperation_signal == 4'b0000) begin //ADD
			C[31:0] = A + B;
			end
		if (opperation_signal == 4'b0001) begin //SUB
			C[31:0] = A - B;
			end
		if (opperation_signal == 4'b0010) begin //MUL
			C = A * B;
			end
		if (opperation_signal == 4'b0011) begin //DIV
			C = A / B;
			end
		if (opperation_signal == 4'b0100) begin //SHR
			C[31:0] = A >> B;
			end
		if (opperation_signal == 4'b0101) begin //SHL
			C[31:0] = A << B;
			end
		if (opperation_signal == 4'b0110) begin //ROR
			//C[31:0] = {A[B -: 0], A[(B+1) +: 31]}; //
			C[31:0] = A << B;
			end
		if (opperation_signal == 4'b0111) begin //ROL
			//C[31:0] = {A[(31-B-1) -: 0], A[(31-B) +: 31]};
			C[31:0] = A << B;
			end
		if (opperation_signal == 4'b1000) begin //AND
			C[31:0] = A & B;
			end
		if (opperation_signal == 4'b1001) begin //OR
			C[31:0] = A | B;
			end
		if (opperation_signal == 4'b1010) begin //NEG
			C[31:0] = !A + 1;
			end
		if (opperation_signal == 4'b1011) begin //NOT
			C[31:0] = !A;
			end	
		if (opperation_signal == 4'b1100) begin //Inc_PC
			C[31:0] = A + 1;
			end
	//evaluate opperation signal to select an opperation
	
	
	end
endmodule

//http://stackoverflow.com/questions/18067571/indexing-vectors-and-arrays-with

/*
module ROR(in, shift, res, enable);
	input enable;
	input[31:0] in, shift;
	output[31:0] res;
	reg[31:0] res, tmp;
	// A[5:0], A[31:6]
	always @(enable) begin;
		tmp = shift+1;
		res = {in[shift -: 0] , in[tmp +: 31]};
	end
endmodule

module ROL(in, shift, res, enable);
	input enable;
	input[31:0] in, shift;
	output[31:0] res;
	reg[31:0] res, tmp, tmp2;
	// A[26:0], a[31:27]	
	always @(enable) begin;
		tmp = 31 - shift;
		tmp2 = tmp - 1;
		res = {in[tmp2 -: 0] , in[tmp +: 31]};   C = {A[(31-B-1) -: 0], A[(31-B) +: 31]}
	end
endmodule
*/


module Mux32to1(busMuxOut, BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3,
	BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, BusMuxIn_R7, BusMuxIn_R8,
	BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, BusMuxIn_R12,
	BusMuxIn_R13, BusMuxIn_R14, BusMuxIn_R15,
	BusMuxIn_HI, BusMuxIn_LO, BusMuxIn_Zhi, BusMuxIn_Zlo,
	BusMuxIn_PC, BusMuxIn_MDR, BusMuxIn_InPort, C_sign_extended,R0out,
	R1out, R2out, R3out, R4out, R5out, R6out, R7out,
	R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
	HIout, LOout, Zhiout, Zloout, PCout, MDRout, InPortout, Cout);
	
	input [31:0] BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3,
		BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, BusMuxIn_R7, BusMuxIn_R8,
		BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, BusMuxIn_R12,
		BusMuxIn_R13, BusMuxIn_R14, BusMuxIn_R15,
		BusMuxIn_HI, BusMuxIn_LO, BusMuxIn_Zhi, BusMuxIn_Zlo,
		BusMuxIn_PC, BusMuxIn_MDR, BusMuxIn_InPort, C_sign_extended;
	input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, 
		R12out, R13out, R14out, R15out, HIout, LOout, Zhiout, Zloout, PCout, MDRout, InPortout, Cout; 
	output[31:0] busMuxOut;
	reg[31:0] busMuxOut;

	wire[31:0] registers;
	assign registers[0] = BusMuxIn_R0;
	assign registers[1] = BusMuxIn_R1;
	assign registers[2] = BusMuxIn_R2;
	assign registers[3] = BusMuxIn_R3;
	assign registers[4] = BusMuxIn_R4;
	assign registers[5] = BusMuxIn_R5;
	assign registers[6] = BusMuxIn_R6;
	assign registers[7] = BusMuxIn_R7;
	assign registers[8] = BusMuxIn_R8;
	assign registers[9] = BusMuxIn_R9;
	assign registers[10] = BusMuxIn_R10;
	assign registers[11] = BusMuxIn_R11;
	assign registers[12] = BusMuxIn_R12;
	assign registers[13] = BusMuxIn_R13;
	assign registers[14] = BusMuxIn_R14;
	assign registers[15] = BusMuxIn_R15;
	assign registers[16] = BusMuxIn_HI;
	assign registers[17] = BusMuxIn_LO;
	assign registers[18] = BusMuxIn_Zhi;
	assign registers[19] = BusMuxIn_Zlo;
	assign registers[20] = BusMuxIn_PC;
	assign registers[21] = BusMuxIn_MDR;
	assign registers[22] = BusMuxIn_InPort;
	assign registers[23] = C_sign_extended;
	
	wire[31:0] signals;
	assign signals[0] = R0out;
	assign signals[1] = R1out;
	assign signals[2] = R2out;
	assign signals[3] = R3out;
	assign signals[4] = R4out;
	assign signals[5] = R5out;
	assign signals[6] = R6out;
	assign signals[7] = R7out;
	assign signals[8] = R8out;
	assign signals[9] = R9out;
	assign signals[10] = R10out;
	assign signals[11] = R11out;
	assign signals[12] = R12out;
	assign signals[13] = R13out;
	assign signals[14] = R14out;
	assign signals[15] = R15out;
	assign signals[16] = HIout;
	assign signals[17] = LOout;
	assign signals[18] = Zhiout;
	assign signals[19] = Zloout;
	assign signals[20] = PCout;
	assign signals[21] = MDRout;
	assign signals[22] = InPortout;
	assign signals[23] = Cout;

	reg [4:0] sel;

	always @ (signals)begin
		sel = 5'b00000;
		if (signals == 32'h00000002) begin
			sel = 5'b00001; 
		end
		if (signals == 32'h00000004) begin
			sel = 5'b00010; 
		end
		if (signals == 32'h00000008) begin
			sel = 5'b00011; 
		end
		if (signals == 32'h00000010) begin
			sel = 5'b00100; 
		end
		if (signals == 32'h00000020) begin
			sel = 5'b00101; 
		end
		if (signals == 32'h00000040) begin
			sel = 5'b00110; 
		end
		if (signals == 32'h00000080) begin
			sel = 5'b00111; 
		end
		if (signals == 32'h00000100) begin
			sel = 5'b01000; 
		end
		if (signals == 32'h00000200) begin
			sel = 5'b01001; 
		end
		if (signals == 32'h00000400) begin
			sel = 5'b01010; 
		end
		if (signals == 32'h00000800) begin
			sel = 5'b01011; 
		end
		if (signals == 32'h00001000) begin
			sel = 5'b01100; 
		end
		if (signals == 32'h00002000) begin
			sel = 5'b01101; 
		end
		if (signals == 32'h00004000) begin
			sel = 5'b01110; 
		end
		if (signals == 32'h00008000) begin
			sel = 5'b01111; 
		end
		if (signals == 32'h00010000) begin
			sel = 5'b10000; 
		end
		if (signals == 32'h00020000) begin
			sel = 5'b10001; 
		end
		if (signals == 32'h00040000) begin
			sel = 5'b10010; 
		end
		if (signals == 32'h00080000) begin
			sel = 5'b10011; 
		end
		if (signals == 32'h00100000) begin
			sel = 5'b10100; 
		end
		if (signals == 32'h00200000) begin
			sel = 5'b10101; 
		end
		if (signals == 32'h00400000) begin
			sel = 5'b10110; 
		end
		if (signals == 32'h00800000) begin
			sel = 5'b10111; 
		end
		if (signals == 32'h01000000) begin
			sel = 5'b11000; 
		end
	end
	
	always @(sel or registers) begin
		if (sel == 5'b00000) begin
			busMuxOut = registers[0]; 
		end
		if (sel == 5'b00001) begin
			busMuxOut = registers[1]; 
		end
		if (sel == 5'b00010) begin
			busMuxOut = registers[2]; 
		end
		if (sel == 5'b00011) begin
			busMuxOut = registers[3]; 
		end
		if (sel == 5'b00100) begin
			busMuxOut = registers[4]; 
		end
		if (sel == 5'b00101) begin
			busMuxOut = registers[5]; 
		end
		if (sel == 5'b00111) begin
			busMuxOut = registers[6]; 
		end
		if (sel == 5'b01000) begin
			busMuxOut = registers[7]; 
		end
		if (sel == 5'b01001) begin
			busMuxOut = registers[8]; 
		end
		if (sel == 5'b01010) begin
			busMuxOut = registers[9]; 
		end
		if (sel == 5'b01011) begin
			busMuxOut = registers[10]; 
		end
		if (sel == 5'b01100) begin
			busMuxOut = registers[11]; 
		end
		if (sel == 5'b01101) begin
			busMuxOut = registers[12]; 
		end
		if (sel == 5'b01110) begin
			busMuxOut = registers[13]; 
		end
		if (sel == 5'b01111) begin
			busMuxOut = registers[14]; 
		end
		if (sel == 5'b10000) begin
			busMuxOut = registers[15]; 
		end
		if (sel == 5'b10001) begin
			busMuxOut = registers[16]; 
		end
		if (sel == 5'b10010) begin
			busMuxOut = registers[17]; 
		end
		if (sel == 5'b10011) begin
			busMuxOut = registers[18]; 
		end
		if (sel == 5'b10100) begin
			busMuxOut = registers[19]; 
		end
		if (sel == 5'b10101) begin
			busMuxOut = registers[20]; 
		end
		if (sel == 5'b10110) begin
			busMuxOut = registers[21]; 
		end
		if (sel == 5'b10111) begin
			busMuxOut = registers[22]; 
		end
		if (sel == 5'b11000) begin
			busMuxOut = registers[23]; 
		end
	end
endmodule	

module MDMux_in(BusMuxOut, Mdata_in, Mem_read, MDMux_out); 
	input Mem_read;
	input[31:0] BusMuxOut, Mdata_in;
	output[31:0] MDMux_out;
	reg[31:0] MDMux_out;
	always begin
		if(Mem_read) begin
			MDMux_out = Mdata_in;
			end
		else begin
			MDMux_out = BusMuxOut;
			end
	end
endmodule

module MDMux_out(MDR_data, Mem_write, BusMuxIn_MDR, Mdata_out); 
	input Mem_write;
	input[31:0] MDR_data;
	output[31:0] BusMuxIn_MDR, Mdata_out;
	reg[31:0] BusMuxIn_MDR, Mdata_out;
	always begin
		if(Mem_write) begin
			Mdata_out = MDR_data;
			end
		else begin
			BusMuxIn_MDR = MDR_data;
			end
	end
endmodule

module clock(clk);
	output clk;
	reg clk;
	initial begin
		clk = 0;
	end
	always begin
		#5 clk = 1;
		#5 clk = 0;
	end
endmodule


module reg32(Rout, clr, clk, write_enable, BusMuxOut);
	input clr,clk, write_enable;
	input [31:0] BusMuxOut;
	output [31:0]Rout;
	reg[31:0] Rout;

	always @ (posedge clk)begin
		if(clr) begin
			Rout = 32'h00000000;
			end
		if(write_enable) begin
			Rout = BusMuxOut;
			end
	end
endmodule
	
module reg64(Rout_hi, Rout_low, clr, clk, input_value);
	input clr,clk;
	input [63:0] input_value;
	output [31:0]Rout_hi, Rout_low;
	reg[31:0] Rout_hi, Rout_low;

	always @ (posedge clk) begin
		Rout_hi = input_value[63:32];
		Rout_low = input_value[31:0];
		if(clr) begin
			Rout_hi = 0;
			Rout_low = 0;
			end
	end
	
endmodule
