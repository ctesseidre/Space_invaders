----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: mae_auto - Behavioral
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

entity mae_auto is
    Port ( 
        clk_in  : in std_logic;
        rst_in  : in std_logic;
        en_memory_out   : out std_logic
    );
end mae_auto;

architecture Behavioral of mae_auto is

    type state is (init, enabling_memory, disabling_memory);
	signal et_pres, et_suiv : state := init;

    signal init_cnt : std_logic;
    signal cnt_value    : std_logic_vector(22 downto 0);

begin

    compteur_adresses : entity work.compteur_generique
    generic map(NbBit => 23)
    port map (
        rst_in        => rst_in,
        clk_in        => clk_in,
        init_in       => init_cnt,
        load_in       => '0',
        enable_in     => '1',
        data_in       => (others => '0'),
        data_out      => cnt_value
    );

    -- Process maj états futurs
    maj : process (rst_in, clk_in)
    begin
        if (rst_in='1') then
            et_pres <= init;
        elsif (clk_in'event and clk_in='1') then
            if(clk_in = '1') then
                et_pres <= et_suiv;
            end if;
        end if;
    end process;

    -- Process evolution / Cacul des états futurs
    evolution : process (et_pres, cnt_value)
    begin
        case et_pres is
		
		    when init   =>
                et_suiv <= enabling_memory;

            when enabling_memory =>
                if(cnt_value >= std_logic_vector(to_unsigned(10, 23))) then
                    et_suiv <= disabling_memory;
                else
                    et_suiv <= enabling_memory;
                end if;

            when disabling_memory =>
                if(cnt_value >= std_logic_vector(to_unsigned(800000, 23))) then
                    et_suiv <= init;
                else
                    et_suiv <= disabling_memory;
                end if;

            when others =>
                et_suiv <= init;

        end case;
    end process;

    -- Actualisation des sorties
    init_cnt    <=  '1' when et_pres = init else
                    '0';

    en_memory_out   <=  '1' when et_pres = enabling_memory else
                        '0';

end Behavioral;
