`timescale 1ns / 1ps

module attack_state_machine(
        input clk, 
        input [7:0]keyboard,
        input fight_on, dodge_on,
        //input enter_fight_state,
        output reg video_fight_on,video_dodge_on //output [1:0] state
    );
    integer state = 0;
    integer state_divider = 0;
    
	always @ (posedge clk) begin
	       state_divider = (state_divider + 1) % 2500000;
	end
	
    always @(posedge clk) 
        begin
            if (state_divider==0) 
                begin
                    // space key
                    if (keyboard  == 8'h20) 
                        begin
                            state = 1;
                        end  
                end
        end
    
    always @*
        begin
           case (state)
               0: begin 
                   video_fight_on = 1; 
                   video_dodge_on =0; 
               end
               1: begin 
                   video_fight_on = 0; 
                   video_dodge_on =1; 
               end
           endcase
        end
    
endmodule
