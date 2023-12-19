library ieee;
use ieee.std_logic_1164.all;

entity ShiftRegister is
generic(
		Ideal:std_logic;
		No_Bits:integer;
		Shift_Direction:character
		);
port(
		clk:in std_logic;
		rst:in std_logic;
		Din:in std_logic;
		Shift_EN:in std_logic;
		
		Dout:out std_logic_vector(No_bits-1 downto 0 )
		);
end entity;


architecture rtl of ShiftRegister is 
begin
			LSB:if Shift_Direction='R' generate
				LSB_RightShift:process(rst,clk)
				begin
					if (rst='1')then
						Dout<=(others=>Ideal);
					elsif(rising_edge(clk))then
						if( shift_EN='1') then 
							Dout<=Din&Dout(Dout'left downto 1);
						end if;
					end if;	
					
				end process;
			end generate;
			MSB:if Shift_Direction='L' generate
				MSB_Leftshift:process(rst,clk)
				begin
					if (rst='1')then
						Dout<=(others=>'0');
					elsif(rising_edge(clk))then
						if( shift_EN='1') then 
							Dout<=Dout(Dout'left-1 downto 0)&Din;
						end if;
					end if;	
					
				end process;
			end generate;	

end architecture;		
		