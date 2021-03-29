----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: top_level_tb - Behavioral
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

entity top_level_tb is
--  Port ( );
end top_level_tb;

architecture Behavioral of top_level_tb is

    signal clk_in        : std_logic;
    signal rst_in        : std_logic;
    signal dep_gauche_in : std_logic;
    signal dep_droite_in : std_logic;
    signal shoot_in : std_logic;
    signal VGA_hs        : std_logic;
    signal VGA_vs        : std_logic;
    signal VGA_red       : std_logic_vector (3 downto 0);
    signal VGA_green     : std_logic_vector (3 downto 0);
    signal VGA_blue      : std_logic_vector (3 downto 0);

    constant CLK_PERIOD  : time := 10 ns;

begin

    dut : entity work.top_level
    port map (
        clk_in        => clk_in,
        rst_in        => rst_in,
        dep_gauche_in => dep_gauche_in,
        dep_droite_in => dep_droite_in,
        shoot_in    => shoot_in,
        VGA_hs        => VGA_hs,
        VGA_vs        => VGA_vs,
        VGA_red       => VGA_red,
        VGA_green     => VGA_green,
        VGA_blue      => VGA_blue
    );

    -- Reset generation
    rst_in <= '1', '0' after CLK_PERIOD*5;

    -- Main clock 100Mhz
    process
    begin
        clk_in	<=	'1'; wait for CLK_PERIOD/2;
        clk_in	<=	'0'; wait for CLK_PERIOD/2;
    end process;

    process
    begin
        dep_gauche_in   <= '0';
        dep_droite_in   <= '0';
        shoot_in   <= '0';
        wait until rst_in = '0';
        -- wait for CLK_PERIOD*100000;
        -- dep_gauche_in   <= '1';
        -- wait for CLK_PERIOD;
        -- dep_gauche_in   <= '0';
        wait;
    end process;

end Behavioral;
