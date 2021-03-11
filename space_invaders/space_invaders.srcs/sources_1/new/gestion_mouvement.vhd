----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2021 14:46:07
-- Design Name: 
-- Module Name: gestion_mouvement - Behavioral
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

entity gestion_mouvement is
generic(NbBit : integer := 14);
  Port ( clk         : in std_logic;
         rst         : in std_logic;
         addr_in     : in std_logic_vector(NbBit-1 downto 0);
         dep_gauche  : in std_logic;
         dep_droite  : in std_logic;
         data_out    : out std_logic_vector(2 downto 0)     
       );
end gestion_mouvement;

architecture Behavioral of gestion_mouvement is
signal sig_data_out : std_logic_vector(2 downto 0);
signal cpt : std_logic_vector(NbBit-1 downto 0);
signal pos_monster : integer := 2*WIDTH_SCREEN+10;
signal pos_ship : integer := WIDTH_SCREEN*HEIGHT_SCREEN - 6*WIDTH_SCREEN - 85;
signal mem_monster : monster_memory := ("000", "000", "111", "000", "000", "000", "000", "000", "111", "000", "000",
                                        "000", "000", "000", "111", "000", "000", "000", "111", "000", "000", "000", 
                                        "000", "000", "111", "111", "111", "111", "111", "111", "111", "000", "000", 
                                        "000", "111", "111", "000", "111", "111", "111", "000", "111", "111", "000",
                                        "111", "111", "111", "111", "111", "111", "111", "111", "111", "111", "111",
                                        "111", "000", "111", "111", "111", "111", "111", "111", "111", "000", "111", 
                                        "111", "000", "111", "000", "000", "000", "000", "000", "111", "000", "111", 
                                        "000", "000", "000", "111", "111", "000", "111", "111", "000", "000", "000");
                                        
signal mem_ship : ship_memory := ("000", "000", "000", "000", "111", "000", "000", "000", "000",
                                  "000", "000", "000", "111", "111", "111", "000", "000", "000", 
                                  "000", "000", "000", "111", "111", "111", "000", "000", "000", 
                                  "111", "111", "111", "111", "111", "111", "111", "111", "111",
                                  "111", "111", "111", "111", "111", "111", "111", "111", "111",
                                  "111", "111", "111", "111", "111", "111", "111", "111", "111");
        
        -- faire un signal alife
begin

    inst_cpt : entity work.compteur_generique
    generic map(NbBit => 14)
    port map( rst_in        => rst,
              clk_in        => clk,
              clk_enable_in => '1',
              init_in       => '0',
              load_in       => '1',
              enable_in     => '1',
              data_in       => (others=>'0'),
              data_out      => cpt
             );
    
    Mouvement_Vaisseau : process(rst, clk)
    begin
        if (rst = '1') then
            -- reset des positions
            pos_ship <= WIDTH_SCREEN*HEIGHT_SCREEN - 6*WIDTH_SCREEN - 85;
        elsif (clk'event and clk='1') then
            if (dep_gauche = '1') then -- Gauche
                pos_ship <= pos_ship - 5;
            elsif (dep_droite = '1') then -- Droite
                pos_ship <= pos_ship + 5;
            end if;
        end if;
    end process;

    Affichage_vaisseau : process(clk)
    begin
        if (clk'event and clk='1') then
            if (to_integer(unsigned(addr_in)) = pos_ship) then 
                sig_data_out <= "000";
            end if;
        end if;
    end process;
    
end Behavioral;
