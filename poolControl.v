`timescale 1ns / 1ps

module poolControl (
    input reset,
    input [INTEGER_BITS+FIXED_POINT_BITS-1:0] o_convolved_data,
    input o_convolved_data_valid,
    input clk,
    output reg [(INTEGER_BITS+FIXED_POINT_BITS)*4-1:0] pool_input_data,
    output reg pool_input_data_valid,
);

    parameter INTEGER_BITS = 9;
    parameter FIXED_POINT_BITS = 4;

    


endmodule