
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_cmd_handler is
--  Port ( );
end tb_cmd_handler;

architecture Behavioral of tb_cmd_handler is

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


  signal   clk             : std_logic;
  signal   rx_data_ready   : std_logic;
  signal   rx_data         : std_logic_vector(7 downto 0);
  signal   tx_active       : std_logic;
  signal   sw              : std_logic_vector(2 downto 0);
   
  signal   cmd_ready       :  std_logic;
  signal   cmd             :  std_logic_vector(15 downto 0);
  signal   tx_send         :  std_logic;
  signal   tx_data         :  std_logic_vector(7 downto 0);
                                                                             
constant c_clkperiod   : time := 10ns;                                       
constant c_baud9600    : time := 0.104ms;                                    
constant c_hex43       : std_logic_vector (9 downto 0) := '1' & x"43" & '0'; 
constant c_hex66       : std_logic_vector (9 downto 0) := '1' & x"66" & '0'; 
constant c_hex40       : std_logic_vector (9 downto 0) := '1' & x"40" & '0'; 


begin


DUT: cmd_handler 

port map(

clk             => clk,
rx_data_ready   => rx_data_ready,
rx_data         => rx_data,
tx_active       => tx_active,
sw              => sw,         
cmd_ready       => cmd_ready,
cmd             => cmd,
tx_send         => tx_send, 
tx_data         => tx_data

);



P_CLKGEN : process begin

clk <= '0';
wait for 5 ns;
clk <= '1';
wait for 5 ns;


end process P_CLKGEN;




P_STIMULI : process begin

wait for 200 us;
--   clk            
--   rx_data_ready  
--   rx_data        
--   tx_active      
--   sw             

rx_data_ready <= '1';
wait for 10 ns;
rx_data_ready <= '0';

tx_active <= '1';
wait for 10 ns;
tx_active <= '0';

rx_data <= x"61";
sw <= "001";
wait for 100us;


rx_data_ready <= '1';
wait for 10 ns;
rx_data_ready <= '0';

tx_active <= '1';
wait for 10 ns;
tx_active <= '0';

rx_data <= x"62";
sw <= "001";
wait for 100us;

rx_data_ready <= '1';
wait for 10 ns;
rx_data_ready <= '0';

tx_active <= '1';
wait for 10 ns;
tx_active <= '0';

rx_data <= x"41";
sw <= "001";
wait for 100us;
assert false
report "SIM DONE"
severity failure;

end process P_STIMULI;

end Behavioral;
