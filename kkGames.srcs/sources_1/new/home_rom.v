`timescale 1ns / 1ps

module home_rom(
    input wire clk,
	input wire [8:0] row,
	input wire [9:0] col,
	output reg [11:0] color_data
    );
    (* rom_style = "block" *)
    
    reg [8:0] row_reg;
	reg [9:0] col_reg;

	always @(posedge clk)
		begin
		row_reg <= row;
		col_reg <= col;
		end
    always @*
	case ({row_reg, col_reg})
	   19'bzzzzzzzzzzzzzzzzzzz: color_data = 12'b111110111111;
	
	endcase
endmodule
