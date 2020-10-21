`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2019 09:40:45
// Design Name: 
// Module Name: VGA_Interface
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


module VGA_Interface(
    input   CLK,
    input   [11:0] COLOUR_IN,
    
    output reg [9:0] ADDRH,
    output reg [8:0] ADDRV,
    output reg [11:0] COLOUR_OUT,
    output reg HS,
    output reg VS
    );
    //time is vertical lines   
parameter VertTimeToPulseWidthEnd    = 10'd2;
parameter VertTimeToBackPorchEnd    = 10'd31;
parameter VertTimeToDisplayTimeEnd    = 10'd511;
parameter VertTimeToFrontPorchEnd    = 10'd521;

    //time is front horizontal lines
parameter HorzTimeToPulseWidthEnd    = 10'd96;
parameter HorzTimeToBackPorchEnd    = 10'd144;
parameter HorzTimeToDisplayTimeEnd    = 10'd784;
parameter HorzTimeToFrontPorchEnd    = 10'd800;

wire [9:0] HorizontalCount ;
wire [9:0] VerticalCount ;

//downscale clock speed by 4x
Generic_counter # ( .COUNTER_WIDTH(2),
                    .COUNTER_MAX(3)
                    )
                    Slow_Clk (
                    .CLK(CLK),
                    .RESET(1'b0),
                    .ENABLE(1'b1),
                    .TRIG_OUT(slowClk),
                    .COUNT()
                    );
//horizontal counter                    
Generic_counter # ( .COUNTER_WIDTH(10),
                    .COUNTER_MAX(HorzTimeToFrontPorchEnd)
                    )
                    Horizontal_counter (
                    .CLK(CLK),
                    .RESET(1'b0),
                    .ENABLE(slowClk),
                    .TRIG_OUT(HOut),
                    .COUNT(HorizontalCount)
                    );
//vertical counter
Generic_counter # ( .COUNTER_WIDTH(10),
                    .COUNTER_MAX(VertTimeToFrontPorchEnd)
                    )
                    Vertical_counter (
                    .CLK(CLK),
                    .RESET(1'b0),
                    .ENABLE(HOut),
                    .TRIG_OUT(),
                    .COUNT(VerticalCount)
                    );
                    
    //Horizontal sync signal
    always@(posedge CLK) begin
        if(HorizontalCount < HorzTimeToPulseWidthEnd)
            HS <=0;
        else
            HS <=1;   
    end
    
    //Vertical sync signal
    always@(posedge CLK) begin
        if(VerticalCount < VertTimeToPulseWidthEnd)
            VS <=0;
        else
            VS <=1;   
    end
    
    //output in display time
    always@(posedge CLK) begin
        if(((HorizontalCount >= HorzTimeToBackPorchEnd) && (HorizontalCount <= HorzTimeToDisplayTimeEnd)) && 
            ((VerticalCount >= VertTimeToBackPorchEnd) && (VerticalCount <= VertTimeToDisplayTimeEnd)))begin
                COLOUR_OUT <= COLOUR_IN;
        end 
        else begin    
                COLOUR_OUT <= 12'h000;
        end 
    end
    
    //update horizontal address
    always@(posedge CLK) begin
        if(HorizontalCount > HorzTimeToBackPorchEnd && HorizontalCount < HorzTimeToDisplayTimeEnd)begin
            ADDRH <= HorizontalCount - HorzTimeToBackPorchEnd;            
        end 
        else begin    
            ADDRH <= 0;  
        end 
    end
    
    //update vertical address
    always@(posedge CLK) begin
        if(VerticalCount > VertTimeToBackPorchEnd && VerticalCount < VertTimeToDisplayTimeEnd)begin
            ADDRV <= VerticalCount - VertTimeToBackPorchEnd;            
        end 
        else begin    
            ADDRV <= 0;  
        end 
    end
    
    
endmodule
