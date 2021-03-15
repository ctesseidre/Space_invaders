library ieee;
use ieee.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.space_invaders_package.all;

entity tb_generate_test_screen is
end tb_generate_test_screen;

architecture tb of tb_generate_test_screen is

    signal clk      : std_logic;
    signal rst      : std_logic;
    signal en_gen   : std_logic;
    signal addr     : std_logic_vector (13 downto 0);
    signal data_out : screen_memory;
    
    signal sig_cpt : std_logic_vector(13 downto 0);
begin

    dut : entity work.generate_test_screen
    port map (clk      => clk,
              rst      => rst,
              en_gen   => en_gen,
              addr     => addr,
              data_out => data_out);

    -- Clock generation
    process
    begin
    clk	<=	'1'; wait for 10 ns;
    clk	<=	'0'; wait for 10 ns;
    end process;

    rst <= '1', '0' after 50 ns;
    en_gen <= '1';
    
    inst_cpt : entity work.compteur_generique
    generic map(NbBit => 14)
    port map( rst_in        => rst,
              clk_in        => clk,
              clk_enable_in => '1',
              init_in       => '0',
              load_in       => '0',
              enable_in     => '1',
              data_in       => (others => '0'),
              data_out      => sig_cpt
            );
    addr <= sig_cpt;
end tb;