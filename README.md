# Introductory project for CoolRunner-II CPLD Starter Board

It is ideal project for Verilog starters.

What it does?
- It outputs 4-bit binary counters to LD0 to LD3 at 10Hz.

WARNING! It is currently one evening project - so please
be patient and tolerant :-)

Required Hardware:

* [Digilent CoolRunner-II CPLD Starter Board][Digilent CoolRunner-II CPLD Starter Board]:
* A-Male to Mini-B USB cable
  - NOT included
  - It is NOT Micro-B!

Required Software:
* [Xilinx ISE Webpack 14.7][Xilinx ISE Webpack 14.7]
  - I tested "plain" (NOT Windows 10) version under Windows 7 SP1
* [Free Xilinx ISE WebPack license][Free Xilinx ISE WebPack license]

# How it works.

There are only two Verilog files:
- `top.v` - master - the `top` module inputs and outputs are mapped
  to real pins on CPLD. It uses following modules:
  - `CLK_DIV8` - on-chip clock divider by 8x, 1Mhz output is connected
     to internal variable `clk_1mhz`
  - `CD100000` - synchronous cascadable decimal counter, used to
     "divide" 1Mhz to 10Hz. Please note that all counters in cascade
     further use `clk_1mhz`. The "clock division" is realised by
     pulse `CE` (Counter Enable), that is active on every 100_000 Clock
     tick.
   - CB4CE - 4-Bit Cascadable Binary Counter with Clock Enable and Asynchronous Clear` from Xilinx macro library

-  `CB4CE.v` - contains above CB4CE module from Xilinx macro library


* There is only input called `PCLK` (on `GCK2` pin of CoolRunner-II)
  which is on-board 8MHz clock.
* This clock is divided by embedded CoolRunner-II divider by 8 to get
  1MHz internal clock signal 
* There is then internal counter to 100_000 (to get 10Hz on `CEO` - Counter
  enable output)
* and there finaly 4-bit counter CB4CE - it's output drives 4 dedicated
  LEDs on board...

# How to Synthesize (build programming file)

* Open project `crnr-ii-intro.xise` in `ISE Project Navigator`
* ensure that file `top (top.v)` is selected `Hierarchy` - that
  one right under `xc2c256-7TQ144` item.
* Double-click on `Implmenet Design` of Processes Window in Design tab
* it should generate new `top.jed` (JEDEC file) to be pgorammed
  into your CoolRunner-II CPLD.

# How to program

* Run iMPACT, and open its project file `prog-crnrii.ipf`.
* click on menu `Operations` -> `Program`


[Free Xilinx ISE WebPack license]: https://www.xilinx.com/support/licensing_solution_center.html
[Xilinx ISE Webpack 14.7]: https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive-ise.html
[Digilent CoolRunner-II CPLD Starter Board]: https://store.digilentinc.com/coolrunner-ii-cpld-starter-board-limited-time/

