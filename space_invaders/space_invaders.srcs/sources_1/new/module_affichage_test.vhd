----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: module_affichage_test - Behavioral
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

entity module_affichage_test is
    Port ( 
        -- Inputs
        clk_in  : in std_logic;
        rst_in  : in std_logic;
        r_w_in  : in std_logic;
        dep_gauche_in   : in std_logic;
        dep_droite_in   : in std_logic;
        shoot_in        : in std_logic;
        -- Outputs
        VGA_hs       : out std_logic;   -- horisontal vga syncr.
        VGA_vs       : out std_logic;   -- vertical vga syncr.
        VGA_red      : out std_logic_vector(3 downto 0);   -- red output
        VGA_green    : out std_logic_vector(3 downto 0);   -- green output
        VGA_blue     : out std_logic_vector(3 downto 0);   -- blue output
        test_mort    : out std_logic_vector(10 downto 0)
    );
end module_affichage_test;

architecture Behavioral of module_affichage_test is

    constant NB_BITS_ADDR : integer := 14;

    -- Addr
    signal addr_cnt : std_logic_vector(NB_BITS_ADDR-1 downto 0);
    signal addr_gen : std_logic_vector(NB_BITS_ADDR-1 downto 0);
    signal addr_mem : std_logic_vector(NB_BITS_ADDR-1 downto 0);
    signal addr_vga : std_logic_vector(NB_BITS_ADDR-1 downto 0);
    -- R/W
    signal r_w  : std_logic;
    signal enable_write_memory  : std_logic;
    signal writing_in_memory    : std_logic;
    signal bp_in    : std_logic_vector(2 downto 0);
    signal bp_in2    : std_logic_vector(2 downto 0);
    signal detect_re  : std_logic_vector(2 downto 0);
    signal detect_re2  : std_logic_vector(2 downto 0);
    signal dep_droite : std_logic;
    signal dep_gauche : std_logic;
    -- VGA
    signal color_gen    : std_logic_vector(2 downto 0);
    signal color_mem    : std_logic_vector(2 downto 0);
    signal data_vga : std_logic_vector(2 downto 0);
    signal data_write_vga   : std_logic;

begin

    bp_in(2)    <= dep_gauche_in;
    bp_in(1)    <= r_w_in;
    bp_in(0)    <= dep_droite_in;
    
    bp_in2(0)    <= shoot_in;
    bp_in2(1)    <= '0';
    bp_in2(2)    <= '0';

    inst_detect : entity work.detect_re
    port map (
        rst_in    => rst_in,
        clk_in    => clk_in,
        bp_in     => bp_in,
        detect_re => detect_re
    );
    
    inst_detect2 : entity work.detect_re
    port map (
        rst_in    => rst_in,
        clk_in    => clk_in,
        bp_in     => bp_in2,
        detect_re => detect_re2
    );

    inst_cpt : entity work.compteur_modulo
    generic map(MAX_VALUE => 15999)
    port map (
        rst_in        => rst_in,
        clk_in        => clk_in,
        init_in       => '0',
        load_in       => '0',
        enable_in     => '1',
        data_in       => (others => '0'),
        data_out      => addr_cnt
    );

    inst_reg_gen : entity work.registre_generique
    generic map(NbBit => NB_BITS_ADDR)
    port map (
        rst_in        => rst_in,
        clk_in        => clk_in,
        init_in       => '0',
        en_in         => '1',
        data_in       => addr_cnt,
        data_out      => addr_gen
    );

    inst_reg_mem : entity work.registre_generique
    generic map(NbBit => NB_BITS_ADDR)
    port map (
        rst_in        => rst_in,
        clk_in        => clk_in,
        init_in       => '0',
        en_in         => '1',
        data_in       => addr_gen,
        data_out      => addr_mem
    );

    inst_reg_vga : entity work.registre_generique
    generic map(NbBit => NB_BITS_ADDR)
    port map (
        rst_in        => rst_in,
        clk_in        => clk_in,
        init_in       => '0',
        en_in         => '1',
        data_in       => addr_mem,
        data_out      => addr_vga
    );

    inst_bascule_memory : entity work.bascule
    port map( rst_in        => rst_in,
            clk_in        => clk_in,
            init_in       => '0',
            en_in         => '1',
            data_in       => r_w,
            data_out      => enable_write_memory
    );

    inst_bascule_vga : entity work.bascule
    port map( rst_in        => rst_in,
            clk_in        => clk_in,
            init_in       => '0',
            en_in         => '1',
            data_in       => enable_write_memory,
            data_out      => writing_in_memory
    );

    inst_vga_160_100 : entity work.VGA_bitmap_160x100
    generic map(bit_per_pixel => 3)
    port map (
        clk        => clk_in,
        reset      => rst_in,
        VGA_hs     => VGA_hs,
        VGA_vs     => VGA_vs,
        VGA_red    => VGA_red,
        VGA_green  => VGA_green,
        VGA_blue   => VGA_blue,
        ADDR       => addr_vga,
        data_in    => color_mem,
        data_write => '1',
        data_out   => data_vga
    );

    inst_mem : entity work.mem
    generic map(NB_BITS_ADDR => 14)
    port map (
        clk_in        => clk_in,
        en_mem_in     => '1',
        read_write_in => r_w,
        addr_in       => addr_mem,
        data_in       => color_gen,
        data_out      => color_mem
    );

    inst_gestion_r_w : entity work.gestion_r_w2
    generic map(NB_BITS_ADDR => 14)
    port map (
        clk_in  => clk_in,
        rst_in  => rst_in,
        r_w_in  => detect_re(1),
        addr_in => addr_cnt,
        r_w_out => r_w
    );

--    inst_generate_test_screen : entity work.generate_test_screen
--    port map (
--        clk_in    => clk_in,
--        en_gen_in => r_w,
--        addr_in   => addr_gen,
--        data_out  => color_gen
--    );

    inst_generate_base_screen : entity work.generate_base_screen
    port map (
        clk_in    => clk_in,
        rst_in => rst_in,   
        en_gen_in => r_w,
        dep_gauche_in => detect_re(2),
        dep_droite_in => detect_re(0),
        shoot_in      => detect_re2(0),
        addr_in   => addr_gen,
        data_out  => color_gen,
        test_mort => test_mort
    );

    data_write_vga  <= not(writing_in_memory);

end Behavioral;
