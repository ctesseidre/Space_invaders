----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: gestion_jeu_tb - Behavioral
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

entity gestion_jeu_tb is
--  Port ( );
end gestion_jeu_tb;

architecture Behavioral of gestion_jeu_tb is

    signal clk_in        : std_logic;
    signal rst_in        : std_logic;
    signal dep_gauche_in : std_logic;
    signal dep_droite_in : std_logic;
    signal en_memory_out : std_logic;
    signal addr_mem_out  : std_logic_vector(13 downto 0);
    signal color_out     : std_logic_vector(2 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    dut : entity work.gestion_jeu
    port map (
        clk_in        => clk_in,
        rst_in        => rst_in,
        dep_gauche_in => dep_gauche_in,
        dep_droite_in => dep_droite_in,
        en_memory_out => en_memory_out,
        addr_mem_out  => addr_mem_out,
        color_out     => color_out
    );

    -- Reset generation
    rst_in <= '1', '0' after CLK_PERIOD*5;

    -- Main clock 100Mhz
    process
    begin
        clk_in	<=	'1'; wait for CLK_PERIOD/2;
        clk_in	<=	'0'; wait for CLK_PERIOD/2;
    end process;

    dep_gauche_in   <= '0';
    dep_droite_in   <= '0';

end Behavioral;
