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


module reg32_MDR(Memory_output, Bus_output, Mem_RW, clr, clk, MDR_write_enable, Memory_write_enable, Memory_read_enable, Bus_input, Memory_input);
	input clr,clk, Memory_write_enable, Memory_read_enable, MDR_write_enable;
	input [31:0] Bus_input, Memory_input;
	output [31:0]Memory_output, Bus_output;
	output Mem_RW;
	reg Mem_RW;
	reg[31:0] Rout;
	wire[31:0] register;

	MDMux_in input_select(Bus_input, Memory_input, Memory_read_enable, register);
	MDMux_out output_select(Rout, Memory_write_enable, Bus_output, Memory_output);
	
	always @ (posedge clk)begin
	Mem_RW = MDR_write_enable & (!Memory_read_enable);
		if(clr) begin
			Rout = 32'h00000000;
			end
		if(MDR_write_enable) begin
			Rout = register;
			end
	end
endmodule

module reg32_MAR(Rout, clr, clk, write_enable, write_value);
	input clr,clk, write_enable;
	input [31:0] write_value;
	output [8:0] Rout;
	reg[31:0] value;
	assign Rout = value[8:0];

	always @ (posedge clk)begin
		if(clr) begin
			value = 32'h00000000;
			end
		if(write_enable) begin
			value = write_value;
			end
	end
endmodule

module MDMux_in(Bus_data, Mdata_in, Mem_read_enable, MDMux_out); //BusMuxOut
	input Mem_read_enable;
	input[31:0] Bus_data, Mdata_in;
	output[31:0] MDMux_out;
	//assign MDMux_out = (Mem_read_enable & Mdata_in) | (!Mem_read_enable & Bus_data);
	assign MDMux_out = (Mem_read_enable) ? Mdata_in : Bus_data;	
endmodule

module MDMux_out(MDR_data, Mem_write_enable, BusData_out, Mdata_out); 
	input Mem_write_enable;
	input[31:0] MDR_data;
	output[31:0] BusData_out, Mdata_out;
	assign Mdata_out = (Mem_write_enable) ? MDR_data : 0; //MDR_data & Mem_write_enable;
	assign BusData_out = (!Mem_write_enable) ? MDR_data : 0; //MDR_data & (!Mem_write_enable);
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
