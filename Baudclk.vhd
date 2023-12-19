library ieee;
use ieee.std_logic_1164.all;

entity Baudclk is
		generic(
			RXTX_Select:boolean;
			bit_period:integer;
			No_bits:integer
			
		);
	
port(
			start :in std_logic;
			clk:in std_logic;

			rst:in std_logic;
			ready:out std_logic;
			baudclk: out std_logic
	);
end entity;

architecture rtl of Baudclk is
signal Bit_period_counter :integer range 0 to  bit_period;
signal clock_left:integer range 0 to 15;

begin 	
	
	baudclkgen:process(clk,rst)
		begin 
			
			if rst='1' then
				baudclk<='0';
				Bit_period_counter<=0;
				
			elsif( rising_edge(clk)) then
					if (clock_left>0) then

						if bit_period_counter=bit_period then 
							baudclk<='1';
							bit_period_counter<=0;
							
						else
							baudclk<='0';	
							bit_period_counter<=bit_period_counter+1;
						end if ;
					
					else
					if RXTX_Select= true then
						bit_period_counter<=bit_period/2;
						baudclk<='0';
					else 	
						bit_period_counter<=0;
						baudclk<='0';
					end if;
				
				end if;
	end if;
		end process;
		onoff:process(clk,rst)
		begin	
			if(rising_edge(clk)) then
				if (start='1')then
					clock_left<=No_bits;
				elsif baudclk='1' then 
					clock_left<=clock_left-1;
				end if ;

		
			elsif(rst='1') then	
				clock_left<=0;
			end if;
			end process;
	

	readyonoff:process(rst,clk)
		begin	
		if rst='1' then 
			ready<='1';
		elsif rising_edge(clk)then	
			if start='1' then
				ready<='0';
			end if;
			if(clock_left=0 )then	
				ready<='1';
			else
				ready<='0';
			end if ;
		end if;
		end process;
		
	end architecture;			
