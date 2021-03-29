----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: gestion_jeu - Behavioral
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

entity gestion_jeu is
    Port ( 
        -- Inputs
        clk_in  : in std_logic;
        rst_in  : in std_logic;
        dep_gauche_in   : in std_logic;
        dep_droite_in   : in std_logic;
        shoot_in        : in std_logic;
        -- Outputs
        en_memory_out   : out std_logic;
        addr_mem_out    : out std_logic_vector(13 downto 0);
        color_out       : out std_logic_vector(2 downto 0)
    );
end gestion_jeu;

architecture Behavioral of gestion_jeu is

    signal addr_cnt : std_logic_vector(13 downto 0);
    signal en_memory : std_logic;

    signal bp_in            : std_logic_vector(2 downto 0);
    signal detect_re        : std_logic_vector(2 downto 0);

begin

    -- Détection d'un front montant sur les boutons poussoir
    bp_in(2)    <= shoot_in;
    bp_in(1)    <= dep_gauche_in;
    bp_in(0)    <= dep_droite_in;

    inst_detect : entity work.detect_re
    port map (
        rst_in    => rst_in,
        clk_in    => clk_in,
        bp_in     => bp_in,
        detect_re => detect_re
    );

    -- Incrémentation des adresses
    compteur_adresses : entity work.compteur_modulo
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

    -- Autorisation de l'écriture en mémoire
    inst_gestion_mem : entity work.gestion_mem
    port map (
        clk_in        => clk_in,
        rst_in        => rst_in,
        en_memory_out => en_memory
    );

    -- Génération de l'écran en mémoire
    inst_generate_base_screen : entity work.generate_base_screen
    port map (
        clk_in      => clk_in,
        rst_in      => rst_in,   
        en_gen_in   => en_memory,
        dep_gauche_in => detect_re(1),
        dep_droite_in => detect_re(0),
        shoot_in      => detect_re(2),
        addr_in     => addr_cnt,
        data_out    => color_out
    );

    -- Temporisation pour la sortie des adresses
    inst_reg_vga : entity work.registre_generique
    generic map(NbBit => 14)
    port map (
        rst_in        => rst_in,
        clk_in        => clk_in,
        init_in       => '0',
        en_in         => '1',
        data_in       => addr_cnt,
        data_out      => addr_mem_out
    );

    -- Temporisation pour la sortie de l'écriture en mémoire
    inst_bascule_memory : entity work.bascule
    port map( rst_in      => rst_in,
            clk_in        => clk_in,
            init_in       => '0',
            en_in         => '1',
            data_in       => en_memory,
            data_out      => en_memory_out
    );

end Behavioral;
