module datapath_tb;
	reg reset;
	reg[26:0] read_signals, write_signals;
	reg[31:0] Mdata_in, IOdata_in;
	reg[3:0] ALU_signals;
	wire[31:0] IOdata_out, Maddress_out, Mdata_out;
	wire clk;
	
	datapath datapath1(
		.read_signals (read_signals), 
		.write_signals (write_signals),
		.Mdata_in (Mdata_in), 
		.IOdata_in (IOdata_in), 
		.ALU_signals (ALU_signals), 
		.reset (reset), 
		.IOdata_out (IOdata_out), 
		.Maddress_out (Maddress_out), 
		.Mdata_out (Mdata_out), 
		.clk (clk) 
	);	
	
	initial
		begin	
				//init
			read_signals = 26'b00000000000000000000000000;
			write_signals = 26'b00000000000000000000000000;
			ALU_signals = 4'b0000;
			Mdata_in = 32'h00000000;
			IOdata_in = 32'h00000000;
			reset = 0;
			
			@(posedge clk) 
				fork
					read_signals <=27'b0000000_00000_00000_00000_00000;
					write_signals <= 27'b0000000_00000_00000_00000_00000;
					ALU_signals <= 4'b1111; //nop
					Mdata_in <= 32'h00000000;
					IOdata_in <= 32'h00000000;
				join
			
					
			//load R1 with 6
			@(posedge clk) 
				fork //T0
					read_signals <= 27'b1000000_00000_00000_00000_00000; //mem_read
					write_signals <= 27'b0000000_00000_00000_00000_00000;
					Mdata_in <= 32'h00000006; //6
				join
		

			@(posedge clk) 
				fork //T1
					read_signals <= 27'b0000010_00000_00000_00000_00000; //MDR_en
					write_signals <= 27'b0000000_00000_00000_00000_00010; //R1_write
				join
			
					
			@(posedge clk) 
				//load R2 with 2
				fork //T0
					read_signals <= 27'b1000000_00000_00000_00000_00000; //mem_read
					write_signals <= 27'b0000000_00000_00000_00000_00000;
					Mdata_in <= 32'h00000002; //2
				join
			

			@(posedge clk) 
				fork //T1
					read_signals <= 27'b0000010_00000_00000_00000_00000; //MDR_en
					write_signals <= 27'b0000000_00000_00000_00000_00100; //R2_write
				join
			
					
			//Add R2 and R3 ->R1
			@(posedge clk) 
				fork //T0 transfer PC to MAR and Incriment PC
					read_signals <= 27'b0000001_00000_00000_00000_00000; //PC_en
					write_signals <= 27'b0001000_00000_00000_00000_00000; //MAR
					ALU_signals <= 4'b1100; //INC_PC
				join
			
					
			@(posedge clk) 
				fork //T1 Transfer new PC value from Z_lo to PC, read mem (to MDR)
					read_signals <= 27'b1000000_10000_00000_00000_00000; //ZLO_en, mem_read
					write_signals <= 27'b0000001_00000_00000_00000_00000; //PC
					ALU_signals <= 4'b1111; //NOP
					Mdata_in <= 32'b00101_0001_0010_0011_000000000000000; //add R1, R2, R3
				join
			
					
			@(posedge clk) 
				fork//T2 Transfer instruction from MDR to IR
					read_signals <= 27'b0000010_00000_00000_00000_00000; //MDR
					write_signals <= 27'b0100000_00000_00000_00000_00000;//IR
				join
			
					
			@(posedge clk) 
				fork//T3 Transfer R2 to Y
					read_signals <= 27'b0000000_00000_00000_00000_00100; //R2
					write_signals <= 27'b0010000_00000_00000_00000_00000;//Y
				join
			

			@(posedge clk) 
				fork//T4 Transfer R3 to bus and start adder
					read_signals <= 27'b0000000_00000_00000_00000_01000; //R3
					write_signals <= 27'b0000000_00000_00000_00000_00000;
					ALU_signals <= 4'b0000; //ADD
				join
			
					
			@(posedge clk) 
				fork//T5 Trasfer result from Z_LO to R1
					read_signals <= 27'b0000000_10000_00000_00000_00000; //Z_LO
					write_signals <= 27'b0010000_00000_00000_00000_00010;//R1
					ALU_signals <= 4'b1111;//NOP
				join
			
							
			#10 $finish;
		end
		
endmodule
