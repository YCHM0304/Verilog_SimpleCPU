/*
 *	Template for Project 2 Part 1
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
module R_FormatCPU(
	// Outputs
	output	wire	[31:0]	Output_Addr,
	// Inputs
	input	wire	[31:0]	Input_Addr,
	input	wire			clk
);

wire [31:0] Instruction;
wire RegWrite;
wire [1:0] ALUOp;
wire [5:0] funct;
wire [31:0]Rs_Data;
wire [31:0]Rt_Data;
wire [31:0]Rd_Data;

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
		.Rd_Addr(Instruction[15:11]),
		.RegWrite(RegWrite),
		.clk(clk)
	);

	ALU Arithmetic(
		// Outputs
		.Result(Rd_Data),
		// Inputs
		.Src1(Rs_Data),
		.Src2(Rt_Data),
		.shamt(Instruction[10:6]),
		.funct(funct)
	);

	Control Controller(
		// Outputs
		.ALUOp(ALUOp),
		.RegWrite(RegWrite),
		// Inputs
		.OpCode(Instruction[31:26])
	);

	ALU_Control ALU_Controller(
		//Outputs
		.funct(funct),
		//Inputs
		.funct_ctrl(Instruction[5:0]),
		.ALUOp(ALUOp)
	);

	Adder Addr_Adder(
		//Outputs
		.Output_Addr(Output_Addr),
		//Inputs
		.Src1(Input_Addr),
		.Src2(32'd4)
	);
endmodule
