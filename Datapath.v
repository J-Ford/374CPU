module Datapath(clk, reset, mem_write_enable, mem_read_enable, G_ra, G_rb, G_rc, R_in, R_out, BA_out, CON_en, HI_write_enable, LO_write_enable, Z_write_enable, PC_write_enable, 
MDR_write_enable, OutPort_write_enable, InPort_write_enable, MAR_write_enable, Y_write_enable, IR_write_enable,, HI_en, LO_en, Zhi_en, Zlo_en, PC_en, MDR_en, InPort_en, C_en , ALU_signals);
	input HI_write_enable, LO_write_enable, Z_write_enable, PC_write_enable, MDR_write_enable, OutPort_write_enable, InPort_write_enable, MAR_write_enable, Y_write_enable, IR_write_enable; // write signals
	input HI_en, LO_en, Zhi_en, Zlo_en, PC_en, MDR_en, InPort_en, C_en; //read signals
	input[4:0] ALU_signals;
	input reset, mem_write_enable, mem_read_enable, G_ra, G_rb, G_rc, R_in, R_out, BA_out, CON_en;
	input clk;


	//Register write enable wires
	wire HI_write_enable, LO_write_enable, Z_write_enable, PC_write_enable, MDR_write_enable, MAR_write_enable, InPort_write_enable, OutPort_write_enable, Y_write_enable, IR_write_enable;
	wire[15:0] GPR_write_enable, GPR_read_signals;
	
	//Register output wires
	wire[31:0] R0_output, R1_output, R2_output, R3_output, R4_output, R5_output, R6_output, R7_output, R8_output, R9_output, R10_output, 
		R11_output, R12_output, R13_output, R14_output, R15_output, HI_output, LO_output, Zhi_output, Zlo_output, PC_output, MDR_output, InPort_output, C_sign_extended; 

	//other wires
	wire clk, Mem_read_enable, Mem_write_enable, Mem_RW, CON_out;
	wire[31:0] Bus, MDMux_out, MDR_data, ALU_Y_input, Bus_enable, IR_out, Data_to_RAM, Data_from_RAM, IOdata_in, IOdata_out;
	wire[63:0] ALU_output; 
	wire[8:0] Mem_address;
	
	//initialise CON
	CON_FF CON(CON_out, IR_out, Bus, CON_en);

	//initialize CLU
	CLU control_unit(G_ra, G_rb, G_rc, R_in, R_out, BA_out, CON_out, IR_out, GPR_read_signals, GPR_write_enable, C_sign_extended);
	
	//initialize ALU
	ALU logic_unit(ALU_output, ALU_Y_input, Bus, ALU_signals);
	
	//initialize RAM
	RAM_512 RAM(Mem_address, clk, Data_to_RAM, Mem_RW, Data_from_RAM);
	
	//initialize bus multiplexer
	Bus_Write_Mux Bus_Mux(Bus, Bus_enable, R0_output, R1_output, R2_output, R3_output, R4_output, R5_output, R6_output, R7_output, R8_output, R9_output, R10_output, 
		R11_output, R12_output, R13_output, R14_output, R15_output, HI_output, LO_output, Zhi_output, Zlo_output, PC_output, MDR_output, InPort_output, C_sign_extended);
	
	//initialize registers	
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

	reg32_MDR MDR(Data_to_RAM, MDR_output, Mem_RW, reset, clk, MDR_write_enable, Mem_write_enable, Mem_read_enable, Bus, Data_from_RAM); //change Mem_write to Mem_write_enable

	reg32_MAR MAR(Mem_address, reset, clk, MAR_write_enable, Bus);
	reg32 InPort(InPort_output, reset, clk, InPort_write_enable, IOdata_in); //*note always accept new data from IO 
	reg32 OutPort(IOdata_out, reset, clk, OutPort_write_enable, Bus);//*
	reg32 IR(IR_out, reset, clk, IR_write_enable, Bus);
	reg32 Y(ALU_Y_input, reset, clk, Y_write_enable, Bus); //write to Y
	//reg32 C(ALU_Y_input, reset, clk, Y_write_enable, Bus); //write to Y
	reg64 Z(Zhi_output, Zlo_output, reset,Z_write_enable, clk, ALU_output);// writes to low and hi Rout_hi, Rout_low, clr, clk, write_enable, input_value
	
	assign Bus_enable[15:0] = GPR_read_signals[15:0]; //R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12 R13, R14, R15,
	assign Bus_enable[23:16] =  {HI_en, LO_en, Zhi_en, Zlo_en, PC_en, MDR_en, InPort_en, C_en}; //read_signals
	
endmodule





