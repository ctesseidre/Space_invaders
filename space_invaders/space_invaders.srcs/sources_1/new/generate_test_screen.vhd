----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2021 10:45:18
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
library xil_defaultlib;
use xil_defaultlib.space_invaders_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity generate_test_screen is
  Port ( clk     : in std_logic;
         rst     : in std_logic;
         en_gen  : in std_logic;
         addr    : in std_logic_vector(13 downto 0);
         data_out: out screen_memory
        );
end generate_test_screen;

architecture Behavioral of generate_test_screen is
signal sig_data_out : screen_memory;
begin
    
    process(clk, rst)
    begin
    
     if (rst = '1') then
        for i in 0 to 15999 loop
            sig_data_out(i) <= "111"; -- Blanc
        end loop;
     elsif (clk'event and clk = '1') then 
        if en_gen = '1' then
            if( to_integer(unsigned(addr)) mod 20 = 0 ) then
                sig_data_out(to_integer(unsigned(addr))) <= "010";-- Vert
            else
                sig_data_out(to_integer(unsigned(addr))) <= "111";-- Blanc
            end if; 
        end if;
     end if;
    end process;
   
    data_out <= sig_data_out;
    
end Behavioral;
