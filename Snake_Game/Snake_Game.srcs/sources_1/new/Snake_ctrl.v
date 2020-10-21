`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2019 01:54:54
// Design Name: 
// Module Name: Snake_ctrl
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


module Snake_ctrl(
        input CLK,
        input RESET,
        input [2:0] DIRECTION,
        input [8:0] ADDRV,
        input [9:0] ADDRH,
        input [2:0] MASTER_STATE,
        input [7:0]  TARGET_X,
        input [6:0]  TARGET_Y,
        output reg TARGET_REACHED,
        output reg [11:0] colour_in
        //output hitTarget
    );
    
    parameter SnakeLength = 4'd10;
    parameter MaxY = 7'd120;
    parameter MaxX = 8'd160;
    
    reg [7:0] SnakeState_X [0: SnakeLength-1];
    reg [6:0] SnakeState_Y [0: SnakeLength-1];
    reg [7:0] target_x;
    reg [6:0] target_y;
    
    reg [11:0] COLOUR_INPUT = 12'h000;

    wire [27:0] Counter;
    
    //downscale clock speed by 4x
    Generic_counter # ( .COUNTER_WIDTH(28),
                        .COUNTER_MAX(10000000)
                        )
                        Slow_Clk (
                        .CLK(CLK),
                        .RESET(1'b0),
                        .ENABLE(1'b1),
                        .TRIG_OUT(),
                        .COUNT(Counter)
                        );


    //Changing the postition of the snake registers
    //Shift the SnakeState X and Y
    
    genvar PixNo;
    generate
        for(PixNo = 0; PixNo<SnakeLength-1; PixNo = PixNo+1)
        begin: PixShift
            always@(posedge CLK) begin
                if(RESET) begin
                    SnakeState_X[PixNo+1] <= 80;
                    SnakeState_Y[PixNo+1] <= 100;
                end
                else if (Counter == 0) begin
                    SnakeState_X[PixNo+1] <= SnakeState_X[PixNo];
                    SnakeState_Y[PixNo+1] <= SnakeState_Y[PixNo];
                end
            end
        end
    endgenerate
    
    //DRAWS SNAKE
    integer i;
    always@(ADDRH or ADDRV)begin  
        colour_in = ~COLOUR_INPUT;
        for(i=0; i<SnakeLength-1; i=i+1) begin
            if(ADDRH/4 == SnakeState_X[i+1] && ADDRV/4 == SnakeState_Y[i+1] && MASTER_STATE == 1)
                colour_in = COLOUR_INPUT;
        end       
        if(ADDRH/4 == TARGET_X && ADDRV/4 == TARGET_Y && MASTER_STATE == 1)begin
                colour_in = COLOUR_INPUT;
        end
    end
    
    //target detection
    always@(posedge CLK)begin
        if(TARGET_REACHED == 1)
            TARGET_REACHED = 0;
        else if(SnakeState_Y[0] == TARGET_Y && SnakeState_X[0] == TARGET_X && MASTER_STATE == 1)begin
            TARGET_REACHED = 1;
        end
        else begin
            TARGET_REACHED = 0;
        end
    end
    
    
    //Replace top snake state with new one based on direction
    
    always@(posedge CLK) begin
        if(RESET) begin
            //set the initial state of the snake
            SnakeState_X[0] <=80;
            SnakeState_Y[0] <=100;
        end
        
        else if(Counter == 0 && MASTER_STATE == 1) begin
            case(DIRECTION)
                //UP
                3'd0   :begin
                    if(SnakeState_Y[0] == 0)
                        SnakeState_Y[0] <= MaxY;
                    else
                        SnakeState_Y[0] <= SnakeState_Y[0] - 1;
                end
                
                //RIGHT        
                3'd1   :begin
                    if(SnakeState_X[0] >= MaxX)
                        SnakeState_X[0] <= 0;
                    else
                        SnakeState_X[0] <= SnakeState_X[0] + 1;
                end       
                
                //DOWN        
                3'd2   :begin
                    if(SnakeState_Y[0] >= MaxY)
                        SnakeState_Y[0] <= 0;
                    else
                        SnakeState_Y[0] <= SnakeState_Y[0] + 1;
                end
                        
                //LEFT
                3'd3   :begin
                    if(SnakeState_X[0] == 0)
                        SnakeState_X[0] <= MaxX;
                    else
                        SnakeState_X[0] <= SnakeState_X[0] - 1;
                end
            endcase
        end
    end
    
endmodule
