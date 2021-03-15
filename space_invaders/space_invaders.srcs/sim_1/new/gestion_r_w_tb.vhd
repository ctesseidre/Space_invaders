----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: gestion_r_w_tb - Behavioral
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

entity gestion_r_w_tb is
--  Port ( );
end gestion_r_w_tb;

architecture Behavioral of gestion_r_w_tb is

    signal clk_in  : std_logic;
    signal rst_in  : std_logic;
    signal r_w_in  : std_logic := '1';
    signal addr_in : std_logic_vector (13 downto 0);
    signal r_w_out : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    dut : entity work.gestion_r_w
    generic map(NB_BITS_ADDR => 14)
    port map (clk_in  => clk_in,
              rst_in  => rst_in,
              r_w_in  => r_w_in,
              addr_in => addr_in,
              r_w_out => r_w_out);

    -- Reset generation
    rst_in <= '1', '0' after CLK_PERIOD*5;

    -- Main clock 100Mhz
    process
    begin
		clk_in	<=	'1'; wait for CLK_PERIOD/2;
		clk_in	<=	'0'; wait for CLK_PERIOD/2;
	end process;

    -- Gestion_r_w function
    process
    begin
        -- Init values
        addr_in <= std_logic_vector(to_unsigned(13, 14));
        r_w_in  <= '0';
        -- Reset period
        wait until rst_in = '0';
        wait for 3*CLK_PERIOD;
        -- Write ask --> flag write = '1'
        r_w_in  <= '1';         -- Just un RE
        wait for CLK_PERIOD;
        r_w_in  <= '0';
        -- Beginning of screen = '1' --> r_w_out = '1'
        wait for CLK_PERIOD*5;
        addr_in <= std_logic_vector(to_unsigned(0, 14));
        -- Beginning of screen = '0' --> r_w_out = '0'
        wait for CLK_PERIOD*5;
        addr_in <= std_logic_vector(to_unsigned(16383, 14));
        wait for CLK_PERIOD*5;
        addr_in <= std_logic_vector(to_unsigned(3, 14));
        wait;
    end process;

end Behavioral;
