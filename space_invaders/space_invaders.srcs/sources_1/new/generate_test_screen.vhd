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
library work;

entity generate_test_screen is
    Port ( 
        clk_in  : in std_logic;
        en_gen_in : in std_logic;
        addr_in   : in std_logic_vector(13 downto 0);
        data_out   : out std_logic_vector(2 downto 0)
    );
end generate_test_screen;

architecture Behavioral of generate_test_screen is

begin

    -- Memory processing
    process(clk_in)
    begin
        if (clk_in'event and clk_in = '1') then
            if(en_gen_in = '1') then
                if(to_integer(unsigned(addr_in)) mod 20 = 0) then
                    data_out  <= "010"; -- Green
                else
                    data_out  <= "111"; -- White
                end if;
            end if;
        end if;
    end process;   

end Behavioral;
