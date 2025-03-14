library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.wave_gen_pkg.ALL;

entity tb_uart_cmd is
--  Port ( );
end tb_uart_cmd;

architecture Behavioral of tb_uart_cmd is

signal clk                    : std_logic;
signal sw                     : std_logic_vector(2 downto 0);
signal rx_din                 : std_logic;
signal tx_data                : std_logic_vector(7 downto 0);    --cmd handler ýn outu buraya deðer olarak gelecek
signal tx_send                : std_logic;                       --cmd handler ýn outu buraya deðer olarak gelecek
 
signal cmd_ready              : std_logic;
signal cmd                    : std_logic_vector(15 downto 0);
signal tx_send_cmd            : std_logic;
signal tx_data_cmd            : std_logic_vector(7 downto 0);
signal tx_dout                : std_logic; -- wave_gen top çýkýþ

constant c_hex43       : std_logic_vector (9 downto 0) := '1' & x"43" & '0'; 
constant c_hex66       : std_logic_vector (9 downto 0) := '1' & x"66" & '0'; 
constant c_hex40       : std_logic_vector (9 downto 0) := '1' & x"40" & '0'; 
constant c_baud9600    : time := 0.104ms;

begin


DUT : entity work.uart_cmd 

port map( 

 clk           => clk,
 sw            => sw,
 rx_din        => rx_din,
 tx_data       => tx_data,
 tx_send       => tx_send,
               
 cmd_ready     => cmd_ready,
 cmd           => cmd,
 tx_send_cmd   => tx_send_cmd,
 tx_data_cmd   => tx_data_cmd,
 tx_dout       => tx_dout
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
    
    wait for 10 us ;

--clk     
--sw      
--rx_din  
--tx_data 
--tx_send    
         
        sw <= "001";    
        
        for i in 0 to 9 loop 
        rx_din <= c_hex43(i);
        wait for c_baud9600;
        end loop;
        wait until tx_dout /= '0';
   
       
        

    
    
        assert false
        report "SIM DONE"
        severity failure;
        
    end process;








end Behavioral;
