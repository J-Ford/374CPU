module CON_FF(out, IR, Bus_data, CON_en);
	input[31:0] IR, Bus_data;
	input CON_en;
	output out;
	reg out;
	wire eq_in, ne_in, gte_in, lt_in, or_out;
	wire[3:0] decoder_output;
	decoder2_4 IR_decoder(decoder_output, IR[1:0]);
	assign eq_in = ~| Bus_data;
	assign ne_in = !eq_in;
	assign gte_in = Bus_data[31];
	assign lt_in = !gte_in;
	assign or_out = (decoder_output[0] & eq_in) | (decoder_output[1] & ne_in) | (decoder_output[2] & gte_in) | (decoder_output[3] & lt_in) ;
	
	always @(*) begin
		out = or_out & CON_en;
		end
endmodule

module decoder2_4(out, in);
	input[1:0] in;
	output[3:0] out;
	assign out[3] = in[1] & in[0];
	assign out[2] = in[1] & !(in[0]);
	assign out[1] = !(in[1]) & in[0];
	assign out[0] = !(in[1]) & !(in[0]);
endmodule