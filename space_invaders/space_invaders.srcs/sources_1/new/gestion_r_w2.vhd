----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 16:03:38
-- Design Name: 
-- Module Name: gestion_r_w2 - Behavioral
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

entity gestion_r_w2 is
generic(NB_BITS_ADDR : integer := 14);
Port ( 
    clk_in  : in std_logic;
    rst_in  : in std_logic;
    r_w_in  : in std_logic;
    addr_in : in std_logic_vector(NB_BITS_ADDR-1 downto 0);
    r_w_out : out std_logic
);
end gestion_r_w2;

architecture Behavioral of gestion_r_w2 is

    signal flag_write : std_logic := '0';

    signal balayage_ecran   : std_logic := '0';
    signal balayage_ecran_delayed   : std_logic := '0';

    signal save_addr    : std_logic_vector(13 downto 0);

begin

    -- Flag the demand
    process(rst_in, clk_in)
    begin
        if(rst_in = '1') then
            flag_write  <= '0';
            save_addr   <= (others => '0');
        elsif(clk_in'event and clk_in = '1') then
            if(r_w_in = '1') then   -- Just a rising edge during 1 CLK_PERIOD
                flag_write  <= '1';
                save_addr   <= addr_in;
            elsif (flag_write = '1') then
                if(addr_in = save_addr) then    -- Tour d'écran complet
                    flag_write  <= '0';
                    save_addr   <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    -- Give the order to write into the memory
    process(rst_in, clk_in)
    begin
        if(rst_in = '1') then
            r_w_out <= '0';
        elsif(clk_in'event and clk_in = '1') then
            r_w_out <= flag_write;
        end if;
    end process;

end Behavioral;
