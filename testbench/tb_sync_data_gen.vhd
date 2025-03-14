
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_sync_data_gen is
--  Port ( );
end tb_sync_data_gen;

architecture Behavioral of tb_sync_data_gen is

component sync_data_gen is
Port ( 

clk         : in std_logic;
rst         : in std_logic;
en          : in std_logic;
edge_low    : in std_logic;
wave        : in std_logic_vector(7 downto 0);

sync        : out std_logic;
dac_data    : out std_logic

);
end component;


signal clk         : std_logic;
signal rst         : std_logic;
signal en          : std_logic;
signal edge_low    : std_logic;
signal wave        : std_logic_vector(7 downto 0);
signal sync        :  std_logic;
signal dac_data    :  std_logic;

begin

DUT : sync_data_gen 

port map( 

clk         => clk,
rst         => rst,
wave        => wave,
en          => en,
edge_low    => edge_low,
sync        => sync,
dac_data    => dac_data  

);


P_CLKGEN : process begin

clk <= '0';
wait for 5 ns;
clk <= '1';
wait for 5 ns;


end process P_CLKGEN;

P_en : process begin


en <= '0';
wait for 10 us;
en <= '1';
wait for 10 ns;

end process P_en;



P_STIMULI : process begin

wait for 200 us;

rst<= '0';
wait for 25 ns;
edge_low <= '1';
wave  <= "10101010";
wait for 200 us;     

rst<= '0';
wait for 25 ns;
edge_low <= '1';
wave  <= "10001000";
wait for 200 us;   

assert false
report "SIM DONE"
severity failure;

end process P_STIMULI;

end Behavioral;


