`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2019 15:25:04
// Design Name: 
// Module Name: LED_Display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LED_Display(
    input CLK,
    input [2:0] MASTER_STATE,
    output [7:0] LEDs,
    output reg led_finished
    );
    
    reg ENABLE;
    reg [8:0] LEDOut = 8'b00000000;
    wire Sec;
    
    
    //checks master state machine and starts sequence depending on the state
    always@(posedge CLK)begin
        if(MASTER_STATE == 3)
            ENABLE = 1;
        else begin
            ENABLE = 0;
            
        end      
    end
    
    //counter outputs every second
   Generic_counter # ( .COUNTER_WIDTH(30),
                       .COUNTER_MAX(100000000)
                       )
                       SecTimer (
                       .CLK(CLK),
                       .RESET(RESET),
                       .ENABLE(ENABLE),
                       .TRIG_OUT(Sec)
                       );
    //shift leds              
    always@(posedge CLK)begin
        if(MASTER_STATE != 3)
            LEDOut = 0;
        if(Sec ==1)begin
            if(LEDOut == 0)
                LEDOut = 1;
            else
                LEDOut = LEDOut *2;
        end
    end
    
    //detects when sequence has finished
    always@(posedge CLK)begin
        if(LEDOut > 8'b10000000)
            led_finished = 1;
        else
            led_finished = 0;
    end
    
    assign LEDs = LEDOut;
        
endmodule
