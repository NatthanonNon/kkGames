module pink_block_rom(
    input wire clk,
	input wire [3:0] row,
	input wire [2:0] col,
	output reg [11:0] color_data
    );
  (* rom_style = "block" *)
  
	reg [3:0] row_reg;
	reg [2:0] col_reg;

	always @(posedge clk)
		begin
		row_reg <= row;
		col_reg <= col;
		end
	always @*
	casez ({row_reg, col_reg})
	7'bzzzzzzz : color_data = 12'b111111111111 ;
	
	endcase
endmodule
