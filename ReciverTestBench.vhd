library ieee;
use ieee.std_logic_1164.all;

entity ReciverTestBench is
generic(
			bit_period:integer:=50000000/112500;
			No_Bits:integer:=8;
			RXTX_Select:boolean:=true;
			Ideal:std_logic:='1'
			);
end entity;

architecture rtl of ReciverTestBench is 


	component Reciver is
		generic(
		bit_period:integer;
		No_Bits:integer;
		RXTX_Select:boolean;
		Ideal:std_logic
		);
	port(
		clk:in std_logic;
		rst:in std_logic;
		Rst_IRQ:in std_logic;
		Din:in std_logic;--Asycn input from the transmitter 
		RX_Data:out std_logic_vector(No_Bits-1 downto 0)
		);
	end component;

	signal clk:std_logic:='0';
	signal rst:std_logic;
	signal Rst_IRQ:std_logic;
	signal RX_Data:std_logic_vector(No_Bits-1 downto 0);
	signal Din:std_logic;
	
	signal PCData      : std_logic_vector(7 downto 0) := x"AA";

	begin
	  Clk <= not Clk after 10ns;
	  
	RX:Reciver
			generic map(
				bit_period=>bit_period,
				No_Bits=>No_Bits,
				RXTX_Select=>RXTX_Select,
				Ideal=>Ideal
				)
			port map(
				clk=>clk,
				rst=>rst,
				Rst_IRQ=>Rst_IRQ,
				Din=>Din,--Asycn input from the transmitter 
				RX_Data=>RX_Data
				);

	 TestProcess:process
    begin
        rst <= '1';
			Din <= '1';--sycn input
        Rst_IRQ <= '0';--rst-irq
        wait for 100ns;
        rst <= '0';
        wait for 100ns;
        
        -- Transmit Start Bit
        Din <= '0';
        wait for 8.7us;
        
        -- Transmit Data Bits LSB first
        Din <= PCData(0);
        wait for 8.7us;
        Din <= PCData(1);
        wait for 8.7us;
        Din <= PCData(2);
        wait for 8.7us;
        Din <= PCData(3);
        wait for 8.7us;
        Din <= PCData(4);
        wait for 8.7us;
        Din <= PCData(5);
        wait for 8.7us;
        Din <= PCData(6);
        wait for 8.7us;
        Din <= PCData(7);
        wait for 8.7us;
        
        -- Transmit Stop Bit
        Din <= '1';
        wait for 8.7us;
        
        wait for 50ns;
        
        wait until rising_edge(Clk);
        Rst_IRQ <= '1';
        wait until rising_edge(Clk);
        Rst_IRQ <= '0';
        
        wait;
    end process;
    
    
end rtl;
