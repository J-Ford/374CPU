module Datapath(IOdata_out, Maddress_out, Mdata_out, clk, Mdata_in, IOdata_in, reset, mem_write, mem_read, G_ra, G_rb, G_rc, R_in,
	R_out, BA_out, write_signals, read_signals, ALU_signals);
	input[31:0] Mdata_in, IOdata_in;
	input[9:0] write_signals, read_signals;
	input[4:0] ALU_signals;
	input reset, mem_write, mem_read, G_ra, G_rb, G_rc, R_in, R_out, BA_out;
	output[31:0] IOdata_out, Maddress_out, Mdata_out;
	output clk;


	//Register write enable wires
	wire HI_write_enable, LO_write_enable, Zhi_write_enable, Zlo_write_enable, PC_write_enable, MDR_write_enable, MAR_write_enable, InPort_write_enable, OutPort_write_enable, Y_write_enable, IR_write_enable;
	wire[15:0] GPR_write_enable, GPR_read_signals;
	
	//Register output wires
	wire[31:0] R0_output, R1_output, R2_output, R3_output, R4_output, R5_output, R6_output, R7_output, R8_output, R9_output, R10_output, 
		R11_output, R12_output, R13_output, R14_output, R15_output, HI_output, LO_output, Zhi_output, Zlo_output, PC_output, MDR_output, InPort_output, C_sign_extended; 

	//other wires
	wire clk, Mem_read, Mem_write;
	wire[31:0] Bus, MDMux_out, MDR_data, ALU_Y_input, Bus_enable, BusMuxIn[31:0];
	wire[63:0] ALU_output; 
	wire[31:0] CLU_in; //goes to CLU

	//initialise clock
	clock synchronous_clock(clk);

	//initialise CLU
	CLU control_unit(G_ra, G_rb, G_rc, R_in, R_out, BA_out, CLU_in, GPR_read_signals, GPR_write_enable, C_sign_extended);
	
	//initialise ALU
	ALU logic_unit(Bus, ALU_Y_input, ALU_output, ALU_signals);
	
	//initialise bus multiplexer
	Bus_Write_Mux Bus_Mux(Bus, Bus_enable, R0_output, R1_output, R2_output, R3_output, R4_output, R5_output, R6_output, R7_output, R8_output, R9_output, R10_output, 
		R11_output, R12_output, R13_output, R14_output, R15_output, HI_output, LO_output, Zhi_output, Zlo_output, PC_output, MDR_output, InPort_output, C_sign_extended);
	
	//initialise registers	
	reg32_R0 R0(R0_output, reset, clk, BA_out, GPR_write_enable[0], Bus);
	reg32 R1(R1_output, reset, clk, GPR_write_enable[1], Bus);
	reg32 R2(R2_output, reset, clk, GPR_write_enable[2], Bus);
	reg32 R3(R3_output, reset, clk, GPR_write_enable[3], Bus);
	reg32 R4(R4_output, reset, clk, GPR_write_enable[4], Bus);
	reg32 R5(R5_output, reset, clk, GPR_write_enable[5], Bus);
	reg32 R6(R6_output, reset, clk, GPR_write_enable[6], Bus);
	reg32 R7(R7_output, reset, clk, GPR_write_enable[7], Bus);
	reg32 R8(R8_output, reset, clk, GPR_write_enable[8], Bus);
	reg32 R9(R9_output, reset, clk, GPR_write_enable[9], Bus);
	reg32 R10(R10_output, reset, clk, GPR_write_enable[10], Bus);
	reg32 R11(R11_output, reset, clk, GPR_write_enable[11], Bus);
	reg32 R12(R12_output, reset, clk, GPR_write_enable[12], Bus);
	reg32 R13(R13_output, reset, clk, GPR_write_enable[13], Bus);
	reg32 R14(R14_output, reset, clk, GPR_write_enable[14], Bus);
	reg32 R15(R15_output, reset, clk, GPR_write_enable[15], Bus);
	
	reg32 HI(HI_output, reset, clk, HI_write_enable, Bus);
	reg32 LO(LO_output, reset, clk, LO_write_enable, Bus);
	reg32 PC(PC_output, reset, clk, PC_write_enable, Bus);

	reg32_MDR MDR(Mdata_out, MDR_output, reset, clk, MDR_write_enable, Mem_write, Mem_read, Bus, Mdata_in); //change Mem_write to Mem_write_enable

	reg32 MAR(Maddress_out, reset, clk, MAR_write_enable, Bus);
	reg32 InPort(InPort_output, reset, clk, InPort_write_enable, IOdata_in); //*note always accept new data from IO 
	reg32 OutPort(IOdata_out, reset, clk, OutPort_write_enable, Bus);//*
	reg32 IR(CLU_in, reset, clk, IR_write_enable, Bus);
	reg32 Y(ALU_Y_input, reset, clk, Y_write_enable, Bus); //write to Y
	reg64 Z(Zhi_output, Zlo_output, reset, clk, ALU_output);// writes to low and hi
	
	//assign inputs to Register Selection Wires (will be done by CLU in future)

	assign HI_write_enable = write_signals[0];
	assign LO_write_enable = write_signals[1];
	assign Zhi_write_enable = write_signals[2];
	assign Zlo_write_enable = write_signals[3];
	assign PC_write_enable = write_signals[4];
	assign MDR_write_enable = write_signals[5];
	assign OutPort_write_enable = write_signals[6];
	assign InPort_write_enable = 1; //note: always trying to read, this will be updated
	assign MAR_write_enable = write_signals[7];
	assign Y_write_enable = write_signals[8];
	assign IR_write_enable = write_signals[9];
	
	assign Bus_enable[15:0] = GPR_read_signals[15:0]; //R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12 R13, R14, R15,
	assign Bus_enable[23:16] = read_signals[7:0]; //HI_en, LO_en, Zhi_en, Zlo_en, PC_en, MDR_en, InPort_en, C_en
	
endmodule

module CLU(G_ra, G_rb, G_rc, R_in, R_out, BA_out, IR, read_signals, write_signals, C_sign_extended);
	input G_ra, G_rb, G_rc, R_in, R_out, BA_out;
	input[31:0] IR;
	output[15:0] read_signals, write_signals;
	output[31:0] C_sign_extended;
	
	Select_Decode SD(G_ra, G_rb, G_rc, R_in, R_out, BA_out, IR[26:23], IR[22:19], IR[18:15], read_signals, write_signals);
	
endmodule
	
module Select_Decode(G_ra, G_rb, G_rc, R_in, R_out, BA_out, Ra, Rb, Rc, read_signals, write_signals);
	input G_ra, G_rb, G_rc, R_in, R_out, BA_out;
	input[3:0] Ra, Rb, Rc;
	output[15:0] read_signals, write_signals;
	wire[3:0] decoder_input;
	wire[15:0] decoder_output;
	decoder_4_16 decoder(decoder_input, decoder_output);
	
	assign decoder_input = (Ra & G_ra) & (Rb & G_rb) & (Rc & G_rb);
	assign read_signals = R_in & decoder_output;
	assign write_signals = (BA_out & R_out) & decoder_output;
	
endmodule
	
	
		
module decoder_4_16 (in, out);
	input[3:0] in;
	output [15:0] out;
	assign out[0] = (!in[3]) & (!in[2]) & (!in[1]) & (!in[0]);
	assign out[1] = (!in[3]) & (!in[2]) & (!in[1]) & (in[0]);
	assign out[2] = (!in[3]) & (!in[2]) & (in[1]) & (!in[0]);
	assign out[3] = (!in[3]) & (!in[2]) & (in[1]) & (in[0]);
	assign out[4] = (!in[3]) & (in[2]) & (!in[1]) & (!in[0]);
	assign out[5] = (!in[3]) & (in[2]) & (!in[1]) & (in[0]);
	assign out[6] = (!in[3]) & (in[2]) & (in[1]) & (!in[0]);
	assign out[7] = (!in[3]) & (in[2]) & (in[1]) & (in[0]);
	assign out[8] = (in[3]) & (!in[2]) & (!in[1]) & (!in[0]);
	assign out[9] = (in[3]) & (!in[2]) & (!in[1]) & (in[0]);
	assign out[10] = (in[3]) & (!in[2]) & (in[1]) & (!in[0]);
	assign out[11] = (in[3]) & (!in[2]) & (in[1]) & (in[0]);
	assign out[12] = (in[3]) & (in[2]) & (!in[1]) & (!in[0]);
	assign out[13] = (in[3]) & (in[2]) & (!in[1]) & (in[0]);
	assign out[14] = (in[3]) & (in[2]) & (in[1]) & (!in[0]);
	assign out[15] = (in[3]) & (in[2]) & (in[1]) & (in[0]);
endmodule

module ALU(A, B, C, opperation_signal);
	input[31:0] A, B;
	input[4:0] opperation_signal;
	output[63:0] C;
	reg[63:0] C;
	integer i, rotateCount;
	always @(*) begin
		if (opperation_signal == 5'b00101) begin //ADD
			C[31:0] = A + B;
			end
		if (opperation_signal == 5'b00110) begin //SUB
			C[31:0] = A - B;
			end
		if (opperation_signal == 5'b10000) begin //MUL
			C = A * B;
			end
		if (opperation_signal == 5'b10001) begin //DIV
			C = A / B;
			end
		if (opperation_signal == 5'b01001) begin //SHR
			C[31:0] = A >> B;
			end
		if (opperation_signal == 5'b01010) begin //SHL
			C[31:0] = A << B;
			end
		if (opperation_signal == 5'b01011) begin //ROR
			//rotateCount = 0;
			C[31:0] = A;
			for(i = 0; i<32; i=i+1) begin
				if(i<B) begin
				//rotateCount = rotateCount + 1;
					C = {C[0] , C[31:1]};
					end
				end
			end
			//C = {C[30:0] , C[31]};
			
		if (opperation_signal == 5'b01100) begin //ROL
			rotateCount = 0;
			C[31:0] = A;
			while((B > rotateCount) && (rotateCount < 32)) begin
				C = {C[30:0] , C[31]};
				rotateCount = rotateCount + 1;
				end
			end
		if (opperation_signal == 5'b00111) begin //AND
			C[31:0] = A & B;
			end
		if (opperation_signal == 5'b01000) begin //OR
			C[31:0] = A | B;
			end
		if (opperation_signal == 5'b10010) begin //NEG
			C[31:0] = !A + 1;
			end
		if (opperation_signal == 5'b1011) begin //NOT
			C[31:0] = !A;
			end	
		if (opperation_signal == 5'b11111) begin //Inc_PC
			C[31:0] = A + 1;
			end
	end
endmodule

module Bus_Write_Mux(busMuxOut, Bus_enable, in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, 
		in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23);
	input[31:0] Bus_enable, in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, 
		in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23;
	output[31:0] busMuxOut;
	wire[4:0] Encoded_Signals;
	Encoder32_5 bus_encoder(Bus_enable, Encoded_Signals);
	mux24 select_input(busMuxOut, Encoded_Signals, in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, 
		in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23);
endmodule	

module Encoder32_5(out, in);
	input[31:0] in;
	output[4:0] out;
	reg[4:0] out;

	always @ (*)begin
		if (in == 32'h00000002) begin
			out = 5'b00001; 
		end
		if (in == 32'h00000004) begin
			out = 5'b00010; 
		end
		if (in == 32'h00000008) begin
			out = 5'b00011; 
		end
		if (in == 32'h00000010) begin
			out = 5'b00100; 
		end
		if (in == 32'h00000020) begin
			out = 5'b00101; 
		end
		if (in == 32'h00000040) begin
			out = 5'b00110; 
		end
		if (in == 32'h00000080) begin
			out = 5'b00111; 
		end
		if (in == 32'h00000100) begin
			out = 5'b01000; 
		end
		if (in == 32'h00000200) begin
			out = 5'b01001; 
		end
		if (in == 32'h00000400) begin
			out = 5'b01010; 
		end
		if (in == 32'h00000800) begin
			out = 5'b01011; 
		end
		if (in == 32'h00001000) begin
			out = 5'b01100; 
		end
		if (in == 32'h00002000) begin
			out = 5'b01101; 
		end
		if (in == 32'h00004000) begin
			out = 5'b01110; 
		end
		if (in == 32'h00008000) begin
			out = 5'b01111; 
		end
		if (in == 32'h00010000) begin
			out = 5'b10000; 
		end
		if (in == 32'h00020000) begin
			out = 5'b10001; 
		end
		if (in == 32'h00040000) begin
			out = 5'b10010; 
		end
		if (in == 32'h00080000) begin
			out = 5'b10011; 
		end
		if (in == 32'h00100000) begin
			out = 5'b10100; 
		end
		if (in == 32'h00200000) begin
			out = 5'b10101; 
		end
		if (in == 32'h00400000) begin
			out = 5'b10110; 
		end
		if (in == 32'h00800000) begin
			out = 5'b10111; 
		end
		if (in == 32'h01000000) begin
			out = 5'b11000; 
		end
	end
endmodule
	
module  mux24(out, select, in_0, in_1, in_2 ,in_3, in_4,in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16,
	in_17, in_18, in_19, in_20, in_21, in_22, in_23);
	input[31:0] in_0, in_1, in_2 ,in_3, in_4,in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16,
		in_17, in_18, in_19, in_20, in_21, in_22, in_23;
	input[5:0] select;
	output[31:0] out;
	reg[31:0] out;
	always begin
		if (select == 5'b00000) begin
			out = in_0; 
		end
		if (select == 5'b00001) begin
			out = in_1; 
		end
		if (select == 5'b00010) begin
			out = in_2; 
		end
		if (select == 5'b00011) begin
			out = in_3; 
		end
		if (select == 5'b00100) begin
			out = in_4; 
		end
		if (select == 5'b00101) begin
			out = in_5; 
		end
		if (select == 5'b00110) begin
			out = in_6; 
		end
		if (select == 5'b00111) begin
			out = in_7; 
		end
		if (select == 5'b01000) begin
			out = in_8; 
		end
		if (select == 5'b01001) begin
			out = in_9; 
		end
		if (select == 5'b01010) begin
			out = in_10; 
		end
		if (select == 5'b01011) begin
			out = in_11; 
		end
		if (select == 5'b01100) begin
			out = in_12; 
		end
		if (select == 5'b01101) begin
			out = in_13; 
		end
		if (select == 5'b01110) begin
			out = in_14;
		end
		if (select == 5'b01111) begin
			out = in_15;
		end
		if (select == 5'b10000) begin
			out = in_16; 
		end
		if (select == 5'b10001) begin
			out = in_17; 
		end
		if (select == 5'b10010) begin
			out = in_17; 
		end
		if (select == 5'b10011) begin
			out = in_19; 
		end
		if (select == 5'b10100) begin
			out = in_20; 
		end
		if (select == 5'b10101) begin
			out = in_21; 
		end
		if (select == 5'b10110) begin
			out = in_22; 
		end
		if (select == 5'b10111) begin
			out = in_23; 
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

module reg32(Rout, clr, clk, write_enable, write_value);
	input clr,clk, write_enable;
	input [31:0] write_value;
	output [31:0]Rout;
	reg[31:0] Rout;

	always @ (posedge clk)begin
		if(clr) begin
			Rout = 32'h00000000;
			end
		if(write_enable) begin
			Rout = write_value;
			end
	end
endmodule

module reg32_R0(Rout, clr, clk, BA_out, write_enable, write_value);
	input clr,clk, write_enable, BA_out;
	input [31:0] write_value;
	output [31:0]Rout;
	reg[31:0] Rout;

	always @ (posedge clk)begin
		if(clr) begin
			Rout = 32'h00000000;
			end
		if(write_enable) begin
			Rout = write_value & (!BA_out);
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

	
module reg64(Rout_hi, Rout_low, clr, clk, write_value);
	input clr,clk;
	input [63:0] write_value;
	output [31:0]Rout_hi, Rout_low;
	reg[31:0] Rout_hi, Rout_low;

	always @ (posedge clk) begin
		Rout_hi = write_value[63:32];
		Rout_low = write_value[31:0];
		if(clr) begin
			Rout_hi = 0;
			Rout_low = 0;
			end
	end
	
endmodule
