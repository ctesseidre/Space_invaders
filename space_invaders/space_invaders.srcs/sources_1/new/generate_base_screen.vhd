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
        addr_in   : in std_logic_vector(13 downto 0);
        data_out   : out std_logic_vector(2 downto 0)
    );
end generate_base_screen;

architecture Behavioral of generate_base_screen is

    constant DISTANCE_BORD_H    : integer := 5;
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
    signal cpt_mem_alien  : integer;
    signal cpt_mem_ship  : integer;

    signal pos_ship : integer := 75;

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

    -- -- Traitement de la ligne
    process(clk_in)
    begin
        if (clk_in'event and clk_in = '1') then
            if(addr_in = "00000000000000") then
                ligne_actuelle <= 1;
            elsif(to_integer(unsigned(addr_in)) = (ligne_actuelle*SIZE_SCREEN_H)) then
                ligne_actuelle <= ligne_actuelle + 1;
            end if;                   
        end if;
    end process;    
    
    process(clk_in)
    variable cnt_mem_alien : integer := 0;
    variable cnt_mem_ship  : integer := 0;
    begin
        if (clk_in'event and clk_in = '1') then
            if(en_gen_in = '1') then

                -- Alien processing
                if((ligne_actuelle >= DISTANCE_BORD_V) and (ligne_actuelle <= (DISTANCE_BORD_V + SIZE_MEM_V - 1))) then -- On se positionne verticalement
                    if((to_integer(unsigned(addr_in))-((ligne_actuelle-1)*SIZE_SCREEN_H)) >= DISTANCE_BORD_H) then  -- Puis horizontalement
                        -- Positionnement à interval régulier --> Premier pixexl à 5, l'autre à 25, l'autre à 45 ...
                        if((to_integer(unsigned(addr_in))-((ligne_actuelle-1)*SIZE_SCREEN_H)) = DISTANCE_BORD_H) then   
                            cnt_mem_alien := 0;
                        elsif (cnt_mem_alien = DISTANCE_ENTRE_ALIENS) then
                            cnt_mem_alien := 0;
                        else
                            cnt_mem_alien := cnt_mem_alien + 1;
                        end if;
                        -- Remplissage de data_out avec la mémoire alien
                        if(cnt_mem_alien < SIZE_MEM_H) then 
                            data_out    <= alien(cnt_mem_alien + (SIZE_MEM_H*(ligne_actuelle-1)));
                        else
                            data_out    <= BLACK;
                        end if;
                    else
                        data_out    <= BLACK;
                    end if;

                -- Ship processing
                elsif ((ligne_actuelle >= (SIZE_SCREEN_V - SIZE_MEM_V - DISTANCE_BORD_V)) and (ligne_actuelle < (SIZE_SCREEN_V - DISTANCE_BORD_V))) then -- positionnement vertical
                    if (((to_integer(unsigned(addr_in))-((ligne_actuelle-1)*SIZE_SCREEN_H)) >= pos_ship) and (to_integer(unsigned(addr_in))-((ligne_actuelle-1)*SIZE_SCREEN_H) <= pos_ship+SIZE_MEM_H))  then -- Positionnement horizontal
                        -- Positionnement du début du navire
                        if ((to_integer(unsigned(addr_in))-((ligne_actuelle-1)*SIZE_SCREEN_H)) = pos_ship) then
                            cnt_mem_ship := 0;
                        elsif ( (to_integer(unsigned(addr_in))-((ligne_actuelle-1)*SIZE_SCREEN_H)) <= (pos_ship+SIZE_MEM_H) ) then 
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

                else
                    data_out    <= BLACK;
                end if;
            end if;
            cpt_mem_alien <= cnt_mem_alien;
            cpt_mem_ship <= cnt_mem_ship;
        end if;
    end process;

    mouvement_vaisseau : process(rst_in, clk_in)
    begin
        if (rst_in = '1') then
            -- reset des positions
            pos_ship <= 75;
        elsif (clk_in'event and clk_in='1') then
            if (dep_gauche_in = '1') then -- Gauche
                if(pos_ship >= DISTANCE_BORD_H) then
                    pos_ship <= pos_ship - 5;
                end if;
            elsif (dep_droite_in = '1') then -- Droite
                if(pos_ship <= (SIZE_SCREEN_H - DISTANCE_BORD_H - 1))then
                    pos_ship <= pos_ship + 5;
                end if;
            end if;
        end if;
    end process;
    

end Behavioral;