----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.02.2021 08:57:50
-- Design Name: 
-- Module Name: registre_generique_tb - Behavioral
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

entity registre_generique_tb is
--  Port ( );
end registre_generique_tb;

architecture Behavioral of registre_generique_tb is

    signal MAX : integer := 3;

    signal rst_in        : std_logic;
    signal clk_in        : std_logic;
    signal init_in       : std_logic := '0';
    signal load_in       : std_logic := '0';
    signal data_in       : std_logic_vector (MAX-1 downto 0) := (others =>'0');
    signal data_out      : std_logic_vector (MAX-1 downto 0);

    constant CLK_PERIOD : time := 10 ns; 

begin

    inst_reg : entity work.registre_generique
    generic map(NbBit => MAX)
    port map (
        rst_in        => rst_in,
        clk_in        => clk_in,
        init_in       => init_in,
        load_in       => load_in,
        data_in       => data_in,
        data_out      => data_out
    );

    -- Reset generation
    rst_in <= '1', '0' after CLK_PERIOD*5;

    -- Main clock 100Mhz
    process
    begin
		clk_in	<=	'1'; wait for CLK_PERIOD/2;
		clk_in	<=	'0'; wait for CLK_PERIOD/2;
	end process;


    -- Registre function generation with MAX = 3
    process
    begin
        wait until rst_in = '0';
        wait for CLK_PERIOD*2;
        data_in <= "010";
        wait for CLK_PERIOD;
        load_in <= '1';
        wait for CLK_PERIOD;
        load_in <= '0';
        wait for CLK_PERIOD*3;
        init_in    <= '1';
        wait for CLK_PERIOD;
        init_in    <= '0';
        wait;
    end process;

    -- -- Registre function generation with MAX = 1
    -- process
    -- begin
    --     wait until rst_in = '0';
    --     wait for CLK_PERIOD*2;
    --     data_in <= "1";
    --     wait for CLK_PERIOD;
    --     load_in <= '1';
    --     wait for CLK_PERIOD;
    --     load_in <= '0';
    --     wait for CLK_PERIOD*3;
    --     init_in    <= '1';
    --     wait for CLK_PERIOD;
    --     init_in    <= '0';
    --     wait;
    -- end process;

end Behavioral;
