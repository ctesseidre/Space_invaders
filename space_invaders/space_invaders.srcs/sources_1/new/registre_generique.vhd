----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2021 10:12:27
-- Design Name: 
-- Module Name: registre_generique - Behavioral
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

entity registre_generique is
generic(NbBit : integer := 8);
Port (
    rst_in      : in std_logic;
    clk_in      : in std_logic;
    init_in     : in std_logic;
    en_in       : in std_logic;
    data_in     : in std_logic_vector(NbBit-1 downto 0);
    data_out    : out std_logic_vector(NbBit-1 downto 0)
);
end registre_generique;

architecture Behavioral of registre_generique is

begin

    process(rst_in, clk_in)
    begin
        if(rst_in = '1') then
            data_out    <= (others=>'0');
        elsif(clk_in'event and clk_in='1') then
            if(init_in = '1') then
                data_out    <= (others=>'0');
            elsif(en_in = '1') then
                data_out    <= data_in;
            end if;
        end if;
    end process;

end Behavioral;
