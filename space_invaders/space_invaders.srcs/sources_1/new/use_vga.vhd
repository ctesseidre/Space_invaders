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
library xil_defaultlib;
use xil_defaultlib.space_invaders_package.all;

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
        r_w         : in std_logic;
        -- Outputs
        VGA_hs       : out std_logic;   -- horisontal vga syncr.
        VGA_vs       : out std_logic;   -- vertical vga syncr.
        VGA_red      : out std_logic_vector(3 downto 0);   -- red output
        VGA_green    : out std_logic_vector(3 downto 0);   -- green output
        VGA_blue     : out std_logic_vector(3 downto 0)   -- blue output
    );
end use_vga;

architecture Behavioral of use_vga is

    signal sig_cpt, sig_reg      : std_logic_vector(13 downto 0);
    signal sig_r_w               : std_logic;
    signal sig_gen_test, sig_VGA : screen_memory;
begin
    
    inst_cpt : entity work.compteur_generique
    generic map(NbBit => 14)
    port map (
        rst_in => rst_in,      
        clk_in => clk_in,  
        clk_enable_in => '1',  
        init_in => '0',     
        load_in => '0',     
        enable_in => '1',   
        data_in => (others => '0'),     
        data_out => sig_cpt
    );

    inst_reg : entity work.registre
    -- generic map( NbBit => 14) ?
    port map( clk_in   => clk_in,
              rst_in   => rst_in,
              clk_en   => '1',
              init     => '0',
              load     => '1',
              data_in  => sig_cpt,
              data_out => sig_reg
            );

    inst_gestion : entity work.gestion_r_w
    port map( clk_in  => clk_in,
              r_w_in  => r_w,
              addr    => sig_reg,
              r_w_out => sig_r_w
            ); 

    inst_memoire : entity work.inst_memoire
    port map( clk_in   => clk_in,
              r_w      => sig_r_w,
              addr     => sig_reg,
              data_in  => sig_gen_test,
              data_out => sig_VGA
            );

    inst_gen_test : entity work.generate_test_screen
    port map( clk => clk_in,
              rst => rst_in,
              en_gen => sig_r_w,
              addr => sig_reg,
              data_out => sig_gen_test
            );

    inst_vga_160_100 : entity work.VGA_bitmap_160x100
    generic map(bit_per_pixel => 3)
    port map (
        clk        => clk_in,
        reset      => rst_in,
        ADDR       => sig_reg,
        data_in    => sig_VGA(to_integer(unsigned(sig_reg))),
        data_write => '1',
        VGA_hs     => VGA_hs,
        VGA_vs     => VGA_vs,
        VGA_red    => VGA_red,
        VGA_green  => VGA_green,
        VGA_blue   => VGA_blue,
        data_out   => open
    );


end Behavioral;
