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
        input SWITCH,
        output reg TARGET_REACHED,
        output reg [11:0] colour_in
        //output hitTarget
    );
    
    parameter SnakeLength = 4'd10;
    parameter MaxY = 7'd60;
    parameter MaxX = 8'd80;
    parameter TargetColour = 12'b000000001111;
    parameter BackgroundColour = 12'b111100000000;
    
    reg [7:0] SnakeState_X [0: SnakeLength-1];
    reg [6:0] SnakeState_Y [0: SnakeLength-1];
    reg [7:0] target_x;
    reg [6:0] target_y;
    
    reg [11:0] winColour= 12'h000;
    reg [11:0] SnakeColour= 12'b111100000000;

    wire [27:0] Counter;
    wire Sec;

    
    //downscale clock speed 
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
                    SnakeState_X[PixNo+1] <= 40;
                    SnakeState_Y[PixNo+1] <= 50;
                end
                else if (Counter == 0 && SWITCH == 0) begin
                    SnakeState_X[PixNo+1] <= SnakeState_X[PixNo];
                    SnakeState_Y[PixNo+1] <= SnakeState_Y[PixNo];
                end
            end
        end
    endgenerate
    
    //DRAWS SNAKE
    integer i;
    always@(ADDRH or ADDRV)begin  
        if(MASTER_STATE == 2) begin
            colour_in = winColour;
        end
        //outputs background colour
        else
            colour_in = BackgroundColour;
        for(i=0; i<SnakeLength-1; i=i+1) begin
        //dividing by 8 scles the VGA grid
            if(ADDRH/8 == SnakeState_X[i+1] && ADDRV/8 == SnakeState_Y[i+1] && MASTER_STATE == 1)
                colour_in = SnakeColour;
        end       
        //draws target if in target coords
        if(ADDRH/8 == TARGET_X && ADDRV/8 == TARGET_Y && MASTER_STATE == 1)begin
                colour_in = TargetColour;
        end
    end
    
    //displays colour patern for win screen
    integer n;
    always@(posedge CLK)begin
        if(n%100000000 == 0)begin
            winColour = winColour+5;
        end
        n=n+1;
    end
    
    //second counter
    Generic_counter # ( .COUNTER_WIDTH(30),
                        .COUNTER_MAX(100000000)
                        )
                        SecTimer (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(1'b1),
                        .TRIG_OUT(Sec)
                        );
    
    //RASNDOM SNAKE COLOUR
    //uses shift register to generate random numbers for snake colour
    always@(posedge CLK)begin
        if(Sec==1&&SWITCH==0)begin
            SnakeColour[0] = SnakeColour[11] ^~ SnakeColour[5]^~ SnakeColour[3]^~ SnakeColour[0];
            SnakeColour[11:1]= SnakeColour[10:0];
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
            SnakeState_X[0] <=40;
            SnakeState_Y[0] <=50;
        end
        
        else if(Counter == 0 && MASTER_STATE == 1) begin
            if(SWITCH == 0)begin
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
    end
    
endmodule
