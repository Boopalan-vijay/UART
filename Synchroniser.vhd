library ieee;
use ieee.std_logic_1164.all;

entity Sycnhroniser is
generic(
Ideal:std_logic
);

port(
		clk:in std_logic;
		rst:in std_logic;
		Asycn:in std_logic;
		
		Sycn:out std_logic
		
);
end entity;

architecture rtl of Sycnhroniser is 
signal Reg:std_logic_vector(1 downto 0);
begin 
	Sycn<=Reg(1);
	Synch:process(rst,clk)
		begin
			if (rst='1') then
				Reg<=(others=>Ideal);
			elsif(rising_edge(clk))then
				Reg(0)<=Asycn;
				Reg(1)<=Reg(0);
			end if;	
	end process;
end rtl;