`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2019 06:11:45 PM
// Design Name: 
// Module Name: Basic_state_machine
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


module basic_state_machine(
    input           CLK,
    input           RESET,
    input           BTNL,
    input           BTNC,
    input           BTNR,
    output [2:0]    STATE_OUT
    );
    
    
    reg [2:0] Next_state_Mem [0:63];
    reg [2:0] Curr_state;
    
    initial $readmemb("SM_mem.list", Next_state_Mem);
    
    always @(posedge CLK) begin
        if(RESET)
            Curr_state <= 3'h0;
        else
            Curr_state <= Next_state_Mem[{Curr_state, BTNR, BTNC, BTNL}];
    end
    
    assign STATE_OUT = Curr_state;
    
    
endmodule
