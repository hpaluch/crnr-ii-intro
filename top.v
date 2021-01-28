`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:44:45 01/28/2021 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(
    input PCLK,
    output [3:0] LEDS
    );

wire q0,q1,q2,q3;
wire clk_1mhz;
wire internal_ce;

assign LEDS = { q3,q2,q1,q0 };

// we use ClockDivier on CoolRunner II to divide input 8MHz (from PCLK) by 8
// to 1Mhz
CLK_DIV8 U1 (
  .CLKIN(PCLK),
  .CLKDV(clk_1mhz)
);

// our counter to 100_000 (divide by 100_000)
// note that we DO NOT generate new clock, but rather
// we generate CEO - Counter Enable Output, wchich can be use by CE Input
// on cascaded counter
CD100000 U2 (
  .C( clk_1mhz ),
  .CEO( internal_ce)
);

//4-Bit Cascadable Binary Counter with Clock Enable and Asynchronous Clear
// Filename    : CB4CE.v 
CB4CE U3 (
  .Q0 ( q0 ),
  .Q1 ( q1 ),
  .Q2 ( q2 ),
  .Q3 ( q3 ),
  .CLR ( 1'd0 ),
  .CE ( internal_ce ),
  .C  ( clk_1mhz)
);


endmodule

// counter by 100_000 - used to "divide" 1 MHz to 10Hz
module CD100000(input C,output CEO);

localparam TERMINAL_COUNT = 17'd99_999; 
reg [17:0] counter_int  = 0; // internal counter

always @(posedge C)
   if (counter_int < TERMINAL_COUNT)
	   counter_int <= counter_int + 1;
	else
	   counter_int <= 17'd0;

assign CEO = ( counter_int == TERMINAL_COUNT );
endmodule
