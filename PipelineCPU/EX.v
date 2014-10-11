`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:30:20 11/12/2009 
// Design Name: 
// Module Name:    EX 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module EX(RegDst_ex, ALUCode_ex, ALUSrcA_ex, ALUSrcB_ex, Imm_ex, Sa_ex, RsAddr_ex, RtAddr_ex, RdAddr_ex,
          RsData_ex, RtData_ex, RegWriteData_wb, ALUResult_mem, RegWriteAddr_wb, RegWriteAddr_mem, 
			 RegWrite_wb, RegWrite_mem, RegWriteAddr_ex, ALUResult_ex, MemWriteData_ex, ALU_A, ALU_B);
    input RegDst_ex;
    input [4:0] ALUCode_ex;
    input ALUSrcA_ex;
    input ALUSrcB_ex;
    input [31:0] Imm_ex;
    input [31:0] Sa_ex;
    input [4:0] RsAddr_ex;
    input [4:0] RtAddr_ex;
    input [4:0] RdAddr_ex;
    input [31:0] RsData_ex;
    input [31:0] RtData_ex;
    input [31:0] RegWriteData_wb;
    input [31:0] ALUResult_mem;
    input [4:0] RegWriteAddr_wb;
    input [4:0] RegWriteAddr_mem;
    input RegWrite_wb;
    input RegWrite_mem;
    output [4:0] RegWriteAddr_ex;
    output [31:0] ALUResult_ex;
    output [31:0] MemWriteData_ex;
    output [31:0] ALU_A;
    output [31:0] ALU_B;

//forwarding
	wire[1:0] ForwardA,ForwardB;
	assign ForwardA[0] = RegWrite_wb&&(RegWriteAddr_wb!=0)&&(RegWriteAddr_mem!=RsAddr_ex)&&(RegWriteAddr_wb==RsAddr_ex);
	assign ForwardA[1] = RegWrite_mem&&(RegWriteAddr_mem!=0)&&(RegWriteAddr_mem==RsAddr_ex);
	assign ForwardB[0] = RegWrite_wb&&(RegWriteAddr_wb!=0)&&(RegWriteAddr_mem!=RtAddr_ex)&&(RegWriteAddr_wb==RtAddr_ex);
	assign ForwardB[1] = RegWrite_mem&&(RegWriteAddr_mem!=0)&&(RegWriteAddr_mem==RtAddr_ex);

//MUX for A
reg [31:0] mux_A;
always @(*)
begin
	case(ForwardA)
    2'b00: mux_A <= RsData_ex;
    2'b01: mux_A <= RegWriteData_wb;
    2'b10: mux_A <= ALUResult_mem;
	endcase
end

//MUX for B
reg [31:0] mux_B;
always @(*)
begin
	case(ForwardB)
    2'b00: mux_B <= RtData_ex;
    2'b01: mux_B <= RegWriteData_wb;
    2'b10: mux_B <= ALUResult_mem;
	endcase
end
	 
//MUX for ALU_A
mux_2to1 #(32) mux1(.out(ALU_A), .in0(mux_A), .in1(Sa_ex), .sel(ALUSrcA_ex));

//MUX for ALU_B
mux_2to1 #(32) mux2(.out(ALU_B), .in0(mux_B), .in1(Imm_ex), .sel(ALUSrcB_ex));


//ALU inst
	 ALU  ALU (
	 // Outputs
	.Result(ALUResult_ex),
	.overflow(),
	// Inputs
	.ALUCode(ALUCode_ex), 
	.A(ALU_A), 
	.B(ALU_B)
);
	 
//MUX for RegWriteAddr_ex
mux_2to1 #(5) mux3(.out(RegWriteAddr_ex), .in0(RtAddr_ex), .in1(RdAddr_ex), .sel(RegDst_ex));

assign MemWriteData_ex = mux_B;

endmodule
