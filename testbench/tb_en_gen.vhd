

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_en_gen is
--  Port ( );
end tb_en_gen;

architecture Behavioral of tb_en_gen is

component en_gen is
Port ( 

clk         : in std_logic;
cmd_rdy     : in std_logic;
freq        : in std_logic_vector(7 downto 0);

en_out      : out std_logic

);
end component;

signal clk         : std_logic := '0';
signal cmd_rdy     : std_logic := '0';
signal freq        : std_logic_vector(7 downto 0) := (others => '0');
signal en_out      : std_logic := '0';


begin

DUT : en_gen 

port map( 

clk      => clk,
cmd_rdy  => cmd_rdy,
freq     => freq,
en_out   => en_out  

);


P_CLKGEN : process begin

clk <= '0';
wait for 5 ns;
clk <= '1';
wait for 5 ns;


end process P_CLKGEN;


P_STIMULI : process begin

wait for 200 us;
       
cmd_rdy <= '1';
wait for  10 ns;
cmd_rdy <= '0';
wait for  10 ns;
freq <= x"30";
wait for 200 us;

cmd_rdy <= '1';
wait for  10 ns;
cmd_rdy <= '0';
wait for  10 ns;
freq <= x"31";
wait for 200 us;

cmd_rdy <= '1';
wait for  10 ns;
cmd_rdy <= '0';
wait for  10 ns;
freq <= x"32";
wait for 200 us;

cmd_rdy <= '1';
wait for  10 ns;
cmd_rdy <= '0';
wait for  10 ns;
freq <= x"33";
wait for 200 us;

cmd_rdy <= '1';
wait for  10 ns;
cmd_rdy <= '0';
wait for  10 ns;
freq <= x"34";
wait for 200 us;

cmd_rdy <= '1';
wait for  10 ns;
cmd_rdy <= '0';
wait for  10 ns;
freq <= x"35";
wait for 200 us;

cmd_rdy <= '1';
wait for  10 ns;
cmd_rdy <= '0';
wait for  10 ns;
freq <= x"36";
wait for 200 us;



assert false
report "SIM DONE"
severity failure;


end process P_STIMULI;






end Behavioral;
