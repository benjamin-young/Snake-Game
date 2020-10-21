`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2019 00:38:55
// Design Name: 
// Module Name: MasterSM
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


module NavigationSM(
    input BTNU,
    input BTND,
    input BTNR,
    input BTNL,
    
    input SCORE,
    
    input RESET,
    input CLK,
    
    output [2:0] STATE_OUT
    );
      
        
reg [2:0] curr_state = 3'd0;
reg [2:0] next_state;

assign STATE_OUT = curr_state;
 
//-------------STATE MACHINE LOGIC-------------//
 
//sequential logic
always@(posedge CLK) begin
    if(RESET) begin
        curr_state <= 3'b00;
    end
    
    else begin
        curr_state <= next_state;
    end
end

//combinatorial logic
always@(curr_state or BTNL or BTNR or BTND or BTNU ) begin
    case (curr_state)
        
        //UP: 0
        //RIGHT: 1
        //DOWN: 2
        //LEFT: 3
        
        //UP
        3'd0    : begin
            if( BTNR )
                next_state <= 3'd1;
            else if( BTNL )
                next_state <= 3'd3;
            else
                next_state <= curr_state;
        end
        
        //RIGHT
        3'd1    : begin
            if( BTNU )
                next_state <= 3'd0;
            else if( BTND )
                next_state <= 3'd2;
           else
               next_state <= curr_state;
        end
        
        //DOWN
        3'd2    : begin
            if( BTNR ) 
               next_state <= 3'd1;
            else if( BTNL )
               next_state <= 3'd3; 
           else
               next_state <= curr_state;
        end
        //LEFT
        3'd3    : begin
            if( BTNU )
                 next_state <= 3'd0;
            else if( BTND )
                 next_state <= 3'd2;          
            else
                next_state <= curr_state;
        end
        
  
    endcase
end
         
    
endmodule
