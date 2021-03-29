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
    generic(NB_BITS_ADDR : integer := 14);
    Port ( 
        -- Inputs
        clk_in  : in std_logic;
        rst_in  : in std_logic;
        r_w_in  : in std_logic; -- Must be kept during 16000*CLK_PERIOD
        addr_in : in std_logic_vector(NB_BITS_ADDR-1 downto 0);
        data_in : in std_logic_vector(2 downto 0);
        -- Outputs
        VGA_hs       : out std_logic;   -- horisontal vga syncr.
        VGA_vs       : out std_logic;   -- vertical vga syncr.
        VGA_red      : out std_logic_vector(3 downto 0);   -- red output
        VGA_green    : out std_logic_vector(3 downto 0);   -- green output
        VGA_blue     : out std_logic_vector(3 downto 0)   -- blue output
    );
end affichage;

architecture Behavioral of affichage is

    signal r_w_vga      : std_logic;
    signal data_write   : std_logic;
    signal addr_vga     : std_logic_vector(NB_BITS_ADDR-1 downto 0);
    signal color_mem    : std_logic_vector(2 downto 0);
    signal data_vga     : std_logic_vector(2 downto 0);
    signal clk_10k      : std_logic;
    signal addr_r       : std_logic_vector(NB_BITS_ADDR-1 downto 0);

begin

    inst_reg_mem_read : entity work.registre_generique
    generic map(NbBit => NB_BITS_ADDR)
    port map (
        rst_in        => rst_in,
        clk_in        => clk_in,
        init_in       => '0',
        en_in         => '1',
        data_in       => addr_in,
        data_out      => addr_r
    );

    inst_mem : entity work.mem_r_w
    generic map(NB_BITS_ADDR => 14)
    port map (
        clk_in        => clk_in,
        en_mem_in     => '1',
        read_write_in => r_w_in,    -- Must be kept during 16000*CLK_PERIOD
        addr_w_in     => addr_in,
        addr_r_in     => addr_r,
        data_in       => data_in,
        data_out      => color_mem
    );

    inst_reg_vga : entity work.registre_generique
    generic map(NbBit => NB_BITS_ADDR)
    port map (
        rst_in        => rst_in,
        clk_in        => clk_in,
        init_in       => '0',
        en_in         => '1',
        data_in       => addr_r,
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
        data_write => '1',
        data_out   => data_vga
    );

end Behavioral;
