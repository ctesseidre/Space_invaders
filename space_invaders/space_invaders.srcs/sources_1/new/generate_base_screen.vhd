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
        en_gen_in : in std_logic;
        addr_in   : in std_logic_vector(13 downto 0);
        data_out   : out std_logic_vector(2 downto 0)
    );
end generate_base_screen;

architecture Behavioral of generate_base_screen is

    constant DISTANCE_BORD_H    : integer := 5;
    constant DISTANCE_BORD_V    : integer := 0;
    constant DISTANCE_ENTRE_ALIENS : integer := 13;

    constant SIZE_ALIEN_H : integer := 11;
    constant SIZE_ALIEN_V : integer := 8;

    constant SIZE_SCREEN_H : integer := 160;
    constant SIZE_SCREEN_V : integer := 100;

    constant BLACK : std_logic_vector := "000";
    constant WHITE : std_logic_vector := "111";
    constant GREEN : std_logic_vector := "010";

    signal ligne_actuelle   : integer;
    signal cpt_mem  : integer;

    type alien_memory is array (0 to SIZE_ALIEN_H*SIZE_ALIEN_V-1) of std_logic_vector(2 downto 0);
    signal alien : alien_memory := (
        "000", "000", "000", "111", "000", "000", "111", "000", "000", "000", "000", 
        "000", "000", "000", "111", "000", "000", "111", "000", "000", "000", "000", 
        "000", "000", "000", "111", "111", "111", "111", "111", "000", "000", "000", 
        "000", "000", "111", "000", "111", "111", "000", "111", "000", "000", "000", 
        "000", "111", "111", "111", "111", "111", "111", "111", "111", "000", "000", 
        "000", "111", "111", "111", "111", "111", "111", "111", "111", "000", "000", 
        "000", "000", "000", "111", "000", "000", "111", "000", "000", "000", "000", 
        "000", "000", "000", "111", "000", "000", "111", "000", "000", "000", "000"
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
    
    -- Alien processing
    process(clk_in)
    variable cnt_mem_alien : integer := 0;
    begin
        if (clk_in'event and clk_in = '1') then
            if(en_gen_in = '1') then
                if((ligne_actuelle >= DISTANCE_BORD_V) and (ligne_actuelle <= (DISTANCE_BORD_V + SIZE_ALIEN_V - 1))) then -- On se positionne verticalement
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
                        if(cnt_mem_alien < SIZE_ALIEN_H) then 
                            data_out    <= alien(cnt_mem_alien + (SIZE_ALIEN_H*(ligne_actuelle-1)));
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
            cpt_mem <= cnt_mem_alien;
        end if;
    end process;  

    -- Ship processing
    process
    begin
        
    end process;

    

end Behavioral;
