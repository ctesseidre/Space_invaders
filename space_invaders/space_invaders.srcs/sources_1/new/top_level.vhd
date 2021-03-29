----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: top_level - Behavioral
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

entity top_level is
    Port ( 
        -- Inputs
        clk_in  : in std_logic;
        rst_in  : in std_logic;
        dep_gauche_in   : in std_logic;
        dep_droite_in   : in std_logic;
        shoot_in        : in std_logic;
        -- Outputs
        VGA_hs       : out std_logic;   -- horisontal vga syncr.
        VGA_vs       : out std_logic;   -- vertical vga syncr.
        VGA_red      : out std_logic_vector(3 downto 0);   -- red output
        VGA_green    : out std_logic_vector(3 downto 0);   -- green output
        VGA_blue     : out std_logic_vector(3 downto 0)   -- blue output
    );
end top_level;

architecture Behavioral of top_level is

    signal en_memory    : std_logic;
    signal addr_mem     : std_logic_vector(13 downto 0);
    signal color        : std_logic_vector(2 downto 0);

begin

    module_affichage : entity work.affichage
    port map (
        clk_in    => clk_in,
        rst_in    => rst_in,
        r_w_in    => en_memory,
        addr_in   => addr_mem,
        data_in   => color,
        VGA_hs    => VGA_hs,
        VGA_vs    => VGA_vs,
        VGA_red   => VGA_red,
        VGA_green => VGA_green,
        VGA_blue  => VGA_blue
    );

    module_gestion_jeu : entity work.gestion_jeu
    port map (
        clk_in        => clk_in,
        rst_in        => rst_in,
        dep_gauche_in => dep_gauche_in,
        dep_droite_in => dep_droite_in,
        shoot_in      => shoot_in,
        en_memory_out => en_memory,
        addr_mem_out  => addr_mem,
        color_out     => color
    );

end Behavioral;
