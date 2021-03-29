----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.02.2021 08:47:21
-- Design Name: 
-- Module Name: mem - Behavioral
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

entity mem is
generic(NB_BITS_ADDR : integer := 14);
Port ( 
    -- CLKs
    clk_in  : in std_logic;
    -- Memory functions
    en_mem_in   : in std_logic;
    read_write_in   : in std_logic;
    addr_in     : in std_logic_vector(NB_BITS_ADDR-1 downto 0);
    data_in     : in std_logic_vector(2 downto 0);
    data_out    : out std_logic_vector(2 downto 0)
);
end mem;

architecture Behavioral of mem is

    constant WIDTH_SCREEN : integer := 160;
    constant HEIGHT_SCREEN : integer := 100;
    type screen_memory is array (0 to HEIGHT_SCREEN*WIDTH_SCREEN-1) of std_logic_vector(2 downto 0);
    signal screen : screen_memory;

begin

    process(clk_in)
    begin
        if(clk_in'event and clk_in = '1') then
            if(en_mem_in = '1') then
                if(read_write_in = '1') then
                    screen(to_integer(unsigned(addr_in))) <= data_in;
                else
                    data_out    <= screen(to_integer(unsigned(addr_in)));
                end if;
            end if;
        end if;
    end process;

end Behavioral;