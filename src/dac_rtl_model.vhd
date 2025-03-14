library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

use work.wave_gen_pkg.ALL;
entity dac_rtl_model is
    Port (
        sclk: in std_logic;
        sync: in std_logic;
        dac_data: in std_logic;
        data_out: out real
    );
end dac_rtl_model;

architecture Behavioral of dac_rtl_model is
    type state_type is (idle, data);
    
--    signal current_state, next_state: state_type;
    signal s_state: state_type;
    signal bit_counter: integer range 0 to 15 := 0;
    signal data_reg: std_logic_vector(15 downto 0) := x"0000";
    constant vdd: real := 3.30/256;
    signal control_bit_err : std_logic := '0';


begin
    process (sclk)
    begin
        if rising_edge(sclk) then
--            current_state <= next_state;
            
          case s_state is
          
            when idle =>
                if sync = '1' then
                    s_state <= data;
                    bit_counter <= 0;
                    control_bit_err <= '0';
                end if;
                
            when data =>
                data_reg(15-bit_counter) <= dac_data;
                bit_counter <= bit_counter + 1;
                if bit_counter = 15 then
                    if data_reg(15 downto 8) = control_bit then
                        control_bit_err  <= '1';
                        data_out <= real(to_integer(unsigned(data_reg(7 downto 0)))) * (vdd);
                    end if;
                    s_state <= idle;
                end if;
            end case;
        end if;
    end process;
end Behavioral;