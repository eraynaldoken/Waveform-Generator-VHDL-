library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_baudrate_gen is

    generic (
        osc_freq : integer := 100_000_000;  -- 100 MHz Clock frequency
        no_of_sample : integer := 16         -- Number of samples during one baud time
    );

end tb_baudrate_gen;

architecture Behavioral of tb_baudrate_gen is

component baudrate_gen is

Generic(

        osc_freq : integer := 100_000_000;  -- 100 MHz Clock frequency
        no_of_sample : integer := 16         -- Number of samples during one baud time

);

Port ( 

        clk : in std_logic;                  -- 100 MHz Clock
        sw : in std_logic_vector(2 downto 0);-- 3-bit switch bus
        rx_active : in std_logic;            -- Receive active signal
        tx_active : in std_logic;            -- Transmit active signal
        baud_en_rx : out std_logic;          -- Baudrate tick for receiver
        baud_en_tx : out std_logic           -- Baudrate tick for transmitter

);


end component;

signal clk : std_logic := '0';                  -- 100 MHz Clock                
signal sw : std_logic_vector(2 downto 0):= "000";-- 3-bit switch bus             
signal rx_active : std_logic := '0';            -- Receive active signal        
signal tx_active :  std_logic := '0';            -- Transmit active signal       
signal baud_en_rx :  std_logic;          -- Baudrate tick for receiver   
signal baud_en_tx :  std_logic;           -- Baudrate tick for transmitter

constant c_clkperiod   : time := 10ns;



begin

DUT : baudrate_gen 

generic map (
osc_freq        => osc_freq ,
no_of_sample    => no_of_sample

)

port map( 

 clk     => clk,
 sw      => sw,
 rx_active  => rx_active,
 tx_active  => tx_active,
 baud_en_rx   =>  baud_en_rx,
 baud_en_tx   => baud_en_tx

);

P_CLKGEN : process begin

clk <= '0';
wait for c_clkperiod/2;
clk <= '1';
wait for c_clkperiod/2;


end process P_CLKGEN;


P_STIMULI : process begin

wait for 400 us;

sw <= "000";
rx_active <= '0';

wait for 400 us;

sw <= "001";
rx_active <= '1';
tx_active <= '1';

wait for 400 us;

sw <= "010";
rx_active <= '1';
tx_active <= '1';


wait for 400 us;

assert false
report "SIM DONE"
severity failure;


end process P_STIMULI;

end Behavioral;
