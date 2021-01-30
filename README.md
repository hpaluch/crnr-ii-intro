# Introductory project for CoolRunner-II CPLD Starter Board

It is ideal project for Verilog starters.

What it does?
- It outputs 4-bit binary counter to LD0 to LD3 at 10Hz.
- It also outputs copy of LED signal to Pmod J1 pins 1-4 (IO1-IO4)
  (for monitoring)
- It also outputs internal `internal_ce` signal 
  (short pulse with 10Hz frequency for chained counters) to
  Pmod J1 Pin 7 (IO7)

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
* Double-click on `Implement Design` of Processes Window in Design tab
* it should generate new `top.jed` (JEDEC file) to be programmed
  into your CoolRunner-II CPLD.

# How to program

Ensure that `top (top.v)` node is selected in `Implementation` view and
* double click on Processes -> Implement Design -> Configure Target
  Device -> Manage Configuration Project (iMpact)
* click on menu `Operations` -> `Program`
* after few seconds device should be programmed and automatically run
  (so LEDs LD0 to LD3 should blink - each one 2 times slower)

# Tips

## How to get Pin mappings

Pins are assigned using Processes -> User Constraints -> Floorplan
IO - Pre-Synthesis. They are stored in file `top.ucf`.

How to know mappings on Starter Board?

Best way is to download Digilent's example source from:
- https://reference.digilentinc.com/_media/reference/programmable-logic/coolrunner-ii/sourcecrii_demo.zip

And look into file `Source\netio.ucf` - which is like:

```
; 8 MHz on-board clock generator
NET 	"CLK"			LOC = "P38"; #PCLK

; on-board LEDs
NET	"LD<0>"		LOC = "P69"; #LD0
NET	"LD<1>"		LOC = "P68"; #LD1
NET	"LD<2>"		LOC = "P66"; #LD2
NET	"LD<3>"		LOC = "P64"; #LD3

; on-board push-buttons
NET 	"BTN<0>" 	LOC = "P143"; #BTN0
NET 	"BTN<1>" 	LOC = "P94"; #BTN1

; on-board switches
NET	"SW<0>"		LOC = "P39";	#SW0
NET	"SW<1>"		LOC = "P124";	#SW1

; segments of 4-digit LED display (+ decimal point?)
NET	"CAT<0>"		LOC = "P56";
NET	"CAT<1>"		LOC = "P53";
NET	"CAT<2>"		LOC = "P60";
NET	"CAT<3>"		LOC = "P58";
NET	"CAT<4>"		LOC = "P57";
NET	"CAT<5>"		LOC = "P54";
NET	"CAT<6>"		LOC = "P61";
NET	"CAT<7>"		LOC = "P59";

; multiplexed common anode for every digit on LED display
NET	"ANO<3>"		LOC = "P130";
NET	"ANO<2>"		LOC = "P129";
NET	"ANO<1>"		LOC = "P128";
NET	"ANO<0>"		LOC = "P126";
```

You can then  enter specific pin name (for example `P38`)
to "Loc" cell of Floorplan editor table. After changing focus
to other row it will automatically fill few other columns (Bank, Function
Block, etc.)

[Free Xilinx ISE WebPack license]: https://www.xilinx.com/support/licensing_solution_center.html
[Xilinx ISE Webpack 14.7]: https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive-ise.html
[Digilent CoolRunner-II CPLD Starter Board]: https://store.digilentinc.com/coolrunner-ii-cpld-starter-board-limited-time/

