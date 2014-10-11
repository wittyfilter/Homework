//******************************************************************************
// MIPS verilog model
//
// ALU.v
//
// The ALU performs all the arithmetic/logical integer operations 
// specified by the ALUsel from the decoder. 
// 
// verilog written QMJ
// modified by 
// modified by 
//
//******************************************************************************

module ALU (
	// Outputs
	Result,overflow,
	// Inputs
	ALUCode, A, B
);

	input [4:0]	ALUCode;				// Operation select
	input [31:0]	A, B;

	output reg[31:0]	Result;
	output overflow;

//******************************************************************************
// Shift operation: ">>>" will perform an arithmetic shift, but the operand
// must be reg signed
//******************************************************************************
	reg signed [31:0] B_reg;
	
	always @(B) begin
		B_reg = B;
	end

	
// Decoded ALU operation select (ALUsel) signals
   parameter	 alu_add=  5'b00000;
   parameter	 alu_and=  5'b00001;
   parameter	 alu_xor=  5'b00010;
   parameter	 alu_or =  5'b00011;
   parameter	 alu_nor=  5'b00100;
   parameter	 alu_sub=  5'b00101;
   parameter	 alu_andi= 5'b00110;
	parameter	 alu_xori= 5'b00111;
	parameter	 alu_ori = 5'b01000;
	parameter    alu_jr =  5'b01001;
	parameter	 alu_beq=  5'b01010;
   parameter	 alu_bne=  5'b01011;
	parameter	 alu_bgez= 5'b01100;
   parameter	 alu_bgtz= 5'b01101;
   parameter	 alu_blez= 5'b01110;
   parameter	 alu_bltz= 5'b01111;
	parameter 	 alu_sll=  5'b10000;
	parameter	 alu_srl=  5'b10001;
	parameter	 alu_sra=  5'b10010;	
	parameter	 alu_slt=  5'b10011;
   parameter	 alu_sltu= 5'b10100;
   
//Extra signal to distinguish 'add' & 'sub'    
	assign Binvert = ~(ALUCode==alu_add);
	
//******************************************************************************
// ALU Result datapath
//******************************************************************************
	wire [31:0] Result_add, Result_and, Result_xor, Result_or, Result_nor,
	Result_andi, Result_xori, Result_ori, Result_sll, Result_srl, Result_sra;
	wire Result_slt, Result_sltu;
	wire co;
	
	adder_32bits adder_inst2(.a(A), .b(B^{32{Binvert}}), .ci(Binvert), .co(co), .s(Result_add));
	assign Result_slt = (A[31]&&(~B[31])) ||((A[31]~^B[31]) && Result_add[31]);
	assign Result_sltu = (~A[31]&&(B[31]))||((A[31]~^B[31]) && Result_add[31]);
	assign Result_and = A&B;
	assign Result_xor = A^B;
	assign Result_or = A|B;
	assign Result_nor = ~(A|B);
	assign Result_andi = A&{16'd0, B[15:0]};
	assign Result_xori = A^{16'd0, B[15:0]};
	assign Result_ori = A|{16'd0, B[15:0]};
	assign Result_sll = B<<A;
	assign Result_srl = B>>A;
	assign Result_sra = B_reg>>>A;
	
//===========================================================
//   mux for ALU
//===========================================================	
always @(*)
begin
	case(ALUCode)
		alu_add:	Result <= Result_add;
		alu_sub:	Result <= Result_add;
		alu_and:	Result <= Result_and;
		alu_xor:	Result <= Result_xor;
		alu_or:		Result <= Result_or;
		alu_nor:	Result <= Result_nor;
		alu_andi:	Result <= Result_andi;
		alu_xori:	Result <= Result_xori;
		alu_ori:	Result <= Result_ori;
		alu_sll:	Result <= Result_sll;
		alu_srl:	Result <= Result_srl;
		alu_sra:	Result <= Result_sra;
		alu_slt:	Result <= Result_slt;
    alu_sltu: Result <= Result_sltu;
	endcase
end		
assign overflow = co^Result_add[31]; 

endmodule