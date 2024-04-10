/*
 *	Template for Project 2 Part 2
 *	Copyright (C) 2022  Chen Chia Yi or any person belong ESSLab.
 *	All Right Reserved.
 *
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *	This file is for people who have taken the cource (1102 Computer
 *	Organizarion) to use.
 *	We (ESSLab) are not responsible for any illegal use.
 *
 */

/*
 * Declaration of top entry for this project.
 * CAUTION: DONT MODIFY THE NAME AND I/O DECLARATION.
 */
module I_FormatCPU(
	// Outputs
	output	wire	[31:0]	Output_Addr,
	// Inputs
	input	wire	[31:0]	Input_Addr,
	input	wire			clk
);

wire [31:0] Instruction;
wire RegWrite;
wire MemWrite;
wire MemRead;
wire MemtoReg;
wire RegDst;
wire ALUSrc;
wire [1:0] ALUOp;
wire [5:0] funct;
wire [31:0] Rs_Data;
wire [31:0] Rt_Data;
wire [31:0] Rd_Data;
wire [4:0] Bits5_Mux_out;
wire [31:0]ALU_out;
wire [31:0] Bits32_Mux_out;
wire [31:0] SignExtend_out;
wire [31:0] MemReadData;
	/*
	 * Declaration of Instruction Memory.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	IM Instr_Memory(
		// Outputs
		.Instruction(Instruction),
		// Inputs
		.Instr_Addr(Input_Addr)
	);

	/*
	 * Declaration of Register File.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	RF Register_File(
	// Outputs
	.Rs_Data(Rs_Data),
	.Rt_Data(Rt_Data),
	// Inputs
	.Rd_Data(Rd_Data),
	.Rs_Addr(Instruction[25:21]),
	.Rt_Addr(Instruction[20:16]),
	.Rd_Addr(Bits5_Mux_out),
	.RegWrite(RegWrite),
	.clk(clk)
	);

	/*
	 * Declaration of Data Memory.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	DM Data_Memory(
	// Outputs
	.MemReadData(MemReadData),
	// Inputs
	.MemAddr(ALU_out),
	.MemWriteData(Rt_Data),
	.MemWrite(MemWrite),
	.MemRead(MemRead),
	.clk(clk)
	);

	Control Controller(
		//output
    	.RegWrite(RegWrite),
    	.ALUOp(ALUOp),
    	.RegDst(RegDst),
    	.ALUSrc(ALUSrc),
    	.MemWrite(MemWrite),
    	.MemRead(MemRead),
    	.MemtoReg(MemtoReg),
    	//input
    	.OpCode(Instruction[31:26])
	);

	ALU_Control ALU_Controller(
		//Outputs
		.funct(funct),
		//Inputs
		.funct_ctrl(Instruction[5:0]),
		.ALUOp(ALUOp)
	);

	ALU Arithmetic(
		// Outputs
		.Result(ALU_out),
		// Inputs
		.Src1(Rs_Data),
		.Src2(Bits32_Mux_out),
		.shamt(Instruction[10:6]),
		.funct(funct)
	);

	Adder Addr_Adder(
		//Outputs
		.Output_Addr(Output_Addr),
		//Inputs
		.Src1(Input_Addr),
		.Src2(32'd4)
	);

	SignExtend SignExtension(
		//Outputs
		.out(SignExtend_out),
		//Inputs
		.in(Instruction[15:0])
	);

	Bits5_Mux Bits5_Mux(
		//output
    	.Mux_out(Bits5_Mux_out),
    	//input
    	.Mux_in_0(Instruction[20:16]),
    	.Mux_in_1(Instruction[15:11]),
    	.sel(RegDst)
	);

	Bits32_Mux Bits32_Mux_ALU(
		//output
    	.Mux_out(Bits32_Mux_out),
    	//input
    	.Mux_in_0(Rt_Data),
    	.Mux_in_1(SignExtend_out),
    	.sel(ALUSrc)
	);

	Bits32_Mux Bits32_Mux_Mem(
		//output
    	.Mux_out(Rd_Data),
    	//input
    	.Mux_in_0(ALU_out),
    	.Mux_in_1(MemReadData),
    	.sel(MemtoReg)
	);
endmodule
