----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: clock_generator_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_generator_tb is
--  Port ( );
end clock_generator_tb;

architecture Behavioral of clock_generator_tb is

    signal clk_in      : std_logic;
    signal rst_in      : std_logic;
    signal clk_10k_out : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    inst_clk_gen : entity work.clock_generator
    port map (
        clk_in      => clk_in,
        rst_in      => rst_in,
        clk_10k_out => clk_10k_out
    );

    rst_in <= '1', '0' after 3*CLK_PERIOD;

    clk_gen : process
    begin
        clk_in	<=	'1'; wait for CLK_PERIOD/2;
        clk_in	<=	'0'; wait for CLK_PERIOD/2;
    end process;

end Behavioral;
