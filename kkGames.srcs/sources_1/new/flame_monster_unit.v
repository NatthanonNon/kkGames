`timescale 1ns / 1ps

module flame_monster_unit(
        input wire clk,                    // input clock signal for synchronous ROMs
        input wire video_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,         // output rgb signal for current pixel
        output reg platforms_on            // output signal asserted when vga x/y pixel is within platform location in display area
    );
    reg [7:0] row;
	reg [5:0] col;
	
	
endmodule
