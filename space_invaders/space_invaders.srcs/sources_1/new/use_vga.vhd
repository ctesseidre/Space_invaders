----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: vide - Behavioral
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

entity use_vga is
    Port ( 
        --Inputs
        clk_in      : in std_logic;
        rst_in      : in std_logic;
        data_write  : in std_logic;
        -- Outputs
        VGA_hs       : out std_logic;   -- horisontal vga syncr.
        VGA_vs       : out std_logic;   -- vertical vga syncr.
        VGA_red      : out std_logic_vector(3 downto 0);   -- red output
        VGA_green    : out std_logic_vector(3 downto 0);   -- green output
        VGA_blue     : out std_logic_vector(3 downto 0)   -- blue output
    );
end use_vga;

architecture Behavioral of use_vga is

    signal addr     : std_logic_vector(13 downto 0);
    signal data     : std_logic_vector(2 downto 0);
    signal init_cpt : std_logic;

begin

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
        ADDR       => addr,
        data_in    => "101",
        data_write => data_write,
        data_out   => data
    );

    inst_cpt : entity work.compteur_generique
    generic map(NbBit => 14)
    port map (
        rst_in => rst_in,      
        clk_in => clk_in,  
        clk_enable_in => '1',  
        init_in => init_cpt,     
        load_in => '0',     
        enable_in => '1',   
        data_in => (others => '0'),     
        data_out => addr 
    );

    process(rst_in, clk_in)
    begin
        if (rst_in = '1') then
            init_cpt <= '1';
        elsif (clk_in'event and clk_in = '1') then 
            if (addr < x"3E80") then
                init_cpt <= '0';
            else
                init_cpt <= '1';
            end if;
        end if;
    end process;

end Behavioral;
