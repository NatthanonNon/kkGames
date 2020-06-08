`timescale 1ns / 1ps

module fight(
    input clk,
    input wire video_fight_on,
    input [7:0] keyboard,
    input wire [9:0] x, y,
    output wire damage_taken_monster,
    output reg [11:0] rgb_out,
    output reg fight_on
    );
    
    wire [11:0] bar_rgb, attack_bar_rgb;
    wire bar_on, attack_bar_on;
    
    attack_bar attack_bar_unit 
    (
        .clk(clk),
        .video_on(video_fight_on),
        .x(x),
        .y(y),
        .rgb_out(attack_bar_rgb),
        .attack_bar_on(attack_bar_on)
    );
        
	movable_bar movable_bar_1
	(
	   .clk(clk),
	   .keyboard(keyboard),
	   .video_on(video_fight_on), 
	   .x(x), 
	   .y(y),
	   .damage_taken_monster(damage_taken_monster),
	   .rgb_out(bar_rgb),
	   .bar_on(bar_on)
	);  
	
	always @*
		begin
            if (~video_fight_on)
                rgb_out = 12'b0;
                
            else if (bar_on) 
                begin
                    rgb_out = bar_rgb;
                    fight_on = 1;
                end
            else if (attack_bar_on) 
                begin
                    rgb_out = attack_bar_rgb;
                    fight_on = 1;
                end
            else 
                rgb_out = 12'b0;
		end
endmodule