library ieee;
use ieee.std_logic_1164.all;

entity Reciver is
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
end entity;

architecture rtl of Reciver is 
type SM is (idealState,collect_data,ASSERT_IRQ);
signal state :SM;
signal start :std_logic;
signal ready :std_logic;
signal Shift_EN :std_logic;
signal Sycn_RX :std_logic;
signal fallingEdge :std_logic;
signal Sycn_RX_delayed :std_logic;
signal IRQ :std_logic:='0';

	component Baudclk is
		generic(
				bit_period:integer;
				NO_bits:integer;
				RXTX_Select:boolean
				
			);
		
		port(
				start :in std_logic;
				clk:in std_logic;

				rst:in std_logic;
				ready:out std_logic;
				baudclk: out std_logic
		);
	end component;

	component ShiftRegister is
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
	end component;
	
	component Sycnhroniser is 
		generic(
			Ideal:std_logic
		);

		port(
			clk:in std_logic;
			rst:in std_logic;
			Asycn:in std_logic;
			
			Sycn:out std_logic
			
		);
	end component;
	
	begin
	
		baudclk_gen:Baudclk
			generic map(
				bit_period=>bit_period,
				RXTX_Select=>RXTX_Select,
				NO_bits=>No_Bits+1
				
			)
		
		port map(
				start=>start,
				clk=>clk,

				rst=>rst,
				ready=>ready,
				baudclk=> Shift_EN
		);
		
	ShiftReg_instance:ShiftRegister
		generic map(
				Ideal=>Ideal,
				No_Bits=>No_Bits,
				Shift_Direction=>'R'
		)
		port map(
			clk=>clk,
			rst=>rst,
			Din=>Sycn_RX,
			Shift_EN=>Shift_EN,
			
			Dout=>RX_Data
			);
			
			Sycned_instance:sycnhroniser
				generic map(
					Ideal=>Ideal
					)

				port map(
					clk=>clk,
					rst=>rst,
					Asycn=>Din,
					
					Sycn=>Sycn_RX
				);

	NegativeEdge:process(clk,rst)
	begin
		
		if(rising_edge(clk))then
			Sycn_RX_delayed<=Sycn_RX;
				if (Sycn_RX='0' and Sycn_RX_delayed='1') then
					fallingEdge<='1';
				else 
					fallingEdge<='0';
				end if;
		end if;
		end process;
		
	statemachine:process(clk,rst)	
		
			begin
				if(rst='1')then
					start<='0';
					state<=idealState;
				elsif(rising_edge(clk))then
					if Rst_IRQ='1'then
						IRQ<='0';
					end if;	
					
					case state is 
					when idealState=>
						if fallingEdge ='1'then 
							start<='1';
						else 
							start<='0';
						end if;

						if(ready='0')then
							start<='0';
							state<=collect_data;
					end if ;
							
					when collect_data=>
						start<='0';
						if ready<='1' then 
							state<=ASSERT_IRQ;
						end if;	
					when ASSERT_IRQ=>
						IRQ<='1';
						state<=idealState;
					
					when others=>
						state<=idealState;
					
				end case;
			end if ;
			end process;
			end architecture;
