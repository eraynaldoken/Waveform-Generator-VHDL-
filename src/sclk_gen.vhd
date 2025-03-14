-- File Name: sclk_gen.vhd
-- Entity Name: sclk_gen
-- Architecture Name: Behave

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sclk_gen is
    Port (
        clk       : in  std_logic; 
       
        sclk      : out std_logic; 
        edge_low  : out std_logic  
    );
end sclk_gen;

architecture Behave of sclk_gen is
    signal count : unsigned(1 downto 0) := "00";
    signal sclk_int : std_logic := '0';
    signal edge_low_int : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            edge_low <= '0';

            if count = 3 then
                count <= (others => '0');
            else 
                count <= count + 1;
            end if;
            
            if count < 2 then
                sclk <= '1';
            else 
                sclk <= '0';
            end if;
            
            if count = 1 then
                edge_low <= '1';
            end if;
        end if;
    end process;
    
end Behave;