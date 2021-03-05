----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:54:24
-- Design Name: 
-- Module Name: use_vga_tb - Behavioral
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

entity use_vga_tb is
--  Port ( );
end use_vga_tb;

architecture Behavioral of use_vga_tb is

    signal clk_in     : std_logic;
    signal rst_in     : std_logic;
    signal data_write : std_logic;
    signal VGA_hs     : std_logic;
    signal VGA_vs     : std_logic;
    signal VGA_red    : std_logic_vector (3 downto 0);
    signal VGA_green  : std_logic_vector (3 downto 0);
    signal VGA_blue   : std_logic_vector (3 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    dut : entity work.use_vga
    port map (clk_in     => clk_in,
              rst_in     => rst_in,
              data_write => data_write,
              VGA_hs     => VGA_hs,
              VGA_vs     => VGA_vs,
              VGA_red    => VGA_red,
              VGA_green  => VGA_green,
              VGA_blue   => VGA_blue
    );

    rst_in <= '1', '0' after 3*CLK_PERIOD;

    clk_gen : process
    begin
        clk_in	<=	'1'; wait for CLK_PERIOD/2;
        clk_in	<=	'0'; wait for CLK_PERIOD/2;
    end process;

    data_write  <= '1';

end Behavioral;
