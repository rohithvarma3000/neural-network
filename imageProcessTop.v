`timescale 1ns / 1ps

module imageProcessTop #(
    parameter INTEGER_BITS = 9,
    parameter FIXED_POINT_BITS = 4
)(
input   axi_clk,
input   axi_reset_n,
//slave interface
input   i_data_valid,
input [INTEGER_BITS+FIXED_POINT_BITS-1:0] i_data,
input kernel_reset,
input [(INTEGER_BITS+FIXED_POINT_BITS)*9-1:0]kernel_vals,
//output  o_data_ready,
//master interface
output  o_data_valid,
output [(INTEGER_BITS+FIXED_POINT_BITS)*2-1:0] o_data
//input   i_data_ready
    );

wire [(INTEGER_BITS+FIXED_POINT_BITS)*9-1:0] pixel_data;
wire [(INTEGER_BITS+FIXED_POINT_BITS)*4-1:0] pool_input_data;
wire pixel_data_valid;
//wire axis_prog_full;
wire [INTEGER_BITS+FIXED_POINT_BITS-1:0] convolved_data, pool_output;
wire convolved_data_valid, pool_input_data_valid;

//assign o_data_ready = !axis_prog_full;
    
imageControl IC(
    .i_clk(axi_clk),
    .i_rst(!axi_reset_n),
    .i_pixel_data(i_data),
    .i_pixel_data_valid(i_data_valid),
    .o_pixel_data(pixel_data),
    .o_pixel_data_valid(pixel_data_valid),
    .o_intr(o_intr)
  );    
  
 conv conv(
     .i_clk(axi_clk),
     .i_pixel_data(pixel_data),
     .i_pixel_data_valid(pixel_data_valid),
     .kernel_reset(kernel_reset),
    .kernel_vals(kernel_vals),
     .o_convolved_data(convolved_data),
     .o_convolved_data_valid(convolved_data_valid)
 ); 
 
poolControl PC(
    .reset(!axi_reset_n),
    .o_convolved_data(convolved_data),
    .o_convolved_data_valid(convolved_data_valid),
    .clk(axi_clk),
    .pool_input_data(pool_input_data),
    .pool_input_data_valid(pool_input_data_valid)
);

max_pool_2 pool(
    .clk(axi_clk),
    .data(pool_input_data),
    .out(pool_output)
);

neural_network nn(
    .i_clk(axi_clk),
    .i_reset(!axi_reset_n),
    .pool_output(pool_output),
    .pool_output_valid(pool_input_data_valid),
    .neurons(o_data),
    .output_valid(o_data_valid)
);
    
endmodule
