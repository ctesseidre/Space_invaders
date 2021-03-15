----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: compteur_modulo_tb - Behavioral
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

entity compteur_modulo_tb is
--  Port ( );
end compteur_modulo_tb;

architecture Behavioral of compteur_modulo_tb is

    signal rst_in    : std_logic;
    signal clk_in    : std_logic;
    signal init_in   : std_logic;
    signal load_in   : std_logic;
    signal enable_in : std_logic;
    signal data_in   : std_logic_vector (13 downto 0);
    signal data_out  : std_logic_vector (13 downto 0);

    constant CLK_PERIOD : time := 10 ns; 

begin

    inst : entity work.compteur_modulo
    generic map(MAX_VALUE => 15999)
    port map (rst_in    => rst_in,
              clk_in    => clk_in,
              init_in   => init_in,
              load_in   => load_in,
              enable_in => enable_in,
              data_in   => data_in,
              data_out  => data_out);

    rst_in <= '1', '0' after 3*CLK_PERIOD;

    clk_gen : process
    begin
        clk_in	<=	'1'; wait for CLK_PERIOD/2;
        clk_in	<=	'0'; wait for CLK_PERIOD/2;
    end process;

    process
    begin
        data_in <= std_logic_vector(to_unsigned(15990, 14));
        load_in <= '0';
        init_in <= '0';
        enable_in   <= '0';
        wait until rst_in = '0';
        -- Load test OK
        wait for 3*CLK_PERIOD;
        load_in <= '1';
        wait for CLK_PERIOD;
        load_in <= '0';
        -- Load test KO
        data_in <= std_logic_vector(to_unsigned(16300, 14));
        wait for 3*CLK_PERIOD;
        load_in <= '1';
        wait for CLK_PERIOD;
        load_in <= '0';
        -- -- Init test
        -- wait for 3*CLK_PERIOD;
        -- init_in <= '1';
        -- wait for CLK_PERIOD;
        -- init_in <= '0';
        -- Enable test
        wait for 3*CLK_PERIOD;
        enable_in <= '1';
        -- End
        wait;
    end process;

end Behavioral;
