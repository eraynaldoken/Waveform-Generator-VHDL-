

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_wave_gen is
--  Port ( );
end tb_wave_gen;

architecture Behavioral of tb_wave_gen is

component wave_gen is
Port ( 

clk         : in  std_logic;
en          : in  std_logic;
cmd_rdy     : in  std_logic;
wave_type   : in  std_logic_vector(7 downto 0);

wave_out    : out std_logic_vector(7 downto 0)

);
end component;

signal clk          : std_logic := '0';
signal clk_period   : time := 10 ns; 
signal en           : std_logic := '0';
signal cmd_rdy      : std_logic := '0';
signal en_loop      : std_logic := '0';
signal wave_type    : std_logic_vector(7 downto 0) := (others => '0');
signal wave_out     : std_logic_vector(7 downto 0) := (others => '0');


begin

DUT : wave_gen 

port map( 

clk         => clk,
en          => en,
cmd_rdy     => cmd_rdy,
wave_type   => wave_type,
wave_out    => wave_out  

);


P_CLKGEN : process begin

clk <= '0';
wait for clk_period/2;
clk <= '1';
wait for clk_period/2;


end process P_CLKGEN;


P_en : process begin
wait until cmd_rdy = '1';
while (en_loop = '1') loop
en <= '0';
wait for 10 us;
en <= '1';
wait for clk_period;
end loop;
wait;
end process P_en;




P_STIMULI : process begin

wait for 200 us;


wait for clk_period*5;
cmd_rdy <= '1';
wave_type <= x"41";
en_loop <= '1';
wait for clk_period;
cmd_rdy <= '0';
wait for 50 ms;     


cmd_rdy <= '1';
wave_type <= x"42";
wait for clk_period;
cmd_rdy <= '0';
wait for 50 ms;   


cmd_rdy <= '1';
wave_type <= x"43";
wait for clk_period;
cmd_rdy <= '0';
wait for 50 ms;   
en_loop <= '0';

cmd_rdy <= '1';
wave_type <= x"44";
wait for clk_period;
cmd_rdy <= '0';
wait for 50 ms;   
en_loop <= '0';



assert false
report "SIM DONE"
severity failure;


end process P_STIMULI;
end Behavioral;