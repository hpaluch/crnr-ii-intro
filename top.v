`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Henryk Paluch
// Create Date:  17:44:45 01/28/2021 
// Module Name:  top 
// Project Name: Introducing CoolRunner-II CPLD Starter Board
// Target Devices: XC2C256-7-TQ144
//                 on Digilent CoolRunner-II CPLD Starter Board
// Tool versions: Xilinx ISE WebPack 14.7
// Description: Introductory project - blink 4 on-board LEDs
//////////////////////////////////////////////////////////////////////////////////

// TOP module - input/output binds to CPLD's pins
module top(
    input PCLK,            // on-board 8MHz clock, connected to GCK2 pin
    output [3:0] LEDS,     // on-board LEDs LD0 to LD3
	 output [3:0] J1_IO1_4, // on-board Pmod J1 IO 1 to 4 - copy of LEDs output
    output J1_IO7 // onboard Pmod J1 IO7 - copy of internal_ce
	               // which should be short pulse with 10Hz frequency
    );

wire q0,q1,q2,q3;
wire clk_1mhz;
wire internal_ce;

assign LEDS = { q3,q2,q1,q0 };
assign J1_IO1_4 = LEDS;
assign J1_IO7 = internal_ce;

// we use ClockDivider (called CoolClock) on CoolRunner-II
// to divide input 8MHz (from PCLK) by 8 to 1Mhz
CLK_DIV8 U1 (
  .CLKIN(PCLK),
  .CLKDV(clk_1mhz)
);

// our counter to 100_000 (divide by 100_000)
// note that we DO NOT generate new clock, but rather
// we generate CEO - Counter Enable Output, which can be used by CE Input
// on cascaded counter
CD100_000 U2 (
  .C( clk_1mhz ),    // input 1MHz clock
  .CEO( internal_ce) // output for cascaded counter (Counter Enable)
);

// 4-Bit Cascadable Binary Counter with Clock Enable and Asynchronous Clear
// Filename    : CB4CE.v 
CB4CE U3 (
  .Q0 ( q0 ), // output mapped to LD0
  .Q1 ( q1 ), // output mappped to LD1
  .Q2 ( q2 ), // output mappped to LD2
  .Q3 ( q3 ), // output mappped to LD3
  .CLR ( 1'd0 ), // input - Clear (RESET) - always inactive
  .CE ( internal_ce ), // input - active once per 100 000 Clock ticks
  .C  ( clk_1mhz)      // 1 MHz clock (real output frequency depends on above CE)
);

endmodule

// counter by 100_000 - used to "divide" 1 MHz to 10Hz
// Usage: chained (cascaded) counter should use again C clock as input
//        and additionally connect this CEO to its CE input
module CD100_000(input C,output CEO);

localparam TERMINAL_COUNT = 17'd99_999; 
reg [16:0] counter_int  = 0; // internal counter

always @(posedge C)
   if (counter_int < TERMINAL_COUNT)
	   counter_int <= counter_int + 1;
	else
	   counter_int <= 17'd0;

assign CEO = ( counter_int == TERMINAL_COUNT );
endmodule
