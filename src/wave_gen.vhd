library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity wave_gen is
Port ( 

clk         : in  std_logic;
en          : in  std_logic;
cmd_rdy     : in  std_logic;
wave_type   : in  std_logic_vector(7 downto 0);

wave_out    : out std_logic_vector(7 downto 0)

);


end wave_gen;

architecture Behave of wave_gen is

signal en_cnt : unsigned(7 downto 0) := (others =>'0');
type t_wave_st is (sawtooth, triangle, square,sin);
signal s_wave_st : t_wave_st := sawtooth;
--signal s_wave_out :  std_logic_vector(7 downto 0);
signal i : integer range 0 to 32 := 0;

type memory_type is array (0 to 31) of integer range 0 to 255;
signal sine : memory_type :=
    (128,152,176,198,218,234,245,253,  --sine wave amplitudes in the 1st quarter.
    255,253,245,234,218,198,176,152,    --sine wave amplitudes in the 2nd quarter.
    128,103,79,57,37,21,10,2,    --sine wave amplitudes in the 3rd quarter.
    0,2,10,21,37,57,79,103);    --sine wave amplitudes in the 4th quarter.
begin


process(clk) 
begin 


if rising_edge(clk) then
    
    if(en = '1') then
        if(en_cnt = 255 )then
            en_cnt <= (others =>'0');
        else 
            en_cnt <= en_cnt + 1;
        end if;
     end if;
     
    if(cmd_rdy = '1') then

    
    case wave_type is
    
    when x"41" => s_wave_st <= sawtooth;
      
    when x"42" => s_wave_st <= square;

    when x"43" => s_wave_st <= triangle;
    
    when x"44" => s_wave_st <= sin;
    
    when others => s_wave_st <= square;
    
    end case;
    
    

    end if;
    
    case s_wave_st is
    
    when sawtooth => 
    
        wave_out  <= std_logic_vector(en_cnt);
        
    when triangle =>
    
        if(en_cnt < 128) then
            wave_out  <= std_logic_vector(en_cnt(6 downto 0) &  '0');
        else 
            wave_out  <= std_logic_vector(not(en_cnt(6 downto 0)) &  '0');
        end if;
        
    when square =>
           
        if(en_cnt < 128) then
            wave_out  <= (others => '1');
        else 
            wave_out  <= (others => '0');
        end if;
    
    when sin =>

    wave_out <= std_logic_vector(to_unsigned(sine(i),wave_out'length));
    i <= i+ 1;
    if(i = 31) then  
    i <= 0;
    
end if;
    when others => 
    
        wave_out  <= std_logic_vector(en_cnt);
    
    end case;
    
end if;

end process;

end Behave;
