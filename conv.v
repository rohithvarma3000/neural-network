`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2020 10:09:05 PM
// Design Name: 
// Module Name: conv
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


module conv(
input        i_clk,
input [(INTEGER_BITS+FIXED_POINT_BITS)*9-1:0] i_pixel_data,
input        i_pixel_data_valid,
input kernel_reset,
input [(INTEGER_BITS+FIXED_POINT_BITS)*9-1:0]kernel_vals,
output reg [INTEGER_BITS+FIXED_POINT_BITS-1:0] o_convolved_data,
output reg   o_convolved_data_valid
    );

    parameter INTEGER_BITS = 8;
parameter FIXED_POINT_BITS = 4;
    
integer i; 
reg [INTEGER_BITS+FIXED_POINT_BITS-1:0] kernel [8:0];
reg [(INTEGER_BITS+FIXED_POINT_BITS)*2-1:0] multData[8:0];
reg [(INTEGER_BITS+FIXED_POINT_BITS)*2-1:0] sumDataInt;
reg [(INTEGER_BITS+FIXED_POINT_BITS)*2-1:0] sumData;
reg [(INTEGER_BITS+FIXED_POINT_BITS)*2-1:0] temp1;
reg [(INTEGER_BITS+FIXED_POINT_BITS)*2-1:0] temp2;
reg multDataValid;
reg sumDataValid;
reg convolved_data_valid;

always @(posedge kernel_reset) begin
    kernel[0] = kernel_vals[(INTEGER_BITS+FIXED_POINT_BITS)*9-1:(INTEGER_BITS+FIXED_POINT_BITS)*8];
    kernel[1] = kernel_vals[(INTEGER_BITS+FIXED_POINT_BITS)*8-1:(INTEGER_BITS+FIXED_POINT_BITS)*7];
    kernel[2] = kernel_vals[(INTEGER_BITS+FIXED_POINT_BITS)*7-1:(INTEGER_BITS+FIXED_POINT_BITS)*6];
    kernel[3] = kernel_vals[(INTEGER_BITS+FIXED_POINT_BITS)*6-1:(INTEGER_BITS+FIXED_POINT_BITS)*5];
    kernel[4] = kernel_vals[(INTEGER_BITS+FIXED_POINT_BITS)*5-1:(INTEGER_BITS+FIXED_POINT_BITS)*4];
    kernel[5] = kernel_vals[(INTEGER_BITS+FIXED_POINT_BITS)*4-1:(INTEGER_BITS+FIXED_POINT_BITS)*3];
    kernel[6] = kernel_vals[(INTEGER_BITS+FIXED_POINT_BITS)*3-1:(INTEGER_BITS+FIXED_POINT_BITS)*2];
    kernel[7] = kernel_vals[(INTEGER_BITS+FIXED_POINT_BITS)*2-1:(INTEGER_BITS+FIXED_POINT_BITS)*1];
    kernel[8] = kernel_vals[(INTEGER_BITS+FIXED_POINT_BITS)*1-1:0];
end   
    
always @(posedge i_clk)
begin
    for(i=0;i<9;i=i+1)
    begin
        multData[i] <= kernel[i]*i_pixel_data[i*(INTEGER_BITS+FIXED_POINT_BITS):(i+1)*(INTEGER_BITS+FIXED_POINT_BITS)];
    end
    multDataValid <= i_pixel_data_valid;
end


always @(*)
begin
    sumDataInt = 0;
    for(i=0;i<9;i=i+1)
    begin
        sumDataInt = sumDataInt + multData[i];
    end
end

always @(posedge i_clk)
begin
    sumData <= sumDataInt;
    sumDataValid <= multDataValid;
end
    
always @(posedge i_clk)
begin
    temp1 = sumData >> 3;
    temp2 = temp1 + sumData;
    o_convolved_data = temp2[INTEGER_BITS+2*FIXED_POINT_BITS-1:FIXED_POINT_BITS-1];
    o_convolved_data_valid <= sumDataValid;
end
    
endmodule
