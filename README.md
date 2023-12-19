Hey guys, im working on UART Recevier side
Here i have explained about the code 

In "Baudclk.vhdl" there is an o/p as baudclk, which is high for 9 pluses (8 bits with 1 start bit) with the gap of 8.6us, ie w.r.t 115200 baud rate,and 50MHz clock. 
The "Ready" is a signal which goes high when all the 9 pluses are generated.

As now i building for "RECEIVER" ,ill be getting data in series , so i built an shift register which  collects data by shifting, Baudclk's output ( 9 pluses) is used as the shiftEN for the shiftreg .

In "recevier.vhdl" i have  instantiated the baudclk and the shiftreg
The data(8 bits) comes as async so to sycn w.r.t i have instantiated Sycnhroniser.

There is state machine in "reciver.vhdl" ie (ideal,collect_data,ASSERT_IRQ).
they Change state from ideal to collect_data ,when the "start=1". 
start is siganl which dectects first bit's(start bit) falling egde and goes high, to dectect falling edge i have created a process.

I want the state to change from "collect_data" to "ASSERT_IRQ" when "ready=1".

**The problem is the state changes happen even when the "ready" is not '1'.and goes to ASSERT_IRQ, from ASSERT_IRQ to ideal and this happens every rising_edge of my clock** 

In the testbench of recevier i have given serial data.

please check the files and i have attached two images ie the wave result
