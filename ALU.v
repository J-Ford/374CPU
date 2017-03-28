module ALU(C, A, B, opperation_signal);
	input[31:0] A, B;
	input[4:0] opperation_signal;
	output[63:0] C;
	reg[63:0] C;
	wire[63:0] Mult_A, Mult_B;
	integer i, rotateCount;
	assign Mult_A = { (32'h00000000 | A[31]), A[31:0] };
	assign Mult_B = { (32'h00000000 | B[31]), B[31:0] };
	always @(*) begin
		C[63:32] = 0;
		case (opperation_signal)
			5'b00101: C[31:0] = A + B; //ADD
			5'b00110: C[31:0] = A - B; //SUB
			5'b10000: C = Mult_A * Mult_B; //MUL
			5'b10001: C = Mult_A / Mult_B; //DIV
			5'b01001: C[31:0] = A >> B; //SHR
			5'b01010: C[31:0] = A << B; //SHL
			5'b01011: begin//ROR
				rotateCount = 0;
					C[31:0] = A;
					while((B > rotateCount) && (rotateCount < 32)) begin
						C = {C[0] , C[31:1]};
						rotateCount = rotateCount + 1;
					end
				end
			5'b01100:begin //ROL
				rotateCount = 0;
					C[31:0] = A;
					while((B > rotateCount) && (rotateCount < 32)) begin
						C = {C[30:0] , C[31]};
						rotateCount = rotateCount + 1;
					end
				end
			5'b00111: C[31:0] = A & B; //AND
			5'b01000: C[31:0] = A | B;  //OR
			5'b10010: C[31:0] = ~A + 1; //NEG
			5'b10011: C[31:0] = ~A; //NOT
			5'b01110: C[31:0] = A & B; //ANDI
			5'b01111: C[31:0] = A | B; //ORI
			5'b01101: C[31:0] = A + B; //ADDI
			5'b11111: C[31:0] = A + 1; //INC PC
			default: C = 64'h0000000000000000; //NOP, 5'b11110
		endcase
	end
endmodule
