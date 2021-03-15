----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: affichage - Behavioral
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

entity affichage is
    Port ( 
        -- Inputs
        clk_in  : in std_logic;
        rst_in  : in std_logic;
        r_w_in  : in std_logic;
        data_in : in std_logic_vector(2 downto 0);
        -- Outputs
        addr_out     : out std_logic_vector(13 downto 0);
        VGA_hs       : out std_logic;   -- horisontal vga syncr.
        VGA_vs       : out std_logic;   -- vertical vga syncr.
        VGA_red      : out std_logic_vector(3 downto 0);   -- red output
        VGA_green    : out std_logic_vector(3 downto 0);   -- green output
        VGA_blue     : out std_logic_vector(3 downto 0)   -- blue output
    );
end affichage;

architecture Behavioral of affichage is

    constant NB_BITS_ADDR : integer := 14;

    -- Addr
    signal addr_cnt : std_logic_vector(NB_BITS_ADDR-1 downto 0);
    signal addr_gen : std_logic_vector(NB_BITS_ADDR-1 downto 0);
    signal addr_mem : std_logic_vector(NB_BITS_ADDR-1 downto 0);
    signal addr_vga : std_logic_vector(NB_BITS_ADDR-1 downto 0);
    -- R/W
    signal r_w      : std_logic;
    signal bp_in    : std_logic_vector(2 downto 0);
    signal detect_re   : std_logic_vector(2 downto 0);
    -- VGA
    signal color_mem    : std_logic_vector(2 downto 0);
    signal data_vga : std_logic_vector(2 downto 0);
    signal data_write_vga   : std_logic;

begin

    bp_in(1 downto 0)   <= "00";    -- Not used right now
    bp_in(2)    <= r_w_in;

    inst_detect : entity work.detect_re
    port map (
        rst_in    => rst_in,
        clk_in    => clk_in,
        bp_in     => bp_in,
        detect_re => detect_re
    );

    inst_cpt : entity work.compteur_generique
    generic map(NbBit => NB_BITS_ADDR)
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
        data_write => data_write_vga,
        data_out   => data_vga
    );

    inst_mem : entity work.mem
    generic map(NB_BITS_ADDR => 14)
    port map (
        clk_in        => clk_in,
        en_mem_in     => '1',
        read_write_in => r_w,
        addr_in       => addr_mem,
        data_in       => data_in,
        data_out      => color_mem
    );

    inst_gestion_r_w : entity work.gestion_r_w
    generic map(NB_BITS_ADDR => 14)
    port map (
        clk_in  => clk_in,
        rst_in  => rst_in,
        r_w_in  => detect_re(2),
        addr_in => addr_cnt,
        r_w_out => r_w
    );

    data_write_vga  <= not(r_w);
    addr_out        <= addr_gen;

end Behavioral;
