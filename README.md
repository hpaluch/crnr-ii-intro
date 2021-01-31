# Introductory project for CoolRunner-II CPLD Starter Board

![CoolRunner-II blinking LEDs](https://raw.githubusercontent.com/hpaluch/crnr-ii-intro/master/assets/coolrunner-ii-in-action.gif)

> NOTE: The LEDs on animated git are swapped (fastest one should be LD0,
> slowest one LD3). It was because I missed that Pin assignment
> table lists MSB and LSB in reverse order (higher bits are first
> in that table)
>
> This bug is fixed in current Design. I will someday update that picture
> too...

It is ideal project for Verilog starters.

What it does?
- It outputs 4-bit binary counter to LD0 to LD3 at 5Hz.
- It also outputs copy of LED signals to Pmod J1 pins 1-4 (IO1-IO4)
  (for monitoring)
- It also outputs internal `internal_ce` signal 
  (short pulse with 10 Hz frequency for chained counters) to
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
  - `CLK_DIV8` - on-chip clock divider by 8x, 1 MHz output is connected
     to internal variable `clk_1mhz`
  - `CD100_000` - synchronous cascadable decimal counter, used to
     "divide" 1 Mhz to 10 Hz. Please note that all counters in cascade
     further use `clk_1mhz`. The "clock division" is realised by
     pulse `CE` (Counter Enable), that is active on every 100_000 Clock
     tick.
   - CB4CE - 4-Bit Cascadable Binary Counter with Clock Enable and Asynchronous Clear` from Xilinx macro library

-  `CB4CE.v` - contains above CB4CE module from Xilinx macro library


* There is only input called `PCLK` (on `GCK2` pin of CoolRunner-II)
  which is on-board 8MHz clock.
* This clock is divided by embedded CoolRunner-II divider by 8 to get
  1 MHz internal clock signal 
* There is then internal counter to 100_000 (to get 10 Hz on `CEO` - Counter
  enable output)
* and there finaly 4-bit counter CB4CE - it's output drives 4 dedicated
  LEDs on board... Please note that the fastest output Q0 divides frequency
  by two(!). So the output LED LD0 does blink at rate 5 Hz instead of 10 Hz.
  See scope results for verification...

# How to Synthesize (build programming file)

* Open project `crnr-ii-intro.xise` in `ISE Project Navigator`
* ensure that file `top (top.v)` is selected `Hierarchy` - that
  one right under `xc2c256-7TQ144` item.
* Double-click on `Implement Design` of Processes Window in Design tab
* it should generate new `top.jed` (JEDEC file) to be programmed
  into your CoolRunner-II CPLD.

# How to program

> WARNING! I have no luck opening provided `prog-crnrii.ipf` - the
> iMPACT always crashed without any notice. Therefore please keep
> "Default" in `Manage Configuration Properties` and always
> configure iMPACT from scratch as shown below:

Ensure that `top (top.v)` node is selected in `Implementation` view and
* double click on Processes -> Implement Design -> Configure Target
  Device -> Manage Configuration Project (iMPACT)
* now click on Edit -> Launch Wizard...
* select 1st option `Configure devices using Boundery-Scan (JTAG)`
  with default listbox `Automatically connect to....`
* confirm Auto Assign pop-up
* select `top.jed` as input file
* click `OK` on `Device Programming Properties`

Now the real stuff:
* click on menu `Operations` -> `Program`
* after few seconds device should be programmed and automatically run
  (so LEDs LD0 to LD3 should blink - each one 2 times slower)

# Measurements

I have started with two channel
scope [Digilent Analog Discovery 2][Digilent Analog Discovery 2]
to:
- verify used logic (it should be 3.3V TTL)
- verify frequencies
- verify noise (high noise means risks of glitches and unexpected
  behaviour of CPLD).

Scope Results are on picture below:

![Scope LEDs LD0 and LD1](https://raw.githubusercontent.com/hpaluch/crnr-ii-intro/master/assets/scope-ld0-ld1.png)

Here are decoded LD0 to LD3 outputs (from CB4CE counter)
using [Digilent Analog Discovery 2][Digilent Analog Discovery 2] in
Logic mode:

![Analyzer LEDs LD0 to LD3](https://raw.githubusercontent.com/hpaluch/crnr-ii-intro/master/assets/analyzer-ld0-ld3.png)

The `DIO 0` (LD0) to `DIO 3` (LD3) is decoded as bus so you can nicely read
total value of CB4CE 4-bit counter.

NOTE: It is tricky to see `internal_ce` signal (shown as `DIO 4`), because:
- it is only 1 us (micro-second) wide, but period is 5Hz (200ms)
- so the analyzer must run in great detail to catch such pulse at all
- but it will not run long enough to see whole period...


# Tips

Where to start? Go to
 - [Digilent CoolRunner-II CPLD Starter Board - Documentation][Digilent CoolRunner-II CPLD Starter Board Support]

There are all imoprtant files:
- Board Schematic
  - https://reference.digilentinc.com/_media/reference/programmable-logic/coolrunner-ii/coolrunner-ii_sch.pdf
- Digilent's demo source code:
  - https://reference.digilentinc.com/_media/reference/programmable-logic/coolrunner-ii/sourcecrii_demo.zip
- Board Reference manual
  - https://reference.digilentinc.com/reference/programmable-logic/coolrunner-ii/reference-manual

TODO: important Xilinx pages

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
[Digilent CoolRunner-II CPLD Starter Board Support]: https://reference.digilentinc.com/reference/programmable-logic/coolrunner-ii/start?redirect=1
[Digilent Analog Discovery 2]: https://store.digilentinc.com/analog-discovery-2-100msps-usb-oscilloscope-logic-analyzer-and-variable-power-supply/
