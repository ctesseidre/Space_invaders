----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2021 10:32:03
-- Design Name: 
-- Module Name: compteur_generique - Behavioral
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

entity compteur_generique is
generic(NbBit : integer := 6);
Port ( 
    rst_in      : in std_logic;
    clk_in      : in std_logic;
    clk_enable_in   : in std_logic;
    init_in     : in std_logic;
    load_in     : in std_logic;
    enable_in   : in std_logic;
    data_in     : in std_logic_vector(NbBit-1 downto 0);
    data_out    : out std_logic_vector(NbBit-1 downto 0)
);
end compteur_generique;

architecture Behavioral of compteur_generique is
signal sig_cpt : std_logic_vector(NbBit-1 downto 0) := (others => '0');
begin

    process(rst_in, clk_in)
    begin
    
        if (rst_in = '1') then
            sig_cpt <= (others => '0');
        elsif (clk_in'event and clk_in = '1') then 
            if (clk_enable_in = '1') then
                if (init_in = '1') then
                    sig_cpt <= (others => '0');
                elsif (load_in = '1') then
                    sig_cpt <= data_in;
                elsif (enable_in = '1') then
                    sig_cpt <= std_logic_vector(unsigned(sig_cpt) + 1);                
                end if;
            end if;
        end if;
    end process;

    data_out <= sig_cpt;
    
end Behavioral;
