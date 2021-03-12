----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: generate_test_screen_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library xil_defaultlib;
use xil_defaultlib.space_invaders_package.all;

entity generate_test_screen_tb is
--  Port ( );
end generate_test_screen_tb;

architecture Behavioral of generate_test_screen_tb is

    signal clk_in    : std_logic;
    signal en_gen_in : std_logic;
    signal addr_in   : std_logic_vector (13 downto 0);
    signal data_out  : std_logic_vector (2 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    dut : entity work.generate_test_screen
    port map (clk_in    => clk_in,
              en_gen_in => en_gen_in,
              addr_in   => addr_in,
              data_out  => data_out);

    clk_gen : process
    begin
        clk_in	<=	'1'; wait for CLK_PERIOD/2;
        clk_in	<=	'0'; wait for CLK_PERIOD/2;
    end process;

    process
    begin
        addr_in <= std_logic_vector(to_unsigned(0, 14));
        en_gen_in  <= '0';
        wait for 3*CLK_PERIOD;
        en_gen_in  <= '1';
        wait for CLK_PERIOD*5;
        addr_in <= std_logic_vector(to_unsigned(5, 14));
        wait for CLK_PERIOD*5;
        addr_in <= std_logic_vector(to_unsigned(20, 14));
        wait for CLK_PERIOD*5;
        addr_in <= std_logic_vector(to_unsigned(3, 14));
        wait for CLK_PERIOD*5;
        en_gen_in  <= '0';
        wait;
    end process;

end Behavioral;
