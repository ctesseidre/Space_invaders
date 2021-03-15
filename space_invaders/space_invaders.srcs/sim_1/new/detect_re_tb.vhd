----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 14:17:55
-- Design Name: 
-- Module Name: detect_re_tb - Behavioral
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

entity detect_re_tb is
--  Port ( );
end detect_re_tb;

architecture Behavioral of detect_re_tb is

    signal rst_in    : std_logic;
    signal clk_in    : std_logic;
    signal bp_in     : std_logic_vector (3 downto 0);
    signal detect_re : std_logic_vector (3 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    inst_detect : entity work.detect_re
    port map (
        rst_in    => rst_in,
        clk_in    => clk_in,
        bp_in     => bp_in,
        detect_re => detect_re
    );

    rst_in <= '1', '0' after 3*CLK_PERIOD;

    clk_gen : process
    begin
        clk_in	<=	'1'; wait for CLK_PERIOD/2;
        clk_in	<=	'0'; wait for CLK_PERIOD/2;
    end process;

    process
    begin
        bp_in   <= (others =>'0');
        wait until rst_in = '0';
        bp_in(1)    <= '1';
        wait for 5*CLK_PERIOD;
        bp_in(0)    <= '1';
        wait for 13*CLK_PERIOD;
        bp_in(2)    <= '1';
        wait for 7*CLK_PERIOD;
        wait;
    end process;

end Behavioral;
