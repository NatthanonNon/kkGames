`timescale 1ns / 1ps

module home(
        input wire clk,                    // input clock signal for synchronous ROMs
        
        input wire video_home_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,         // output rgb signal for current pixel
        output reg home_on            // output signal asserted when vga x/y pixel is within platform location in display area

    );
    wire [11:0] game_title_rgb,name_rgb,enter_rgb;
    wire game_title_on,name_on,enter_on;
    
//    game_title game_title_unit 
//    (
//        .clk(clk),
//        .video_on(video_home_on),
//        .x(x),
//        .y(y),
//        .rgb_out(game_title_rgb),
//        .game_title_on(game_title_on)
//    );
//	name name_unit (.clk(clk),.video_on(video_home_on),.x(x),.y(y),.rgb_out(name_rgb),.name_on(name_on));
//	enter enter_unit (.clk(clk),.video_on(video_home_on),.x(x),.y(y),.rgb_out(enter_rgb),.enter_on(enter_on));

	always @*
	   
		begin
		
		if (~video_home_on)
			rgb_out = 12'b0;
		
//		else if(game_title_on) begin
//               rgb_out = game_title_rgb;
//               home_on = 1;
//        end
        
//        else if(name_on) begin
//               rgb_out = name_rgb;
//               home_on = 1;
//        end
        
//        else if(enter_on) begin
//               rgb_out = enter_rgb;
//               home_on = 1;
//        end
        else
               rgb_out = 12'b111111111111;
               home_on = 1; //
		end
endmodule
