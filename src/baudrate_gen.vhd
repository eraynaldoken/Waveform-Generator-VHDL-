library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity baudrate_gen is
    generic (
        osc_freq : integer := 100_000_000;  -- 100 MHz Clock frequency
        no_of_sample : integer := 16         -- Number of samples during one baud time
    );
    port (
        clk : in std_logic;                  -- 100 MHz Clock
        sw : in std_logic_vector(2 downto 0);-- 3-bit switch bus
        rx_active : in std_logic;            -- Receive active signal
        tx_active : in std_logic;            -- Transmit active signal
        baud_en_rx : out std_logic;          -- Baudrate tick for receiver
        baud_en_tx : out std_logic           -- Baudrate tick for transmitter
    );
end baudrate_gen;

architecture behav of baudrate_gen is

    signal baud_rate_divisor : integer;
    signal rx_counter : integer := 0;
    signal tx_counter : integer := 0;
    signal sw_reg     : std_logic_vector(2 downto 0) := "000";
    
    
begin
    process (clk)
    begin
        if rising_edge(clk) then
            case sw is
                when "001" => baud_rate_divisor <= osc_freq / (9600 * no_of_sample);   -- 9600 baud
                when "010" => baud_rate_divisor <= osc_freq / (19200 * no_of_sample);  -- 19200 baud
                when "011" => baud_rate_divisor <= osc_freq / (38400 * no_of_sample);  -- 38400 baud
                when "100" => baud_rate_divisor <= osc_freq / (57600 * no_of_sample);  -- 57600 baud
                when "101" => baud_rate_divisor <= osc_freq / (115200 * no_of_sample); -- 115200 baud
                when others => baud_rate_divisor <= osc_freq / (9600 * no_of_sample);  -- Default to 9600 baud
            end case;
            
            sw_reg <= sw;
            
            if(sw_reg /= sw) then
            
                rx_counter <= 0;
                tx_counter <= 0;
            
            end if;
            
            if rx_active = '1' then
                if rx_counter < baud_rate_divisor then
                    rx_counter <= rx_counter + 1;
                    baud_en_rx <= '0';
                else
                    rx_counter <= 0;
                    baud_en_rx <= '1';
                end if;
            else
                rx_counter <= 0;
                baud_en_rx <= '0';
            end if;
            
            if tx_active = '1' then
                if tx_counter < baud_rate_divisor then
                    tx_counter <= tx_counter + 1;
                    baud_en_tx <= '0';
                else
                    tx_counter <= 0;
                    baud_en_tx <= '1';
                end if;
            else
                tx_counter <= 0;
                baud_en_tx <= '0';
            end if;
        end if;
    end process;
end behav;