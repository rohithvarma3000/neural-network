`timescale 1ns / 1ps

module poolBuffer #(
    parameter INTEGER_BITS = 9,
    parameter FIXED_POINT_BITS = 4
)(
input   i_clk,
input   i_rst,
input [INTEGER_BITS+FIXED_POINT_BITS-1:0] i_data,
input   i_data_valid,
output [(INTEGER_BITS+FIXED_POINT_BITS)*2-1:0] o_data,
input i_rd_data
);

reg [INTEGER_BITS+FIXED_POINT_BITS-1:0] line [30:0]; //line buffer
reg [8:0] wrPntr;
reg [8:0] rdPntr;

always @(posedge i_clk)
begin
    if(i_data_valid)
        line[wrPntr] <= i_data;
end

always @(posedge i_clk)
begin
    if(i_rst || wrPntr < 30)
        wrPntr <= 'd0;
    else if(i_data_valid)
        wrPntr <= wrPntr + 'd1;
end

assign o_data = {line[rdPntr],line[rdPntr+1]};

always @(posedge i_clk)
begin
    if(i_rst || rdPntr < 30)
        rdPntr <= 'd0;
    else if(i_rd_data)
        rdPntr <= rdPntr + 'd2;
end


endmodule
