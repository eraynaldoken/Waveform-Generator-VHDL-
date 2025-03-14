library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.wave_gen_pkg.ALL;

entity uart_cmd is
generic(


osc_freq        : integer   := 100_000_000; --Frequency integer constant (100_000_000)
width           : integer   := 8; --UART width integer constant (8)
no_of_sample    : integer   := 16 --Number of samples taken during one baud time integer constant (16)

);
 Port ( 
 
clk             : in std_logic;
sw              : in std_logic_vector(2 downto 0);
rx_din          : in std_logic;
tx_data         : in std_logic_vector(7 downto 0);    --cmd handler ın outu buraya değer olarak gelecek
tx_send         : in std_logic;                       --cmd handler ın outu buraya değer olarak gelecek
 
cmd_ready              : out std_logic;
cmd                    : out std_logic_vector(15 downto 0);
tx_send_cmd            : out std_logic;
tx_data_cmd            : out std_logic_vector(7 downto 0);
tx_dout                : out std_logic                      --wave_gen_top çıkışı

 );
end uart_cmd;

architecture Behavioral of uart_cmd is

component uart_top is

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
tx_data         : in std_logic_vector(7 downto 0);    --cmd handler ın outu buraya değer olarak gelecek
tx_send         : in std_logic;                       --cmd handler ın outu buraya değer olarak gelecek

tx_dout         : out std_logic;                      --wave_gen_top çıkışı
tx_active       : out std_logic;                      --cmd handler girişleri
rx_data_ready   : out std_logic;                      --cmd handler girişleri
rx_data         : out std_logic_vector(7 downto 0)    --cmd handler girişleri

);
end component;

component cmd_handler is
Port ( 
    clk             : in std_logic;
    rx_data_ready   : in std_logic;
    rx_data         : in std_logic_vector(7 downto 0);
    tx_active       : in std_logic;
    sw              : in std_logic_vector(2 downto 0);

    cmd_ready       : out std_logic;
    cmd             : out std_logic_vector(15 downto 0);
    tx_send         : out std_logic;
    tx_data         : out std_logic_vector(7 downto 0)
);
end component;

signal s_tx_data               : std_logic_vector(7 downto 0) := (others => '0');
signal s_tx_send               : std_logic := '0';
signal s_tx_active             : std_logic := '0'; 
signal s_rx_data_ready         : std_logic := '0';
signal s_rx_data               : std_logic_vector(7 downto 0) := (others => '0');

begin

uart: uart_top 
generic map(

osc_freq        => osc_freq,    
width           => width,       
no_of_sample    => no_of_sample

)

Port map(

clk              => clk,     
sw               => sw,
rx_din           => rx_din,
tx_data          => s_tx_data,
tx_send          => s_tx_send,
tx_dout          => tx_dout,
tx_active        => s_tx_active,
rx_data_ready    => s_rx_data_ready, 
rx_data          => s_rx_data

);

cmdhandler: cmd_handler 
Port map(

    clk             => clk,
    rx_data_ready   => s_rx_data_ready,
    rx_data         => s_rx_data,
    tx_active       => s_tx_active,
    
    sw              => sw,              
    cmd_ready       => cmd_ready,
    cmd             => cmd,
    tx_send         => s_tx_send,
    tx_data         => s_tx_data

);

s_tx_send <= tx_send;
s_tx_data <= tx_data;


end Behavioral;
