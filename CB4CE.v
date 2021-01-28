// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/ECS/data/hdlMacro/verilog/CB4CE.v,v 1.4 2012/08/30 17:45:42 robh Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2006 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor      : Xilinx
// \   \   \/     Version     : Jade (J.23)
//  \   \         Description : Xilinx HDL Macro Library
//  /   /                       4-Bit Cascadable Binary Counter with Clock Enable and Asynchronous Clear
// /___/   /\     Filename    : CB4CE.v
// \   \  /  \    Timestamp   : Tue Jul 25 2006
//  \___\/\___\
//
// Revision:
//    07/25/06 - Initial version.
// End Revision

`timescale 100 ps / 10 ps

module CB4CE(CEO, Q0, Q1, Q2, Q3, TC, C, CE, CLR);
   
   localparam TERMINAL_COUNT = 4'b1111;
   
   output             CEO;
   output             Q0;
   output             Q1;
   output             Q2;
   output             Q3;
   output             TC;

   input 	      C;	
   input 	      CE;	
   input 	      CLR;	
   
   reg                Q0;
   reg                Q1;
   reg                Q2;
   reg                Q3;
   
   always @(posedge C or posedge CLR)
     begin
	if (CLR)
	  {Q3, Q2, Q1, Q0} <= 4'b0000;
	else if (CE)
	  {Q3, Q2, Q1,Q0} <= {Q3, Q2, Q1,Q0} + 1;
     end
   
   assign CEO = TC & CE;
   assign TC = ({Q3, Q2, Q1, Q0} == TERMINAL_COUNT);
   
endmodule
