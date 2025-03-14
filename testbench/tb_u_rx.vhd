library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_u_rx is

Generic(

osc_freq     : integer := 100_000_000;

width        : integer := 8;
no_of_sample : integer := 16;

baudrate : integer := 9600


);

end tb_u_rx;

architecture Behavioral of tb_u_rx is

component u_rx is

Generic(

osc_freq     : integer := 100_000_000;

width        : integer := 8;
no_of_sample : integer := 16;

baudrate       : integer := 9600


);

Port ( 

clk             : in std_logic;
data_in         : in std_logic;
baud_en_rx      : in std_logic;

rx_active       : out std_logic;
data_out        : out std_logic_vector(7 downto 0);
rx_data_ready   : out std_logic

);


end component;

signal clk             : std_logic := '0';
signal data_in         : std_logic := '1';
signal baud_en_rx      : std_logic;
signal rx_active       : std_logic;
signal data_out        : std_logic_vector(7 downto 0);
signal rx_data_ready   : std_logic;

constant c_clkperiod   : time := 10ns;
constant c_baud9600    : time := 0.104ms;
constant c_hex43       : std_logic_vector (9 downto 0) := '1' & x"43" & '0'; 
constant c_hex66       : std_logic_vector (9 downto 0) := '1' & x"66" & '0'; 
constant c_hex40       : std_logic_vector (9 downto 0) := '1' & x"40" & '0'; 

begin

DUT : u_rx 

generic map (
osc_freq        => osc_freq ,
width           => width,
no_of_sample    => no_of_sample,
baudrate        => baudrate

)

port map( 

 clk            => clk            ,
 data_in        => data_in        ,
 baud_en_rx     => baud_en_rx     ,
 rx_active      => rx_active      ,
 data_out       => data_out       ,
 rx_data_ready  => rx_data_ready

);

P_CLKGEN : process begin

clk <= '0';
wait for c_clkperiod/2;
clk <= '1';
wait for c_clkperiod/2;


end process P_CLKGEN;


bauder : process begin

baud_en_rx <= '0';
wait for c_baud9600/16;
baud_en_rx <= '1';
wait for 10ns;


end process bauder;



P_STIMULI : process begin

wait for c_clkperiod*10;



for i in 0 to 9 loop 

data_in <= c_hex43(i);
wait for c_baud9600;

end loop;

wait for 200 us;

for i in 0 to 9 loop 

data_in <= c_hex66(i);
wait for c_baud9600;

end loop;

wait for 200 us;

for i in 0 to 9 loop 

data_in <= c_hex40(i);
wait for c_baud9600;

end loop;

wait for 200 us;

assert false
report "SIM DONE"
severity failure;


end process P_STIMULI;

end Behavioral;

