library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_top_tb is
end uart_top_tb;

architecture Behavioral of uart_top_tb is
    signal clk             : std_logic := '0';
    signal sw              : std_logic_vector(2 downto 0) := "000";
    signal rx_din          : std_logic := '0';
    signal tx_data         : std_logic_vector(7 downto 0) := (others => '0');
    signal tx_send         : std_logic := '0';
    
    signal tx_dout         : std_logic;
    signal tx_active       : std_logic;
    signal rx_data_ready   : std_logic;
    signal rx_data         : std_logic_vector(7 downto 0);
    
    
    constant c_hex43       : std_logic_vector (9 downto 0) := '1' & x"43" & '0'; 
    constant c_hex66       : std_logic_vector (9 downto 0) := '1' & x"66" & '0'; 
    constant c_hex40       : std_logic_vector (9 downto 0) := '1' & x"40" & '0'; 
    constant c_baud9600    : time := 0.104ms;
    
    signal s_clk_1           : std_logic := '0';
    signal s_sw_1              : std_logic_vector(2 downto 0) := "000";
    signal s_rx_din_1          : std_logic := '0';
    signal s_tx_data_1         : std_logic_vector(7 downto 0) := (others => '0');
    signal s_tx_send_1         : std_logic := '0';
    signal s_tx_dout_1         : std_logic;
    signal s_tx_active_1       : std_logic;
    signal s_rx_data_ready_1   : std_logic;
    signal s_rx_data_1         : std_logic_vector(7 downto 0);
    
    signal s_clk_2           : std_logic := '0';
    signal s_sw_2              : std_logic_vector(2 downto 0) := "000";
    signal s_rx_din_2          : std_logic := '0';
    signal s_tx_data_2         : std_logic_vector(7 downto 0) := (others => '0');
    signal s_tx_send_2         : std_logic := '0';
    signal s_tx_dout_2         : std_logic;
    signal s_tx_active_2       : std_logic;
    signal s_rx_data_ready_2   : std_logic;
    signal s_rx_data_2         : std_logic_vector(7 downto 0);     

begin

        dut1: entity work.uart_top
        generic map(
            osc_freq        => 100_000_000,
            width           => 8,
            no_of_sample    => 16
        )
        port map(
            clk             => clk,
            sw              => s_sw_1,
            rx_din          => s_rx_din_1,
            tx_data         => s_tx_data_1,
            tx_send         => s_tx_send_1,
            tx_dout         => s_tx_dout_1,
            tx_active       => s_tx_active_1,
            rx_data_ready   => s_rx_data_ready_1,
            rx_data         => s_rx_data_1
        );
        
        
          dut2: entity work.uart_top
        generic map(
            osc_freq        => 100_000_000,
            width           => 8,
            no_of_sample    => 16
        )
        port map(
            clk             => clk,
            sw              => s_sw_2,
            rx_din          => s_tx_dout_1,
            tx_data         => s_tx_data_2,
            tx_send         => s_tx_send_2,
            tx_dout         => s_rx_din_1,
            tx_active       => s_tx_active_2,
            rx_data_ready   => s_rx_data_ready_2,
            rx_data         => s_rx_data_2
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
    
--clk             : in std_logic;                                                                           
--rst             : in std_logic;                                                                         
--sw              : in std_logic_vector(2 downto 0);                                                        
--rx_din          : in std_logic;                                                                           
--tx_data         : in std_logic_vector(7 downto 0);    --cmd handler ýn outu buraya deðer olarak gelecek   
--tx_send         : in std_logic;                                                                           
                                                                                                          
--tx_dout         : out std_logic;                      --wave_gen_top çýkýþý                               
--tx_active       : out std_logic;                      --cmd handler giriþleri                             
--rx_data_ready   : out std_logic;                      --cmd handler giriþleri                             
--rx_data         : out std_logic_vector(7 downto 0)    --cmd handler giriþleri                             
        sw          <= "001";                                                                                                   
        s_tx_data_1 <= "00110101";  
        s_tx_send_1 <= '1';
        wait for 10 ns;
        s_tx_send_1 <= '0';
        wait until s_rx_data_ready_2 = '1';
        wait for 50 ns;

    
    
    
        assert false
        report "SIM DONE"
        severity failure;
        
    end process;

end Behavioral;