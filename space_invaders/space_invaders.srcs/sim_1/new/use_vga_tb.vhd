library ieee;
use ieee.std_logic_1164.all;

entity tb_use_vga is
end tb_use_vga;

architecture tb of tb_use_vga is -- 4 ms to see data on data_out

    signal clk_in    : std_logic;
    signal rst_in    : std_logic;
    signal rst_out   : std_logic;
    signal VGA_hs    : std_logic;
    signal VGA_vs    : std_logic;
    signal VGA_red   : std_logic_vector (3 downto 0);
    signal VGA_green : std_logic_vector (3 downto 0);
    signal VGA_blue  : std_logic_vector (3 downto 0);


begin

    dut : entity work.use_vga
    port map (clk_in    => clk_in,
              rst_in    => rst_in,
              rst_out   => rst_out,
              VGA_hs    => VGA_hs,
              VGA_vs    => VGA_vs,
              VGA_red   => VGA_red,
              VGA_green => VGA_green,
              VGA_blue  => VGA_blue);

    -- Clock generation
    process
    begin
        clk_in	<=	'1'; wait for 10 ns;
        clk_in	<=	'0'; wait for 10 ns;
    end process;

    rst_in <= '1', '0' after 50 ns;

end tb;