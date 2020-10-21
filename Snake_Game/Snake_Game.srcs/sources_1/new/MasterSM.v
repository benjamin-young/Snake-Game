`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2019 01:13:12
// Design Name: 
// Module Name: NavigationSM
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


module MasterSM(
   input BTNU,
   input BTND,
   input BTNR,
   input BTNL,
   input [3:0] SCORE0,
   input [3:0] SCORE1,
   input RESET,
   input CLK,
   input [3:0] SCORE,
   
   output [2:0] STATE_OUT
   );
        
reg [2:0] curr_state;
reg [2:0] next_state;

assign STATE_OUT = curr_state;


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
always@(curr_state or BTNL or BTNR or BTND or BTNU) begin
   case (curr_state)
       
       //IDLE: 0
       //PLAY: 1
       //WIN: 2
   
       
       //IDLE
       3'd0    : begin
           if( BTNU || BTNR || BTND || BTNL ) begin
               next_state <= 3'd1;
           end
           else begin
               next_state <= curr_state;
           end
       end
       
       
       //PLAY
       3'd1    : begin
          if(SCORE1 == 1 && SCORE0 == 0) begin
              next_state <= 3'd2;
          end
          else
              next_state <= curr_state;
       end
       
       
       //WIN
       3'd2    : begin
          next_state <= curr_state;
       end
 
   endcase
end
        
   
endmodule