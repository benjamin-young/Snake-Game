`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2019 01:43:39
// Design Name: 
// Module Name: Colour_Ctrl
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


module Colour_Ctrl(
    input [2:0] masterState,
    
    input wire [9:0] ADDH,
    input wire [8:0] ADDV,
    
    input reg [11:0] COLOUR_IN,
    output reg [11:0] COLOUR_OUT
    );
    
    
    always@(ADDRH or ADDRV)begin  
        //--drawing squares in corner--
        
        //box 1
        if((ADDRH >= box1X && ADDRH <= box1X+10) && (ADDRV >= 0 && ADDRV <= 10))begin
            COLOUR_IN <= COLOUR_INPUT;
        end
        //box 2
        else if((ADDRH >= 630 && ADDRH <= 645) && (ADDRV >= box2Y && ADDRV <= box2Y+10))begin
            COLOUR_IN <= COLOUR_INPUT;
        end
        //box 3
        else if((ADDRH >= box3X && ADDRH <= box3X+10) && (ADDRV >= 470 && ADDRV <= 480))begin
            COLOUR_IN <= COLOUR_INPUT;
        end
        //box 4   
        else if((ADDRH >= 0 && ADDRH <= 10) && (ADDRV >= box4Y && ADDRV <= box4Y+10))begin
            COLOUR_IN <= COLOUR_INPUT;
        end
    end
    
    
endmodule
