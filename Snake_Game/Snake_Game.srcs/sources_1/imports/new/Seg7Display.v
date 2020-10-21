`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.11.2019 17:21:10
// Design Name: 
// Module Name: Seg7_display
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


module Seg7Disp(
    input [1:0] SEG_SELECT_IN,
input [3:0] BIN_IN,
input DOT_IN,
output reg [3:0] SEG_SELECT_OUT,
output reg [7:0] DEC_OUT
); 

//Segement selection
always@(SEG_SELECT_IN) begin
case(SEG_SELECT_IN)
    2'b00 : SEG_SELECT_OUT<=4'b1110;
    2'b01 : SEG_SELECT_OUT<=4'b1101;
    2'b10 : SEG_SELECT_OUT<=4'b1011;
    2'b11 : SEG_SELECT_OUT<=4'b0111;
    default:SEG_SELECT_OUT<=4'b1111;
endcase
end
//4 bit input to 7-seg display
always@(BIN_IN or DOT_IN)begin
    case(BIN_IN)
        4'h0: DEC_OUT[6:0]<=7'b1000000;
        4'h1: DEC_OUT[6:0]<=7'b1111001;
        4'h2: DEC_OUT[6:0]<=7'b0100100;
        4'h3: DEC_OUT[6:0]<=7'b0110000;
        
        4'h4: DEC_OUT[6:0]<=7'b0011001;
        4'h5: DEC_OUT[6:0]<=7'b0010010;
        4'h6: DEC_OUT[6:0]<=7'b0000010;
        4'h7: DEC_OUT[6:0]<=7'b1111000;
        
        4'h8: DEC_OUT[6:0]<=7'b0000000;
        4'h9: DEC_OUT[6:0]<=7'b0011000;
        /*4'hA: DEC_OUT[6:0]<=7'b0001000;
        4'hB: HEX_OUT[6:0]<=7'b0000011;
        
        4'hC: HEX_OUT[6:0]<=7'b1000110;
        4'hD: HEX_OUT[6:0]<=7'b0100001;
        4'hE: HEX_OUT[6:0]<=7'b0000110;
        4'hF: HEX_OUT[6:0]<=7'b0001110;*/

        default: DEC_OUT[6:0]<=7'b1111111;
endcase

DEC_OUT[7]<=~DOT_IN;
end
endmodule
