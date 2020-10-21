`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2019 13:49:27
// Design Name: 
// Module Name: Wrapper
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


module Wrapper(
    input CLK,
    input RESET,

    input BTNU,
    input BTND,
    input BTNL,
    input BTNR,
    input SWITCH,    
    output [3:0] SEG_SELECT,
    output [7:0] DEC_OUT,
    output [11:0] COLOUR_OUT,
    output HS,
    output VS,
    
    output [7:0] LEDs
    );
    
    wire [9:0] ADDRH;
    wire [8:0] ADDRV;
    wire [11:0] colour;
    wire [2:0] direction;
    wire [2:0] state;
    wire [7:0] target_x;
    wire [6:0] target_y;
    wire [3:0] score0;
    wire LED_FIN;
    
    //module contains master state machine
MasterSM MSM (
    .BTNU(BTNU),
    .BTND(BTND),
    .BTNL(BTNL),
    .BTNR(BTNR),
    .SCORE0(score0),
    .SCORE1(score1),
    .RESET(RESET),
    .CLK(CLK),
    .STATE_OUT(state),
    .LED_finished(LED_FIN)
    );

//module counts score
ScoreCounter counter(
    .CLK(CLK),
    .RESET(RESET),
    .ENABLE(1'b1),
    .TARGET_REACHED(target_reached),
    .SCORE_BCD0(score0),
    .SCORE_BCD1(score1),
    .SEG_SELECT(SEG_SELECT),
    .DEC_OUT(DEC_OUT)
    );

//generates random target locations
Target_generator TarGen(
    .CLK(CLK),
    .RESET(RESET),
    .TARGET_REACHED(target_reached),
    .MasterState(state),
    .TARGET_X(target_x),
    .TARGET_Y(target_y)
    );
    
//determines the direction of the snake
NavigationSM NavSM(
    .BTNU(BTNU),
    .BTND(BTND),
    .BTNL(BTNL),
    .BTNR(BTNR),        
    .SCORE(1'b1),
    .CLK(CLK),
    .STATE_OUT(direction)
    );
 
//updates the snake location and VGA 
Snake_ctrl snake(
    .CLK(CLK),
    .RESET(RESET),
    .DIRECTION(direction),
    .ADDRV(ADDRV),
    .ADDRH(ADDRH),
    .MASTER_STATE(state),
    .TARGET_X(target_x),
    .TARGET_Y(target_y),
    .SWITCH(SWITCH),
    .TARGET_REACHED(target_reached),
    .colour_in(colour)
    );

//wrties output to VGA
VGA_Interface uut(
    //Clock
    .CLK(CLK),    
    .COLOUR_IN(colour),
    //pixel address
    .ADDRH(ADDRH),
    .ADDRV(ADDRV),
  
    //outputs
    .COLOUR_OUT(COLOUR_OUT),
    .HS(HS),
    .VS(VS)
    );

//outputs to LEDs for LED state
LED_Display LEDDisp(
    .CLK(CLK),
    .MASTER_STATE(state),
    .LEDs(LEDs),
    .led_finished(LED_FIN)
    );

endmodule
