library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sync_data_gen is
Port ( 

clk         : in std_logic;
en          : in std_logic;
edge_low    : in std_logic;
wave        : in std_logic_vector(7 downto 0);

sync        : out std_logic;
dac_data    : out std_logic

);
end sync_data_gen;

architecture Behave of sync_data_gen is

type state is (idle, start);
signal s_state : state  := idle;

constant control_bit    : std_logic_vector (7 downto 0):= "00110000";
signal bit_cntr         : integer range 0 to 16 := 0;
signal wave_reg          : std_logic_vector (15 downto 0);

begin

process(clk) 
begin

if rising_edge(clk) then
       
       
     case s_state is
     
        when idle =>
            if(en = '1') then
                 s_state <= start;
                 wave_reg <= control_bit & wave;
                 bit_cntr <= 0 ;
             else
                  s_state <= idle;
          end if;

       when start =>

             if(edge_low = '1') then
              sync <= '0';
               dac_data<= wave_reg(15);
                    if(bit_cntr <= 15) then
                         bit_cntr <= bit_cntr + 1;
                         wave_reg(0) <= wave_reg(15);
                         wave_reg(15 downto 1) <= wave_reg(14 downto 0  );
                    else 
                        bit_cntr <= 0;
              
                        sync     <=  '1';
                        s_state <= idle;
                    end if;
           
            
           
            
        end if;
end case;
end if;
end process;
end Behave;