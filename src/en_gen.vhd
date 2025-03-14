library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity en_gen is
Port ( 
    clk         : in std_logic;
    cmd_rdy     : in std_logic;
    freq        : in std_logic_vector(7 downto 0);
    en_out      : out std_logic := '0'
);
end en_gen;

architecture Behave of en_gen is

signal cnt_freq : integer range 0 to 1000 := 1000;
signal cnt_freq_2 : integer range 0 to 1000 := 0;

begin

process(clk)
begin
    if rising_edge(clk) then
        en_out <= '0';
        if(cmd_rdy = '1') then
            cnt_freq <= 0;

            case freq is
                when x"30"  => cnt_freq <= 1000;
                when x"31"  => cnt_freq <= 900;
                when x"32"  => cnt_freq <= 800;
                when x"33"  => cnt_freq <= 700;
                when x"34"  => cnt_freq <= 600;
                when x"35"  => cnt_freq <= 500;
                when x"36"  => cnt_freq <= 400;
                when x"37"  => cnt_freq <= 300;
                when x"38"  => cnt_freq <= 200;
                when x"39"  => cnt_freq <= 100;
                when others => cnt_freq <= 1000;
            end case;
        end if;

        if cnt_freq_2 < cnt_freq then
            cnt_freq_2 <= cnt_freq_2 + 1;
--            en_out <= '0';
        else
            cnt_freq_2 <= 0;
            en_out <= '1';
        end if;
        
    end if;
end process;

end Behave;
