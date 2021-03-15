----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: test_vga_tb - Behavioral
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
library xil_defaultlib;
use xil_defaultlib.space_invaders_package.all;

entity test_vga_tb is
--  Port ( );
end test_vga_tb;

architecture Behavioral of test_vga_tb is

    signal clk_in    : std_logic;
    signal rst_in    : std_logic;
    signal bp1_in    : std_logic;
    signal VGA_hs    : std_logic;
    signal VGA_vs    : std_logic;
    signal VGA_red   : std_logic_vector (3 downto 0);
    signal VGA_green : std_logic_vector (3 downto 0);
    signal VGA_blue  : std_logic_vector (3 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    dut : entity work.test_vga
    port map (
        clk_in    => clk_in,
        rst_in    => rst_in,
        bp1_in    => bp1_in,
        VGA_hs    => VGA_hs,
        VGA_vs    => VGA_vs,
        VGA_red   => VGA_red,
        VGA_green => VGA_green,
        VGA_blue  => VGA_blue
    );

    rst_in <= '1', '0' after 3*CLK_PERIOD;

    clk_gen : process
    begin
        clk_in	<=	'1'; wait for CLK_PERIOD/2;
        clk_in	<=	'0'; wait for CLK_PERIOD/2;
    end process;

    process
    begin
        bp1_in  <= '0';
        wait until rst_in = '0';
        wait for 3*CLK_PERIOD;
        bp1_in  <= '1';
        wait for CLK_PERIOD*10;
        bp1_in  <= '0';
        wait;
    end process;

end Behavioral;
