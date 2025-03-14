
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity tb_wave_gen_top is
--  Port ( );osc_freq       : integer   := 100_000_000; --Frequency integer constant 
generic (

osc_freq       : integer   := 100_000_000; --Frequency integer constant 
width          : integer   := 8; --UART width integer constant 
no_of_sample   : integer   := 16 --Number of samples taken during one baud time integer constant 


);
end tb_wave_gen_top;

architecture Behavioral of tb_wave_gen_top is

component wave_gen_top is

Generic(

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


end component;



signal clk        : std_logic; --100 MHz Clock                                                                                                                       
signal uart_din   : std_logic; --UART RX input                                                                    
signal sw         : std_logic_vector(2 downto 0); --3 bits switch bus connected to the switches on the board      
                                                                                                           
signal uart_dout  :  std_logic; --UART TX output                                                                  
signal sync       :  std_logic; --DAC sync control                                                                
signal dac_data   :  std_logic; --DAC data                                                                        
signal s_clk      :  std_logic; --DAC clock                                                                       
signal led        :  std_logic_vector(7 downto 0); --8 bit led control bus      

signal s_tx_dout         :  std_logic; 
signal s_tx_data        :  std_logic_vector(7 downto 0);
signal s_rx_data        :  std_logic_vector(7 downto 0);
signal s_tx_send        :  std_logic; 
signal s_tx_active      : std_logic;
signal s_rx_data_ready  : std_logic;
signal s_data_out       : real;
                            
constant c_baud9600     : time := 0.104ms;
constant c_hex41        : std_logic_vector (9 downto 0) := '1' & x"41" & '0';  
constant c_hex66        : std_logic_vector (9 downto 0) := '1' & x"66" & '0'; 
constant c_hex35        : std_logic_vector (9 downto 0) := '1' & x"35" & '0'; 
    
begin

dut1: entity work.wave_gen_top
        generic map(
            osc_freq        => 100_000_000,
            width           => 8,
            no_of_sample    => 16
        )
        port map(
       
       clk         => clk,
       uart_din    => uart_din,
       sw          => sw,
       uart_dout   => uart_dout,
       sync        => sync ,
       dac_data    => dac_data,
       s_clk       => s_clk,
       led         => led 
       );
       
user: entity work.uart_top

generic map(

            osc_freq        => 100_000_000,
            width           => 8,
            no_of_sample    => 16

)

Port map( 

        clk            => clk,
        sw             => sw, 
        rx_din         => uart_dout,
        tx_data        => s_tx_data,
        tx_send        => s_tx_send,
        tx_dout        => uart_din,
        tx_active      => s_tx_active,
        rx_data_ready  => s_rx_data_ready,
        rx_data        => s_rx_data 

);
dac: entity work.dac_rtl_model
 
Port map( 

     sclk  => s_clk,
     sync   => sync, 
     dac_data => dac_data,
     data_out => s_data_out
    

);
       
    clk_process: process
    begin
    
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
    
    end process;      
       
       stimulus_process: process
    begin
    
    wait for 200 us ;
                         
            
--            clk          : in std_logic; --100 MHz Clock                                                              
                                             
--            uart_din     : in std_logic; --UART RX input                                                              
--            sw           : in std_logic_vector(2 downto 0); --3 bits switch bus connected to the switches on the board
     sw <= "100";                                                                                  
     s_tx_data <= x"41";
     s_tx_send <= '1';
     wait until s_tx_active = '1';
     s_tx_send <= '0';
     wait until s_tx_active = '0';
     wait for 20 ms;
                                                                        
     s_tx_data <= x"30";
     s_tx_send <= '1';
     wait until s_tx_active = '1';
     s_tx_send <= '0';
     wait until s_tx_active = '0';
     wait for 100 ms;
        
     sw <= "010";
     s_tx_data <= x"42";
     s_tx_send <= '1';
     wait until s_tx_active = '1';
     s_tx_send <= '0';
     wait until s_tx_active = '0';
     wait for 10 ms;  
     
     s_tx_data <= x"30";
     s_tx_send <= '1';
     wait until s_tx_active = '1';
     s_tx_send <= '0';
     wait until s_tx_active = '0';
     wait for 10 ms; 
                                                                                                         
     s_tx_data <= x"43";
     s_tx_send <= '1';
     wait until s_tx_active = '1';
     s_tx_send <= '0';
     wait until s_tx_active = '0';
     wait for 10 ms;  
     
     s_tx_data <= x"35";
     s_tx_send <= '1';
     wait until s_tx_active = '1';
     s_tx_send <= '0';
     wait until s_tx_active = '0';
     wait for 10 ms; 
     
--     s_tx_data <= x"44";
--     s_tx_send <= '1';
--     wait until s_tx_active = '1';
--     s_tx_send <= '0';
--     wait until s_tx_active = '0';
--     wait for 10 ms;  
     
--     s_tx_data <= x"35";
--     s_tx_send <= '1';
--     wait until s_tx_active = '1';
--     s_tx_send <= '0';
--     wait until s_tx_active = '0';
--     wait for 10 ms;  
                 
        assert false
        report "SIM DONE"
        severity failure;
        
    end process;

       
         

end Behavioral;
