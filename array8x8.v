module array (pp_out, M_in, Q);
	input [15:0] M_in;
	input [7:0] Q;
	output[16:0] pp_out;
	reg[16:0] P_partial;
	
	always@(M_in, Q, pp_out, P_partial)
		begin
			case(Q[0])
				1'b0:
				begin
				P_partial =  16'b0000000000000000;
				end
			
				1'b1:
				begin
				P_partial = M_in;
				end
			endcase
		end

	assign pp_out = P_partial;
endmodule

module array8x8(P, M, Q);

	input [7:0] M, Q;
	output [16:0] P;
	
	wire [16:0] PP0;
	wire [16:0] PP1;
	wire [16:0] PP2;
	wire [16:0] PP3;
	wire [16:0] PP4;
	wire [16:0] PP5;
	wire [16:0] PP6;
	wire [16:0] PP7;

	array Array0(
		.M_in({8'b00000000,M}),
		.Q(Q),
		.pp_out(PP0)
	);

	array Array1(
		.M_in({8'b00000000,M} << 1),
		.Q(Q >> 1),
		.pp_out(PP1)
	);

	array Array2(
		.M_in({8'b00000000,M} << 2),
		.Q(Q >> 2),
		.pp_out(pp2)
	);

	array Array3(
		.M_in({8'b00000000,M} << 3),
		.Q(Q >> 3),
		.pp_out(PP3)
	);

	array Array4(
		.M_in({8'b00000000,M} << 4),
		.Q(Q >> 4),
		.pp_out(PP4)
	);

	array Array5(
		.M_in({8'b00000000,M} << 5),
		.Q(Q >> 5),
		.pp_out(pp5)
	);

	array Array6(
		.M_in({8'b00000000,M} << 6),
		.Q(Q >> 6),
		.pp_out(PP6)
	);

	array Array7(
		.M_in({8'b00000000,M} << 7),
		.Q(Q >> 7),
		.pp_out(PP7)
	);

	assign P = (PP0+PP1+PP2+PP3+PP4+PP5+PP6+PP7);
endmodule
