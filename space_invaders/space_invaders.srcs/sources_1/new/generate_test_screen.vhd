----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: generate_test_screen - Behavioral
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
library xil_defaultlib;
use xil_defaultlib.space_invaders_package.all;

entity generate_test_screen is
    Port ( 
        rst_in  : in std_logic;
        clk_in  : in std_logic;
        en_clear_in : in std_logic;
        end_gen_out   : out std_logic;
        memory_out  : out screen_memory
    );
end generate_test_screen;

architecture Behavioral of generate_test_screen is

    signal en_cnt   : std_logic := '0';
    signal addr     : std_logic_vector(13 downto 0); -- A changer si format différent de 160*100

begin

    inst_cpt : entity xil_defaultlib.compteur_generique
    generic map(NbBit => 14)
    port map (
        rst_in => rst_in,      
        clk_in => clk_in,  
        clk_enable_in => '1',  
        init_in => '0',     
        load_in => '0',     
        enable_in => en_cnt,   
        data_in => (others => '0'),     
        data_out => addr 
    );

    process(rst_in, clk_in)
    begin
        if(rst_in = '1') then 

            en_cnt  <= '0';
            end_gen_out   <= '0';

        elsif (clk_in'event and clk_in = '1') then

            if(en_clear_in = '1') then
                en_cnt  <= '1';
            elsif(addr >= std_logic_vector(to_unsigned(15999, 14))) then
                memory_out(to_integer(unsigned(addr)))  <= "000";
                en_cnt  <= '0';
                end_gen_out   <= '1';
            elsif(to_integer(unsigned(addr)) mod 20 = 0) then
                memory_out(to_integer(unsigned(addr)))  <= "010";
            end if;
    
        end if; 

    end process;

end Behavioral;
