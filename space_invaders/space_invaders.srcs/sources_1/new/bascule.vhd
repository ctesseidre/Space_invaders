----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2021 10:32:03
-- Design Name: 
-- Module Name: bascule - Behavioral
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

entity bascule is
Port ( 
    rst_in      : in std_logic;
    clk_in      : in std_logic;
    init_in     : in std_logic;
    en_in       : in std_logic;
    data_in     : in std_logic;
    data_out    : out std_logic
);
end bascule;

architecture Behavioral of bascule is

begin

    process(rst_in, clk_in)
    begin
        if(rst_in = '1') then
            data_out    <= '0';
        elsif(clk_in'event and clk_in='1') then
            if(init_in = '1') then
                data_out    <= '0';
            elsif(en_in = '1') then
                data_out    <= data_in;
            end if;
        end if;
    end process;
    
end Behavioral;
