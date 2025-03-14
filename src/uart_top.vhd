
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_top is

generic(

osc_freq        : integer   := 100_000_000; --Frequency integer constant (100_000_000)
width           : integer   := 8; --UART width integer constant (8)
no_of_sample    : integer   := 16 --Number of samples taken during one baud time integer constant (16)

);

Port ( 

clk             : in std_logic;
--rst             : in std_logic;
sw              : in std_logic_vector(2 downto 0);
rx_din          : in std_logic;
tx_data         : in std_logic_vector(7 downto 0);    --cmd handler ýn outu buraya deðer olarak gelecek
tx_send         : in std_logic;                       --cmd handler ýn outu buraya deðer olarak gelecek

tx_dout         : out std_logic;                      --wave_gen_top çýkýþý
tx_active       : out std_logic;                      --cmd handler giriþleri
rx_data_ready   : out std_logic;                      --cmd handler giriþleri
rx_data         : out std_logic_vector(7 downto 0)    --cmd handler giriþleri

);
end uart_top;

architecture struct of uart_top is


component u_rx is
    Generic(
        width        : integer := 8;
        no_of_sample : integer := 16
    );
    Port (
        clk             : in std_logic;
        data_in         : in std_logic;
        baud_en_rx      : in std_logic;
        rx_active       : out std_logic;
        data_out        : out std_logic_vector(7 downto 0);
        rx_data_ready   : out std_logic
    );
end component u_rx;


component baudrate_gen is
    generic (
        osc_freq : integer := 100_000_000;  -- 100 MHz Clock frequency
        no_of_sample : integer := 16         -- Number of samples during one baud time
    );
    port (
        clk : in std_logic;                  -- 100 MHz Clock
        sw : in std_logic_vector(2 downto 0);-- 3-bit switch bus
        rx_active : in std_logic;            -- Receive active signal
        tx_active : in std_logic;            -- Transmit active signal
        baud_en_rx : out std_logic;          -- Baudrate tick for receiver
        baud_en_tx : out std_logic           -- Baudrate tick for transmitter
    );
end component baudrate_gen;

component u_tx is
    Generic(
        --c_stopbit    : integer := 2;
        width        : integer := 8;
        no_of_sample : integer := 16
    );
    Port (
        clk         : in std_logic;
        tx_send     : in std_logic; -- tx_start_i
        data_in     : in std_logic_vector(7 downto 0);
        baud_en_tx  : in std_logic;
        tx_data_out     : out std_logic;
        tx_active   : out std_logic
    );
end component u_tx;


signal baud_en_rx_s     : std_logic     := '0';
signal baud_en_tx_s     : std_logic     := '0';
signal rx_active_s      : std_logic     := '0';
signal tx_active_s      : std_logic     := '0';
signal sw_1     : std_logic_vector(2 downto 0);
signal sw_2      : std_logic_vector(2 downto 0);

begin

baudrate: baudrate_gen 
generic map(

osc_freq  => osc_freq ,
no_of_sample => no_of_sample

)

port map (

        clk         => clk,
        sw          => sw_2,
        rx_active   => rx_active_s,
        tx_active   => tx_active_s,
        baud_en_rx  => baud_en_rx_s,
        baud_en_tx  => baud_en_tx_s


);

receiver: u_rx 
generic map(

width => width,
no_of_sample => no_of_sample

)
port map (

clk              =>   clk,
data_in          =>   rx_din,
baud_en_rx       =>   baud_en_rx_s,
rx_active        =>   rx_active_s,
data_out         =>   rx_data,
rx_data_ready    =>   rx_data_ready

);

transmitter: u_tx 
generic map(

--c_stopbit => 2,
width => width,
no_of_sample => no_of_sample

)
port map (

 clk           => clk,
 tx_send       => tx_send,
 data_in       => tx_data,
 baud_en_tx    => baud_en_tx_s,
 tx_data_out   => tx_dout, 
 tx_active     => tx_active_s
 
);


tx_active <= tx_active_s;

process(clk)
begin

 if rising_edge(clk) then
 
 sw_1 <= sw;
 sw_2 <= sw_1;
 
 end if;
 
end process;



end struct;
