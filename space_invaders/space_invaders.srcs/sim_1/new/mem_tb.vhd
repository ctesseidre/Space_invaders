----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.02.2021 08:47:46
-- Design Name: 
-- Module Name: mem_tb - Behavioral
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

entity mem_tb is
--  Port ( );
end mem_tb;

architecture Behavioral of mem_tb is

    signal NB_BITS      : integer := 14;

    signal clk_in        : std_logic;
    signal en_mem_in     : std_logic;
    signal read_write_in : std_logic;
    signal addr_in       : std_logic_vector (13 downto 0);
    signal data_in       : std_logic_vector (2 downto 0);
    signal data_out      : std_logic_vector (2 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    inst_mem : entity work.mem
    generic map(NB_BITS_ADDR => 14)
    port map (clk_in        => clk_in,
              en_mem_in     => en_mem_in,
              read_write_in => read_write_in,
              addr_in       => addr_in,
              data_in       => data_in,
              data_out      => data_out);

    -- Main clock 100Mhz
    process
    begin
		clk_in	<=	'1'; wait for CLK_PERIOD/2;
		clk_in	<=	'0'; wait for CLK_PERIOD/2;
	end process;

    -- Memory function
    process
    begin

        -- Write addr 9 value 6
        addr_in <= std_logic_vector(to_unsigned(3,14));
        data_in    <= std_logic_vector(to_unsigned(26,3));
        read_write_in    <= '1';
        en_mem_in <= '1';
        wait for CLK_PERIOD*10;

        -- Read addr 3
        addr_in <= std_logic_vector(to_unsigned(3,14));
        read_write_in    <= '0';
        en_mem_in <= '1';
        wait for CLK_PERIOD*5;

        -- Enable memoire
        addr_in <= std_logic_vector(to_unsigned(9,14));
        data_in    <= std_logic_vector(to_unsigned(6,3));
        read_write_in    <= '1';
        en_mem_in <= '0';
        wait for CLK_PERIOD*10;

        -- End
        wait;

    end process;

end Behavioral;
