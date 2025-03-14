library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity u_tx is

Generic(

width           : integer := 8;
no_of_sample    : integer := 16

);


Port ( 

clk         : in std_logic;
tx_send     : in std_logic; --tx_start_i 
data_in     : in std_logic_vector(7 downto 0);
baud_en_tx  : in std_logic;

tx_data_out : out std_logic;
tx_active   : out std_logic


);
end u_tx;

architecture behav of u_tx is

type states is (idle, send_start_bit, send_data, send_stop_bit); 
signal state : states := idle;


signal bitcntr  : integer range 0 to 7 :=0; 
signal baudcntr        : integer range 0 to 15 := 0;
signal shreg    : std_logic_vector(7 downto 0 ) := (others => '0');
begin

P_MAIN: process(clk) begin

if(rising_edge(clk)) then 

    case state is
    
    when idle =>
    tx_active <= '0';
    tx_data_out <= '1';
    --bitcntr     <= 0;
    
    
    if(tx_send = '1')then
     tx_active <='1';
     tx_data_out <= '0';
     shreg <= data_in;
     state <= send_start_bit;
    end if;
    
    
    when send_start_bit =>
    tx_active <='1';
    if (baud_en_tx = '1') then
        if (baudcntr = 15) then
       state <= send_data;
       baudcntr <= 0;
        else
       baudcntr <= baudcntr + 1;
        end if;
       tx_data_out <= '0';
    end if;

    when send_data =>
    tx_active <='1';
    tx_data_out <= shreg(0);
    
       if (baud_en_tx = '1') then
       
        if(baudcntr = 15) then
            baudcntr <= 0;
            if(bitcntr = 7) then
                bitcntr <= 0;
                state <= send_stop_bit;
                tx_data_out <= '1';
            else
                bitcntr <= bitcntr + 1;
                shreg(7) <= shreg(0);
                shreg(6 downto 0) <= shreg(7 downto 1);
             --   tx_data_out <= shreg(0);
            end if;
        else
            baudcntr <= baudcntr + 1;
            
        end if;
    end if;

          when send_stop_bit =>
    if (baud_en_tx = '1') then
        if (baudcntr = 15) then
            state <= idle;
            tx_active <= '0';
            baudcntr <= 0;
        else
            baudcntr <= baudcntr + 1;
        end if;
        end if;
        end case;
    end if;



end process;
    

end behav;