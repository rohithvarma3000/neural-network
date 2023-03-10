`timescale 1ns / 1ps

module compare(input [INTEGER_BITS+FIXED_POINT_BITS-1:0] a, input [INTEGER_BITS+FIXED_POINT_BITS-1:0] b, output reg [INTEGER_BITS+FIXED_POINT_BITS-1:0] c);
    parameter INTEGER_BITS = 9;
    parameter FIXED_POINT_BITS = 4;

    always @(a,b) begin
        if(a[INTEGER_BITS+FIXED_POINT_BITS-1]==0 && b[INTEGER_BITS+FIXED_POINT_BITS-1] == 0) c = (a>b)? a:b;
        else if(a[INTEGER_BITS+FIXED_POINT_BITS-1]==0 && b[INTEGER_BITS+FIXED_POINT_BITS-1] == 1) c = a;
        else if(a[INTEGER_BITS+FIXED_POINT_BITS-1]==1 && b[INTEGER_BITS+FIXED_POINT_BITS-1] == 0) c = b;
        else c = (a>b) ? b : a;
    end
endmodule

module max_pool_2 (input clk, input [(INTEGER_BITS+FIXED_POINT_BITS)*4-1:0] data, output reg [INTEGER_BITS+FIXED_POINT_BITS-1:0] out);
    parameter INTEGER_BITS = 9;
    parameter FIXED_POINT_BITS = 4;
    reg [INTEGER_BITS+FIXED_POINT_BITS-1:0] pool[3:0];

    reg [INTEGER_BITS+FIXED_POINT_BITS-1:0] comp_in1, comp_in2, max;

    wire [INTEGER_BITS+FIXED_POINT_BITS-1:0] comp_out;

    compare com1 (comp_in1, comp_in2, comp_out);

    always @(posedge clk) begin
        pool[0] = data[(INTEGER_BITS+FIXED_POINT_BITS)*4-1:(INTEGER_BITS+FIXED_POINT_BITS)*3];
        pool[1] = data[(INTEGER_BITS+FIXED_POINT_BITS)*3-1:(INTEGER_BITS+FIXED_POINT_BITS)*2];
        pool[2] = data[(INTEGER_BITS+FIXED_POINT_BITS)*2-1:INTEGER_BITS+FIXED_POINT_BITS];
        pool[3] = data[INTEGER_BITS+FIXED_POINT_BITS-1:0];
    end

    always @(posedge clk) begin
        max = 13'b1000000000000;
        comp_in1 = max;
        comp_in2 = pool[0];
        max = comp_out;

        comp_in1 = max;
        comp_in2 = pool[1];
        max = comp_out;

        comp_in1 = max;
        comp_in2 = pool[2];
        max = comp_out;

        comp_in1 = max;
        comp_in2 = pool[3];
        max = comp_out;

        out = max;

    end


endmodule