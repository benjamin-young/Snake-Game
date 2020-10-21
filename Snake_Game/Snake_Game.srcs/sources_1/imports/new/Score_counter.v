`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2019 01:02:50
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


module ScoreCounter(
    input CLK,
    input RESET,
    input ENABLE,
    input TARGET_REACHED,
    
    output [3:0] SCORE_BCD0,
    output [3:0] SCORE_BCD1,
    output [3:0] SEG_SELECT,
    output [7:0] DEC_OUT
    
    );
    
    wire Bit17TriggOut;
    wire Bit4_1TriggOut;
    wire Bit4_2TriggOut;
    wire Bit4_3TriggOut;

    
    wire [3:0] DecCount0;
    wire [3:0] DecCount1;

    
    wire [1:0] StrobeCount;
    //17-bit counter
    Generic_counter # ( .COUNTER_WIDTH(25),
                        .COUNTER_MAX(99999)
                        )
                        Bit17Counter (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(1'b1),
                        .TRIG_OUT(Bit17TriggOut)
                        );
   
                        
                        
    Generic_counter # ( .COUNTER_WIDTH(4),
                        .COUNTER_MAX(9)
                        )
                        Bit4Counter2 (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(TARGET_REACHED),
                        .TRIG_OUT(Bit4_2TriggOut),
                        .COUNT(DecCount0)
                        );
    Generic_counter # ( .COUNTER_WIDTH(4),
                        .COUNTER_MAX(9)
                        )
                        Bit4Counter3 (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(Bit4_2TriggOut),
                        .TRIG_OUT(Bit4_3TriggOut),
                        .COUNT(DecCount1)
                        );

    Generic_counter # ( .COUNTER_WIDTH(1),
                        .COUNTER_MAX(1)
                        )
                        Bit2Counter (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(Bit17TriggOut),
                        .TRIG_OUT(),
                        .COUNT(StrobeCount)
                        );
                        
    wire [4:0] DecCountAndDOT0;
    wire [4:0] DecCountAndDOT1;
    
    wire [4:0] MuxOut;
    
    //tiying each of counter outputs with single bit for DOT
    assign DecCountAndDOT0 = {1'b0, DecCount0};
    assign DecCountAndDOT1 = {1'b0, DecCount1};

    assign SCORE_BCD0 = DecCount0;
    assign SCORE_BCD1 = DecCount1;
        
    
    Multiplexer4 Mux4(
            .CONTROL(StrobeCount),
            .IN0(DecCountAndDOT0),
            .IN1(DecCountAndDOT1),
            .OUT(MuxOut)
            );
            
    Seg7Disp SegDisplay(
                      .SEG_SELECT_IN(StrobeCount),
                      .BIN_IN(MuxOut[3:0]),
                      .DOT_IN(MuxOut[4]),
                      .SEG_SELECT_OUT(SEG_SELECT),
                      .DEC_OUT(DEC_OUT)
                      );
              
endmodule
