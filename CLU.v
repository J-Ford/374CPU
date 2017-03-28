module CLU(G_ra, G_rb, G_rc, R_in, R_out, BA_out, CON_out, IR, read_signals, write_signals, C_sign_extended);
	input G_ra, G_rb, G_rc, R_in, R_out, BA_out, CON_out;
	input[31:0] IR;
	output[15:0] read_signals, write_signals;
	output[31:0] C_sign_extended;
	//note CON_out goes into CLU but doesn't do anything in phase 2
	
	Select_Decode SD(G_ra, G_rb, G_rc, R_in, R_out, BA_out, IR[26:23], IR[22:19], IR[18:15], read_signals, write_signals);
	sign_extend SE(C_sign_extended, IR[18:0]);
endmodule

module sign_extend(value_sign_extend, value);
	input[18:0] value;
	output[31:0] value_sign_extend;
	assign value_sign_extend = {value[18],value[18],value[18],value[18],value[18],value[18],value[18],
		value[18],value[18],value[18],value[18],value[18],value[18],value[18], value[17:0]};
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