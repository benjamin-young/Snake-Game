`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2019 01:41:13
// Design Name: 
// Module Name: VGA_Wrapper
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


module VGA_Wrapper(
input CLK,
    input [11:0] COLOUR_SWITCHES,
    output [11:0] COLOUR_OUT,
    output HS,
    output VS
    );
    
    wire [9:0] ADDRH;
    wire [8:0] ADDRV;
    //variable sent to VGA interface module
    reg [11:0] COLOUR_IN;
    //variable can be either switches or changing value
    reg [11:0] COLOUR_INPUT = 12'h000;
    
    VGA_Interface uut(
        .CLK(CLK),
        .COLOUR_IN(COLOUR_IN),
        .ADDRH(ADDRH),
        .ADDRV(ADDRV),
        .COLOUR_OUT(COLOUR_OUT),
        .HS(HS),
        .VS(VS)
        );
        

   
endmodule
