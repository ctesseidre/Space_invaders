----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: generate_base_screen - Behavioral
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
library work;

entity generate_base_screen is
    Port ( 
        clk_in  : in std_logic;
        rst_in  : in std_logic;
        en_gen_in : in std_logic;
        dep_gauche_in   : in std_logic;
        dep_droite_in   : in std_logic;
        shoot_in        : in std_logic;
        addr_in   : in std_logic_vector(13 downto 0);
        data_out   : out std_logic_vector(2 downto 0)
    );
end generate_base_screen;

architecture Behavioral of generate_base_screen is

    constant DISTANCE_BORD_H    : integer := 6;
    constant DISTANCE_BORD_V    : integer := 0;
    constant DISTANCE_ENTRE_ALIENS : integer := 13;

    constant SIZE_MEM_H : integer := 11;
    constant SIZE_MEM_V : integer := 8;

    constant SIZE_SCREEN_H : integer := 160;
    constant SIZE_SCREEN_V : integer := 100;

    constant BLACK : std_logic_vector := "000";
    constant WHITE : std_logic_vector := "111";
    constant GREEN : std_logic_vector := "010";

    signal ligne_actuelle   : integer;
    signal colonne_actuelle : integer;
    signal cpt_mem_alien    : integer;
    signal cpt_mem_ship     : integer;

    signal pos_ship : integer := 75;
    signal pos_shoot, save_pos_shoot, pos_shoot_H : integer := 0;

    signal init_cpt, en_cpt : std_logic;
    signal cpt    : std_logic_vector(24 downto 0);
    signal mort_alien : std_logic_vector(10 downto 0);

    type memory is array (0 to SIZE_MEM_H*SIZE_MEM_V-1) of std_logic_vector(2 downto 0);
    
    signal alien : memory := (
        "000", "000", "111", "000", "000", "000", "000", "000", "111", "000", "000", 
        "000", "000", "000", "111", "000", "000", "000", "111", "000", "000", "000", 
        "000", "000", "111", "111", "111", "111", "111", "111", "111", "000", "000", 
        "000", "111", "111", "000", "111", "111", "111", "000", "111", "111", "000", 
        "111", "111", "111", "111", "111", "111", "111", "111", "111", "111", "111", 
        "111", "000", "111", "111", "111", "111", "111", "111", "111", "000", "111", 
        "111", "000", "111", "000", "000", "000", "000", "000", "111", "000", "111", 
        "000", "000", "000", "111", "111", "000", "111", "111", "000", "000", "000"
    );

    signal ship : memory := (
        "000", "000", "000", "000", "000", "000", "000", "000", "000", "000", "000", 
        "000", "000", "000", "000", "000", "000", "000", "000", "000", "000", "000", 
        "000", "000", "000", "000", "000", "010", "000", "000", "000", "000", "000", 
        "000", "000", "000", "000", "010", "010", "010", "000", "000", "000", "000", 
        "000", "000", "000", "000", "010", "010", "010", "000", "000", "000", "000", 
        "000", "010", "010", "010", "010", "010", "010", "010", "010", "010", "000", 
        "000", "010", "010", "010", "010", "010", "010", "010", "010", "010", "000", 
        "000", "010", "010", "010", "010", "010", "010", "010", "010", "010", "000"
    );



begin

    -- Traitement de la ligne et de la colonne
    process(clk_in)
    begin
        if (clk_in'event and clk_in = '1') then
            -- Ligne actuelle
            if(addr_in = "00000000000000") then
                ligne_actuelle <= 1;
            elsif(to_integer(unsigned(addr_in)) = (ligne_actuelle*SIZE_SCREEN_H+1)) then
                ligne_actuelle <= ligne_actuelle + 1;
            end if;  
            -- Colonne actuelle
            if(to_integer(unsigned(addr_in))-((ligne_actuelle-1)*SIZE_SCREEN_H) = 161) then
                colonne_actuelle    <= 1;
            else
                colonne_actuelle    <= (to_integer(unsigned(addr_in))-((ligne_actuelle-1)*SIZE_SCREEN_H));     
            end if;

        end if;
    end process;

    -- -- Traitement de la colonne
    -- process(clk_in)
    -- begin
    --     if (clk_in'event and clk_in = '1') then
    --         colonne_actuelle    <= (to_integer(unsigned(addr_in))-((ligne_actuelle-1)*SIZE_SCREEN_H));
    --     end if;
    -- end process; 
    
    process(clk_in)
    variable cnt_mem_alien : integer := 0;
    variable cnt_mem_ship  : integer := 0;
    variable cnt_alien     : integer := 0;
    begin
        if (clk_in'event and clk_in = '1') then
            if(en_gen_in = '1') then

                -- Alien processing
                if((ligne_actuelle >= DISTANCE_BORD_V) and (ligne_actuelle <= (DISTANCE_BORD_V + SIZE_MEM_V))) then -- On se positionne verticalement
                    if((colonne_actuelle >= DISTANCE_BORD_H) and (colonne_actuelle <= (SIZE_SCREEN_H-DISTANCE_BORD_H))) then  -- Puis horizontalement
                        -- Positionnement à interval régulier --> Premier pixexl à 5, l'autre à 25, l'autre à 45 ...
                        if(colonne_actuelle = DISTANCE_BORD_H) then   
                            cnt_mem_alien := 0;
                            cnt_alien := 0;
                        elsif (cnt_mem_alien = DISTANCE_ENTRE_ALIENS) then
                            cnt_mem_alien := 0;
                            if(cnt_alien < 10) then
                                cnt_alien := cnt_alien+1;
                            end if;
                        else
                            cnt_mem_alien := cnt_mem_alien + 1;
                        end if;

                        -- Remplissage de data_out avec la mémoire alien
                        if(cnt_mem_alien < SIZE_MEM_H) then 
                            if(mort_alien(cnt_alien) = '0') then
                                data_out    <= alien(cnt_mem_alien + (SIZE_MEM_H*(ligne_actuelle-1)));
                            else
                                data_out    <= BLACK;
                            end if;
                        else
                            -- Shoot processing (sur la zone de génération des monstres)
                            if ((ligne_actuelle >= (SIZE_SCREEN_V - DISTANCE_BORD_V - SIZE_MEM_V - pos_shoot - 2)) and (ligne_actuelle <= (SIZE_SCREEN_V - DISTANCE_BORD_V  - SIZE_MEM_V - pos_shoot))) then -- positionnement vertical
                                if (colonne_actuelle = (save_pos_shoot + 5)) then -- Positionnement horizontal
                                    -- Positionnement du début du shoot
                                    data_out    <= WHITE;
                                else
                                    data_out    <= BLACK;
                                end if;
                            else
                                 data_out        <= BLACK;                
                            end if;

                        end if;
                        
                    else
                        data_out    <= BLACK;
                    end if;

                -- Ship processing
                elsif ((ligne_actuelle >= (SIZE_SCREEN_V - SIZE_MEM_V - DISTANCE_BORD_V)) and (ligne_actuelle < (SIZE_SCREEN_V - DISTANCE_BORD_V))) then -- positionnement vertical
                    
                    if ((colonne_actuelle >= pos_ship) and (colonne_actuelle <= pos_ship+SIZE_MEM_H))  then -- Positionnement horizontal
                        -- Positionnement du début du navire
                        if (colonne_actuelle = pos_ship) then
                            cnt_mem_ship := 0;
                        elsif (colonne_actuelle <= (pos_ship+SIZE_MEM_H) ) then 
                            cnt_mem_ship := cnt_mem_ship + 1;
                        end if;

                        -- Remplissage de data_out avec la mémoire
                        if(cnt_mem_ship < SIZE_MEM_H) then
                            data_out    <= ship(cnt_mem_ship + (SIZE_MEM_H*(ligne_actuelle-(SIZE_SCREEN_V - SIZE_MEM_V))));
                        else
                            data_out    <= BLACK;
                        end if;

                    else
                        data_out    <= BLACK;
                    end if;

                -- Shoot processing
                elsif ((ligne_actuelle >= (SIZE_SCREEN_V - DISTANCE_BORD_V - SIZE_MEM_V - pos_shoot - 2)) and (ligne_actuelle <= (SIZE_SCREEN_V - DISTANCE_BORD_V  - SIZE_MEM_V - pos_shoot))) then -- positionnement vertical
                    
                    if (colonne_actuelle = (save_pos_shoot + 5)) then -- Positionnement horizontal
                        -- Positionnement du début du shoot
                        pos_shoot_H <= save_pos_shoot + 5;
                        data_out    <= WHITE;
                    else
                        data_out    <= BLACK;
                    end if;

                else
                    data_out    <= BLACK;
                end if;

            else
                data_out    <= BLACK;
            end if;
        end if;
        cpt_mem_alien <= cnt_mem_alien;
        cpt_mem_ship <= cnt_mem_ship;
    end process;

    mouvement_vaisseau : process(rst_in, clk_in)
    begin
        if (rst_in = '1') then
            -- reset des positions
            pos_ship <= 75;
        elsif (clk_in'event and clk_in='1') then
            if (dep_gauche_in = '1') then -- Gauche
                if(pos_ship >= DISTANCE_BORD_H) then
                    pos_ship <= pos_ship - 1;
                end if;
            elsif (dep_droite_in = '1') then -- Droite
                if(pos_ship <= (SIZE_SCREEN_H - DISTANCE_BORD_H - 1))then
                    pos_ship <= pos_ship + 1;
                end if;
            end if;
        end if;
    end process;
    
    mouvement_shoot : process(rst_in, clk_in)
    begin
        if (rst_in = '1') then
            -- reset des positions
            pos_shoot <= -2;
            en_cpt <= '0';
        elsif (clk_in'event and clk_in='1') then
            init_cpt <= '0';
            if (shoot_in = '1' or en_cpt = '1') then -- Press shoot button
                if(shoot_in = '1') then               
                    save_pos_shoot <= pos_ship;
                end if;
                en_cpt <= '1';
                if (to_integer(unsigned(cpt)) >= 20000000) then
                    init_cpt <= '1';
                    pos_shoot <= pos_shoot + 5;
                elsif (pos_shoot > SIZE_SCREEN_V) then
                    en_cpt <= '0';  
                    pos_shoot <= -2;  
                end if;
            end if;
        end if;
    end process;
    
    inst_cpt_shoot : entity work.compteur_generique
    generic map(NbBit => 25)
    port map (
        rst_in        => rst_in,
        clk_in        => clk_in,
        init_in       => init_cpt,
        load_in       => '0',
        enable_in     => en_cpt,
        data_in       => (others => '0'),
        data_out      => cpt
    );
    
    gestion_mort : process(clk_in, rst_in)
    begin
        
        if (rst_in = '1') then
            mort_alien <= (others => '0');
        elsif (clk_in'event and clk_in='1') then
            -- Verification vertical du shoot
            if (pos_shoot > 90) then 
                -- Verification horizontal du shoot
                                
                if(pos_shoot_H >= 6 and pos_shoot_H <= 16 ) then
                    mort_alien(0) <= '1'; 
                end if;
                
                if(pos_shoot_H >= 20 and pos_shoot_H <= 30) then
                    mort_alien(1) <= '1'; 
                end if;
                
                if(pos_shoot_H >= 34 and pos_shoot_H <= 44) then
                    mort_alien(2) <= '1'; 
                end if;
                
                if(pos_shoot_H >= 48 and pos_shoot_H <= 58) then
                    mort_alien(3) <= '1'; 
                end if;
                
                if(pos_shoot_H >= 62 and pos_shoot_H <= 72) then
                    mort_alien(4) <= '1'; 
                end if;
                
                if(pos_shoot_H >= 76 and pos_shoot_H <= 86) then --- premier
                    mort_alien(5) <= '1'; 
                end if;
                
                if(pos_shoot_H >= 90 and pos_shoot_H <= 100) then
                    mort_alien(6) <= '1'; 
                end if;
                
                if(pos_shoot_H >= 104 and pos_shoot_H <= 114) then
                    mort_alien(7) <= '1'; 
                end if;
                
                if(pos_shoot_H >= 118 and pos_shoot_H <= 128) then
                    mort_alien(8) <= '1'; 
                end if;
                
                if(pos_shoot_H >= 132 and pos_shoot_H <= 142) then
                    mort_alien(9) <= '1'; 
                end if;
                
                if(pos_shoot_H >= 146 and pos_shoot_H <= 156) then
                    mort_alien(10) <= '1'; 
                end if;
            end if;
         end if;              
    end process;

end Behavioral;