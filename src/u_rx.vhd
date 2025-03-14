library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity u_rx is

Generic(

osc_freq     : integer := 100_000_000;

width        : integer := 8;
no_of_sample : integer := 16;

baudrate : integer := 9600

);


Port ( 

clk             : in std_logic;
data_in         : in std_logic;
baud_en_rx      : in std_logic;

rx_active       : out std_logic;
data_out        : out std_logic_vector(7 downto 0);
rx_data_ready   : out std_logic

);
end u_rx;

architecture behav of u_rx is

type states is (idle, wait_mid_of_start_bit, receive_data, receive_stop_bit); 
signal state : states := idle;

--constant c_bittimerlim : integer := osc_freq/baudrate;

--signal bittimer        : integer range 0 to c_bittimerlim := 0;
signal shreg           : std_logic_vector(7 downto 0) := (others => '0');
signal bitcntr         : integer range 0 to 7 := 0;
signal baudcntr        : integer range 0 to 16 := 0;


begin

process(clk) begin

if(rising_edge(clk)) then
    
    case state is
        
    when idle =>
    rx_data_ready <= '0';
    --bittimer <= 0;
    rx_active <= '0';
   
   if(data_in  = '0') then 
   
   state <= wait_mid_of_start_bit;
 
   end if;

     when wait_mid_of_start_bit =>
    
    rx_active <= '1';
    if(baud_en_rx = '1') then
    
     
         if(baudcntr = 7) then
        
            if(data_in = '0') then
            baudcntr <= 0;
            state <= receive_data;
            
            
            else 
            
            state <= idle;
            baudcntr <= 0;
            
            end if;
        
          else 
          
             baudcntr <= baudcntr + 1; 
            
         end if; 
  

           
    end if;
 
    when receive_data =>
    rx_active <= '1';
   
    
        if(baud_en_rx = '1') then
        
            if(baudcntr = 15) then
             baudcntr <= 0;
            
                if(bitcntr = 7) then 
                
                state <= receive_stop_bit; 
                bitcntr <= 0;              
                
                else 
                
                bitcntr <= bitcntr + 1;
                
                end if;
            
        shreg <= data_in & (shreg(7 downto 1));
        
            else 
            
            
              baudcntr <= baudcntr + 1;
            
                end if;
        
       
        
        end if;

    when receive_stop_bit =>
    
        if(baud_en_rx = '1') then
        
            if(baudcntr = 15) then
            
            state <= idle;       
            baudcntr <= 0;       
            rx_data_ready <= '1';
           
            else 
            
              baudcntr <= baudcntr + 1;
            
            end if;
    
        
        end if;

    when others =>
    state <= idle;
        
    end case;

end if;

end process;

data_out <= shreg;

end behav;