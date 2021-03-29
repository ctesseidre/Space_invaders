----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: gestion_mem - Behavioral
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

entity gestion_mem is
    Port ( 
        clk_in  : in std_logic;
        rst_in  : in std_logic;
        en_memory_out   : out std_logic
    );
end gestion_mem;

architecture Behavioral of gestion_mem is

    signal init_cnt : std_logic;
    signal cnt_refresh  : std_logic_vector(15 downto 0);

begin

    inst_cpt_refresh : entity work.compteur_generique
    generic map(NbBit => 16)
    port map (rst_in        => rst_in,
              clk_in        => clk_in,
              init_in       => init_cnt,
              load_in       => '0',
              enable_in     => '1',
              data_in       => (others => '0'),
              data_out      => cnt_refresh);

    process(clk_in, rst_in)
    begin
        if(rst_in = '1') then

            init_cnt <= '1';
            en_memory_out    <= '0';

        elsif (clk_in'event and clk_in = '1') then

            if(cnt_refresh <= std_logic_vector(to_unsigned(15998, 16))) then
                init_cnt    <= '0';
                en_memory_out    <= '1';
            elsif(cnt_refresh < std_logic_vector(to_unsigned(16000*3-3, 16))) then
                init_cnt    <= '0';
                en_memory_out    <= '0';
            elsif(cnt_refresh >= std_logic_vector(to_unsigned(16000*3-3, 16))) then
                init_cnt    <= '1';
                en_memory_out    <= '0';
            end if;
            
        end if;
    end process;

end Behavioral;
