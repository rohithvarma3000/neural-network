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

initial
begin
    for(i=0;i<9;i=i+1)
    begin
        kernel[i] = 5'b10000;
    end
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
