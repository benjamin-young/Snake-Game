`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2019 00:44:51
// Design Name: 
// Module Name: Target_generator
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
module Target_generator(
        input CLK,
        input RESET,
        input TARGET_REACHED,
        input [2:0] MasterState,
        output [7:0] TARGET_X,
        output [6:0] TARGET_Y 
    );
    
    reg [7:0] X_reg;
    reg [6:0] Y_reg;
    reg [7:0] currentX_reg;
    reg [6:0] currentY_reg;        
    
    reg [7:0] tempX;
    reg [6:0] tempY;
    //x_reg shift
    integer i;
    always@(posedge CLK)begin
        
        tempX[0] = (((tempX[7] ^~ tempX[5]) ^~ tempX[4]) ^~ tempX[3]);
        tempX[7:1]= tempX[6:0];
        
        if(tempX<160)
            X_reg = tempX;
        
    end
    
    //y_reg shift
    integer j;
    always@(posedge CLK)begin
       
        tempY[0] = tempY[6] ^~ tempY[5];
        tempY[6:1]= tempY[5:0];
        
        if(tempY<120)
            Y_reg = tempY;
            
    end
    
    always@(posedge CLK)begin
        if(MasterState== 0 || TARGET_REACHED)begin
            currentX_reg = X_reg;
            currentY_reg = Y_reg;
        end
    end 
    
    assign TARGET_X = currentX_reg;
    assign TARGET_Y = currentY_reg;
endmodule
