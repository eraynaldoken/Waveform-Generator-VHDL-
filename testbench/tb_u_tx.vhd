library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_u_tx is
end tb_u_tx;

architecture testbench of tb_u_tx is

    -- Component declaration of the tested unit
    component u_tx
    Generic(
        width           : integer := 8;
        no_of_sample    : integer := 16
    );
    Port(
        clk         : in std_logic;
        tx_send     : in std_logic;
        data_in     : in std_logic_vector(7 downto 0);
        baud_en_tx  : in std_logic;
        tx_data_out : out std_logic;
        tx_active   : out std_logic
    );
    end component;

    -- Signals to connect to the tested unit
    signal clk         : std_logic := '0';
    signal tx_send     : std_logic := '0';
    signal data_in     : std_logic_vector(7 downto 0) := (others => '0');
    signal baud_en_tx  : std_logic := '0';
    signal tx_data_out : std_logic;
    signal tx_active   : std_logic;

    -- Clock period definition
    constant clk_period : time := 10 ns;
    constant c_baud9600    : time := 0.104ms;
    constant c_hex66       : std_logic_vector (9 downto 0) := '1' & x"66" & '0'; 
    constant c_hex40       : std_logic_vector (9 downto 0) := '1' & x"40" & '0'; 
begin

    -- Instantiate the unit under test (UUT)
    uut: u_tx
        port map (
            clk => clk,
            tx_send => tx_send,
            data_in => data_in,
            baud_en_tx => baud_en_tx,
            tx_data_out => tx_data_out,
            tx_active => tx_active
        );

P_CLKGEN : process begin

clk <= '0';
wait for clk_period/2;
clk <= '1';
wait for clk_period/2;


end process P_CLKGEN;


bauder : process begin

baud_en_tx <= '0';
wait for c_baud9600/16;
baud_en_tx <= '1';
wait for 10ns;


end process bauder;


P_STIMULI : process begin

wait for clk_period*10;

--        tx_send     : in std_logic;
--        data_in     : in std_logic_vector(7 downto 0);
--        baud_en_tx  : in std_logic;


--for i in 0 to 9 loop 

--data_in <= c_hex43(i);
--wait for c_baud9600;

--end loop;

--wait for 200 us;

wait for 200 us;
      
        tx_send <= '0';
        data_in <= "00000000";
        wait for c_baud9600 * 10;

    
        
        data_in <= "01010101";
        tx_send <= '1'; 
        wait for 10ns;
        tx_send <= '0'; 
      wait for c_baud9600 * 10;

       
        data_in <= "11100000";
        tx_send <= '1'; 
        wait for 10ns;
        tx_send <= '0'; 
        wait for c_baud9600 * 10;


       



assert false
report "SIM DONE"
severity failure;


end process P_STIMULI;

end testbench;

