----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 14:16:31
-- Design Name: 
-- Module Name: detect_re - Behavioral
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

entity detect_re is
    Port ( 
        rst_in  : in std_logic;
        clk_in  : in std_logic;
        bp_in   : in std_logic_vector(2 downto 0);
        detect_re   : out std_logic_vector(2 downto 0)
    );
end detect_re;

architecture Behavioral of detect_re is

    signal poussoir_gauche_retard   : std_logic := '0';
    signal poussoir_haut_retard		: std_logic := '0';
    signal poussoir_droite_retard	: std_logic := '0';

begin

    process(rst_in, clk_in)
    begin
        if(rst_in = '1') then

            detect_re   <= (others =>'0');

		elsif(clk_in'event and clk_in = '1') then

            poussoir_gauche_retard  <= bp_in(0);
            poussoir_haut_retard	<= bp_in(1);
            poussoir_droite_retard  <= bp_in(2);

            if(poussoir_gauche_retard = '0' and bp_in(0) = '1') then
                detect_re(0)    <= '1';
            else
                detect_re(0)    <= '0';
            end if;
            
            if(poussoir_haut_retard = '0' and bp_in(1) = '1') then
                detect_re(1)    <= '1';
            else
                detect_re(1)    <= '0';
            end if;
            
            if(poussoir_droite_retard = '0' and bp_in(2) = '1') then
                detect_re(2)    <= '1';
            else
                detect_re(2)    <= '0';
            end if;
            
        end if;
    end process;
end Behavioral;
