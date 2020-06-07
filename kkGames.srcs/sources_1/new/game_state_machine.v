`timescale 1ns / 1ps

module game_state_machine(
        input clk, 
        input [7:0]keyboard,
        input home_on, attack_on,
        //input enter_fight_state,
        output reg video_home_on,video_attack_on //output [1:0] state
    );
    integer state = 0;
    integer state_divider = 0;
	always @ (posedge clk) begin
	       state_divider = (state_divider + 1) % 2500000;
	end
    always @(posedge clk) begin
      if (state_divider==0) begin
        // enter key
        if (keyboard  == 8'h0D && video_home_on == 1) begin
            state = (state + 1)%2 ;
        end
      end
        
        
        /*
        if (home_on==0 && dodge_on==0) begin
            video_home_on = 1;
            video_dodge_on = 0;
        end
        if (btnC == 1 && home_on) begin
            video_home_on = 0;
            video_dodge_on = 1;
        end*/
       
    end
    
    always @*
	case (state)
	   0: begin 
	       video_home_on = 1; 
	       video_attack_on =0; 
	       end
	   1:begin 
	       video_home_on = 0; 
	       video_attack_on =1; 
	       end
	
	endcase
    
    
    
    
    //wire home_state =1;
    //wire fight_state ;
    //wire [1:0] state = {home_state,fight_state};
    
    
    //assign state = (enter_fight_state == 1 ) ? {home_state,1} : {home_state,0};
    
    
    /*
    always @(posedge clk) begin
    
    case(state)
        2'b10: begin
               if (state_change)
               state = 2'b00;
               fight_state = 1;
               end
        
        default : 2'b10;
    endcase
    
    
    end*/
    
    
    
endmodule
