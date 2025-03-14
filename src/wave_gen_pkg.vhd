library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package wave_gen_pkg is

    -- Type declarations
    type baudrate_array is array (0 to 7, 0 to 7) of std_logic_vector(7 downto 0);
    type version_array is array (0 to 15) of std_logic_vector(7 downto 0);

    -- Constant declarations
    constant VERSION: version_array := (
        x"45", -- E
        x"4C", -- L
        x"45", -- E
        x"43", -- C
        x"54", -- T
        x"52", -- R
        x"41", -- A
        x"49", -- I
        x"43", -- C
        x"5F", -- _
        x"56", -- V
        x"31", -- 1
        x"5F", -- _
        x"30", -- 0
        x"0A", -- Line Feed
        x"0D"  -- Carriage Return
    );

    constant BAUDRATE: baudrate_array := (
        (x"30", x"30", x"39", x"36", x"30", x"30", x"0A", x"0D"), -- 009600
        (x"30", x"30", x"39", x"36", x"30", x"30", x"0A", x"0D"), -- 009600
        (x"30", x"31", x"39", x"32", x"30", x"30", x"0A", x"0D"), -- 019200
        (x"30", x"33", x"38", x"34", x"30", x"30", x"0A", x"0D"), -- 038400
        (x"30", x"35", x"37", x"36", x"30", x"30", x"0A", x"0D"), -- 057600
        (x"31", x"31", x"35", x"32", x"30", x"30", x"0A", x"0D"), -- 115200
        (x"30", x"30", x"39", x"36", x"30", x"30", x"0A", x"0D"), -- 009600
        (x"30", x"30", x"39", x"36", x"30", x"30", x"0A", x"0D")  -- 009600
    );
    constant control_bit: std_logic_vector (7 downto 0):= "00110000";


end package wave_gen_pkg;