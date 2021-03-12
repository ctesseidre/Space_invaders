-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 24.2.2021 08:05:02 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_compteur_generique is
end tb_compteur_generique;

architecture tb of tb_compteur_generique is
    
    signal MAX           : integer := 6;
    
    signal rst_in        : std_logic;
    signal clk_enable_in : std_logic;
    signal clk_in        : std_logic;
    signal init_in       : std_logic;
    signal load_in       : std_logic;
    signal enable_in     : std_logic;
    signal data_in       : std_logic_vector (MAX-1 downto 0);
    signal data_out      : std_logic_vector (MAX-1 downto 0);

begin

    inst_cpt : entity work.compteur_generique
    generic map(NbBit => MAX)
    port map (rst_in        => rst_in,
              clk_enable_in => clk_enable_in,
              clk_in        => clk_in,
              init_in       => init_in,
              load_in       => load_in,
              enable_in     => enable_in,
              data_in       => data_in,
              data_out      => data_out);
              
    -- Clock generation
    process
    begin
            clk_in    <=    '0'; wait for 10 ns;
            clk_in    <=    '1'; wait for 10 ns;
    end process;
    
    
    
        -- EDIT Adapt initialization as needed
        rst_in <= '1', '0' after 30 ns;
        clk_enable_in <= '1', '0' after 60 ns, '1' after 90 ns;
        init_in <= '0', '1' after 300 ns;
        load_in <= '0', '1' after 120 ns, '0' after 150 ns;
        enable_in <= '1', '0' after 200 ns, '1' after 230 ns; 
        data_in <= "001000";
  
        

end tb;
