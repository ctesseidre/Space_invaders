----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2020 21:46:23
-- Design Name: 
-- Module Name: clock_generator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_generator is
 Port ( 
	clk_in			: 	in std_logic;
	rst_in			:	in std_logic;
	clk_10k_out		: 	out std_logic
 );
end clock_generator;

architecture Behavioral of clock_generator is

	signal val_cnt_10k		: integer;
	signal clk				: std_logic;

begin

----------------------------------------------------	10Khz processing		---------------------------------------------

	process (clk_in, rst_in)
	begin
		if rst_in = '1' then 
			val_cnt_10k	<= 0;
			clk			<=	'0';
		elsif (clk_in'event and clk_in = '1') then
			val_cnt_10k	<=	val_cnt_10k + 1;
			if val_cnt_10k = 199 then	--valeur = 9 999 pour avoir une fréquence de : 10 kHz
				if(clk = '1') then
					clk	<=	'0';
				else
					clk	<=	'1';
				end if;
				val_cnt_10k	<= 0;
			end if;
		end if;
	end process;

	clk_10k_out	<= clk;
	

end Behavioral;
