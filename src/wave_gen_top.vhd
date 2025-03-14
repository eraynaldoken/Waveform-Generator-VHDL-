library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity wave_gen_top is

generic (

osc_freq       : integer   := 100_000_000; --Frequency integer constant 
width          : integer   := 8; --UART width integer constant 
no_of_sample   : integer   := 16 --Number of samples taken during one baud time integer constant 


);


Port ( 

clk          : in std_logic; --100 MHz Clock
uart_din     : in std_logic; --UART RX input
sw           : in std_logic_vector(2 downto 0); --3 bits switch bus connected to the switches on the board

uart_dout    : out std_logic; --UART TX output
sync         : out std_logic; --DAC sync control
dac_data     : out std_logic; --DAC data
s_clk        : out std_logic; --DAC clock
led          : out std_logic_vector(7 downto 0) --8 bit led control bus

);
end wave_gen_top;

architecture Struct of wave_gen_top is

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
tx_send         : in std_logic;

tx_dout         : out std_logic;                      --wave_gen_top çıkışı
tx_active       : out std_logic;                      --cmd handler girişleri
rx_data_ready   : out std_logic;                      --cmd handler girişleri
rx_data         : out std_logic_vector(7 downto 0)    --cmd handler girişleri

);
end component;

component sync_data_gen is
Port ( 
clk         : in std_logic;
en          : in std_logic;
edge_low    : in std_logic;
wave        : in std_logic_vector(7 downto 0);

sync        : out std_logic;
dac_data    : out std_logic
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

component en_gen is
Port ( 
clk         : in std_logic;
cmd_rdy     : in std_logic;
freq        : in std_logic_vector(7 downto 0);

en_out      : out std_logic
);
end component;

component sclk_gen is
    Port (
        clk       : in  std_logic;  
       
        sclk      : out std_logic; 
        edge_low  : out std_logic  
    );
end component;

component wave_gen is
Port ( 

clk         : in  std_logic;
en          : in  std_logic;
cmd_rdy     : in  std_logic;
wave_type   : in  std_logic_vector(7 downto 0);

wave_out    : out std_logic_vector(7 downto 0)

);
end component;

--component dac_rtl_model is
--    Port (
--        sclk: in std_logic;
--        sync: in std_logic;
--        dac_data: in std_logic;
--        data_out: out real
--    );
--end component;

signal s_tx_data : std_logic_vector(7 downto 0);
signal s_tx_send : std_logic;
signal s_tx_active : std_logic;
signal s_rx_data_ready : std_logic;
signal s_rx_data : std_logic_vector(7 downto 0);

signal s_cmd_ready : std_logic;
signal s_cmd : std_logic_vector(15 downto 0);
signal s_en_out : std_logic;
signal s_wave_out : std_logic_vector(7 downto 0);
signal s_edge_low : std_logic;
signal s_sw : std_logic_vector(2 downto 0);

begin

uarttop : uart_top
generic map(
osc_freq       => osc_freq,
width          => width,
no_of_sample   => no_of_sample
)
port map(

clk             => clk,
--rst          
sw               => s_sw,
rx_din           => uart_din,
tx_data          => s_tx_data,
tx_send          => s_tx_send,
             
tx_dout          => uart_dout,
tx_active        => s_tx_active,
rx_data_ready    => s_rx_data_ready,
rx_data          => s_rx_data

);


cmdhandler: cmd_handler
port map(

  clk           => clk,
  rx_data_ready => s_rx_data_ready,
  rx_data       => s_rx_data,
  tx_active     => s_tx_active,
  sw            => s_sw,
                
  cmd_ready     => s_cmd_ready,
  cmd           => s_cmd,
  tx_send       => s_tx_send,
  tx_data       => s_tx_data

);

engen: en_gen
Port map(   
         
clk       => clk,
cmd_rdy   => s_cmd_ready,
freq      => s_cmd(7 downto 0),

en_out    => s_en_out
         
);       

wavegen: wave_gen
port map(
clk       => clk,
en        => s_en_out,
cmd_rdy   => s_cmd_ready,
wave_type => s_cmd(15 downto 8),
          
wave_out  => s_wave_out 
);

sclkgen: sclk_gen
port map(
clk       => clk,
     
sclk      => s_clk,
edge_low  => s_edge_low 
);

syncdatagen: sync_data_gen
port map(
clk        => clk,
en         => s_en_out,
edge_low   => s_edge_low, 
wave       => s_wave_out,
           
sync       => sync,
dac_data   => dac_data 
);

led <= s_wave_out;
s_sw <= sw;


end Struct;
