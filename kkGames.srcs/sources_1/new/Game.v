`timescale 1ns / 1ps



module Game(
    input wire clk,
    input RsRx, //input receving data line
    
    output [7:0]led,
    output wire Hsync, Vsync,
	output wire [3:0] vgaRed,vgaGreen,vgaBlue,
	output RsTx
    );
        
    //receiver receiver (.clk(clk),.btnC(btnC),.RxD(RxD),.RxData(RxData));
    
    //UART TX
    wire tx_idle;
    reg [7:0] tx_data;
    reg tx_transmit;
    uart_transmitter uart_transmitter
    (
        .tx(RsTx),
        .idle(tx_idle),
        .data(tx_data),
        .transmit(tx_transmit),
        .clk(clk)
    );
    
    //UART RX
    wire [7:0] rx_data;
    wire rx_idle;
    wire rx_receive;
    uart_receiver uart_receiver
    (
        .data(rx_data),
        .idle(rx_idle),
        .receive(rx_receive),
        .rx(RsRx),
        .clk(clk)
    );
    
    //UART Controller 
    reg enterKeyIsPress = 0;
    
    always @(posedge clk)
    begin
        if (rx_receive == 1)
        begin
            case (rx_data)
                // enter key
                8'h0D : begin 
                    tx_data = 8'h30; // show 0
                    tx_transmit = 1;
                end
                // w key
                8'h77 : begin 
                    tx_data = 8'h77; // show w
                    tx_transmit = 1;
                end
                // a key
                8'h61 : begin 
                    tx_data = 8'h61; // show a
                    tx_transmit = 1;
                end
                // s key
                8'h73 : begin 
                    tx_data = 8'h73; // show s
                    tx_transmit = 1;
                end
                // d key
                8'h64 : begin 
                    tx_data = 8'h64; // show d
                    tx_transmit = 1;
                end
            endcase
        end
        else tx_transmit = 0;
    end
    
    Display display 
    (
        .clk(clk),
        .keyboard(rx_data),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue));
    
    assign led = rx_data;
    
endmodule
