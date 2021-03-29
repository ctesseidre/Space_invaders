----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: generate_base_screen_tb - Behavioral
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

entity generate_base_screen_tb is
--  Port ( );
end generate_base_screen_tb;

architecture Behavioral of generate_base_screen_tb is

    signal clk_in    : std_logic;
    signal rst_in    : std_logic;
    signal en_gen_in : std_logic;
    signal addr_in   : std_logic_vector (13 downto 0) := (others => '0');
    signal data_out  : std_logic_vector (2 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    dut : entity work.generate_base_screen
    port map (
        clk_in    => clk_in,
        rst_in    => rst_in,
        en_gen_in => en_gen_in,
        addr_in   => addr_in,
        data_out  => data_out
    );

    clk_gen : process
    begin
        clk_in	<=	'1'; wait for CLK_PERIOD/2;
        clk_in	<=	'0'; wait for CLK_PERIOD/2;
    end process;

    en_gen_in  <= '1';

    -- process
    -- begin
    --     addr_in <= std_logic_vector(to_unsigned(0, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(0+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(1+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(2+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(3+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(4+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(5+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(6+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(7+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(8+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(9+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(10+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(11+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(12+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(13+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(14+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(15+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(16+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(17+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(18+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(19+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(20+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(21+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(22+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(23+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(24+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(25+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(26+160, 14));
    --     wait for CLK_PERIOD;
    --     addr_in <= std_logic_vector(to_unsigned(27+160, 14));
    --     wait;
    -- end process;

    process
    begin
        addr_in <= std_logic_vector(to_unsigned(0, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(1, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(2, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(3, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(4, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(5, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(6, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(7, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(8, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(9, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(10, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(11, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(12, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(13, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(14, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(15, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(16, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(17, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(18, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(19, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(20, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(21, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(22, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(23, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(24, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(25, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(26, 14));
        wait for CLK_PERIOD;
        addr_in <= std_logic_vector(to_unsigned(27, 14));
        wait;
    end process;

end Behavioral;
